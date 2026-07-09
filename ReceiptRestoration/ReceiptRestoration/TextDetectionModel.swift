//
//  TextDetectionModel.swift
//  MBG Receipt Restoration
//
//  Created by Nicholas Tristandi on 18/05/26.
//

import Foundation
import UIKit
import onnxruntime_objc

#if canImport(onnxruntime_objc)
class TextDetectionModel {
    private var session: ORTSession?
    private var env: ORTEnv?

    init() {
        setupModel()
    }

    private func setupModel() {
        do {
            env = try ORTEnv(loggingLevel: .warning)

            // IMPORTANT: extension must be lowercase "onnx"
            guard let modelPath = Bundle.main.path(forResource: "det_model", ofType: "onnx") else {
                print("Error: Could not find det.onnx in bundle")
                return
            }

            let options = try ORTSessionOptions()

            guard let env = env else {
                print("Error: Environment not initialized")
                return
            }

            session = try ORTSession(env: env, modelPath: modelPath, sessionOptions: options)
            print("Text Detection ONNX session created successfully")

        } catch {
            print("Error setting up Text Detection model: \(error)")
        }
    }

    // Detects text regions in an image
    // - Parameter image: Input image
    // - Returns: Probability map as float array with dimensions
    func detect(_ image: UIImage) async throws -> (probabilityMap: [Float], width: Int, height: Int) {
        guard let session = session else {
            throw ModelError.sessionNotInitialized
        }

        // Preprocess image to 640x640
        let targetSize = 640
        guard let (inputData, _, _) = preprocessImageForDetection(image, targetSize: targetSize) else {
            throw ModelError.imagePreprocessingFailed
        }

        // Create input tensor [1, 3, 640, 640]
        let inputShape: [NSNumber] = [
            1, // Same as p2o.DynamicDimension, but set it into 1 image per process
            3,
            NSNumber(value: targetSize), // Same as p2o.DynamicDimension
            NSNumber(value: targetSize)] // Same as p2o.DynamicDimension
        let inputTensor = try ORTValue(
            tensorData: NSMutableData(data: Data(bytes: inputData, count: inputData.count * MemoryLayout<Float>.size)),
            elementType: .float,
            shape: inputShape
        )

        // Run inference with input name "x" and output name "sigmoid_0.tmp_0"
        let inputs = ["x": inputTensor]
        let outputs = try session.run(
            withInputs: inputs,
            outputNames: ["fetch_name_0"],
            runOptions: nil
        )

        // Get output tensor [1, 1, H, W] - probability map
        guard let outputTensor = outputs["fetch_name_0"] else {
            throw ModelError.outputNotFound
        }

        // Extract float array
        let outputData = try outputTensor.tensorData() as Data
        let floatCount = outputData.count / MemoryLayout<Float>.size
        var floatArray = [Float](repeating: 0, count: floatCount)

        outputData.withUnsafeBytes { (pointer: UnsafeRawBufferPointer) in
            if let baseAddress = pointer.baseAddress {
                floatArray = Array(UnsafeBufferPointer(
                    start: baseAddress.assumingMemoryBound(to: Float.self),
                    count: floatCount
                ))
            }
        }

        // Return probability map with dimensions
        return (floatArray, targetSize, targetSize)
    }

    // Preprocesses image for detection model
    private func preprocessImageForDetection(_ image: UIImage, targetSize: Int) -> (data: [Float], originalSize: CGSize, processedSize: CGSize)? {
        let target = CGSize(width: targetSize, height: targetSize)

        // Resize with aspect ratio and padding
        guard let resizedImage = ImageProcessor.resizeImage(image, targetSize: target) else {
            return nil
        }

        guard let cgImage = resizedImage.cgImage else {
            return nil
        }

        let width = cgImage.width
        let height = cgImage.height

        // Create bitmap context
        guard let context = CGContext(
            data: nil,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: width * 4,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue
        ) else {
            return nil
        }

        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))

        guard let pixelBuffer = context.data else {
            return nil
        }

        let pixels = pixelBuffer.assumingMemoryBound(to: UInt8.self)
        let pixelCount = width * height

        // Convert to NCHW format [batch, channels, height, width]
        // PaddleOCR uses mean=[0.5, 0.5, 0.5], std=[0.5, 0.5, 0.5] normalization
        // Formula: (pixel/255.0 - mean) / std = (pixel/255.0 - 0.5) / 0.5
        // Note: PaddleOCR expects BGR format, but for detection RGB usually works
        var floatArray = [Float](repeating: 0, count: pixelCount * 3)

        let mean: Float = 0.5
        let std: Float = 0.5

        for i in 0..<pixelCount {
            let r = Float(pixels[i * 4 + 0]) / 255.0
            let g = Float(pixels[i * 4 + 1]) / 255.0
            let b = Float(pixels[i * 4 + 2]) / 255.0

//            // Normalize to [-1, 1] range
//            floatArray[i] = (r - mean) / std
//            floatArray[pixelCount + i] = (g - mean) / std
//            floatArray[pixelCount * 2 + i] = (b - mean) / std
            
            // Use B, G, R order :
            floatArray[i] = (b - mean) / std
            floatArray[pixelCount + i] = (g - mean) / std
            floatArray[pixelCount * 2 + i] = (r - mean) / std
        }

        return (floatArray, image.size, CGSize(width: width, height: height))
    }

    enum ModelError: Error, LocalizedError {
        case sessionNotInitialized
        case imagePreprocessingFailed
        case outputNotFound

        var errorDescription: String? {
            switch self {
            case .sessionNotInitialized:
                return "Text detection session not initialized"
            case .imagePreprocessingFailed:
                return "Failed to preprocess image for detection"
            case .outputNotFound:
                return "Detection model output not found"
            }
        }
    }
}
#else
class TextDetectionModel {
    init() {}

    func detect(_ image: UIImage) async throws -> (probabilityMap: [Float], width: Int, height: Int) {
        throw ModelError.onnxRuntimeUnavailable
    }

    enum ModelError: Error, LocalizedError {
        case onnxRuntimeUnavailable

        var errorDescription: String? {
            return "ONNX Runtime is not available"
        }
    }
}
#endif
