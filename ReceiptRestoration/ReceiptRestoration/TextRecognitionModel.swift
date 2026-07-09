//
//  TextRecognitionModel.swift
//  ReceiptRestoration
//
//  Created by Nicholas Tristandi on 18/05/26.
//

import Foundation
import UIKit
import onnxruntime_objc

#if canImport(onnxruntime_objc)
class TextRecognitionModel {
    private var session: ORTSession?
    private var env: ORTEnv?

    // PP-OCRv5 English character dictionary (437 characters + blank at index 0 = 438 total)
    // This is the full dictionary used by en_PP-OCRv5_mobile_rec
    // Source: https://github.com/PaddlePaddle/PaddleOCR/blob/main/ppocr/utils/en_dict.txt
    private let characters = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~ ĀāĂăĄąĆćĈĉĊċČčĎďĐđĒēĔĕĖėĘęĚěĜĝĞğĠġĢģĤĥĦħĨĩĪīĬĭĮįİıĲĳĴĵĶķĸĹĺĻļĽľĿŀŁłŃńŅņŇňŉŊŋŌōŎŏŐőŒœŔŕŖŗŘřŚśŜŝŞşŠšŢţŤťŦŧŨũŪūŬŭŮůŰűŲųŴŵŶŷŸŹźŻżŽžſƀƁƂƃƄƅƆƇƈƉƊƋƌƍƎƏƐƑƒƓƔƕƖƗƘƙƚƛƜƝƞƟƠơƢƣƤƥƦƧƨƩƪƫƬƭƮƯưƱƲƳƴƵƶƷƸƹƺƻƼƽƾƿǀǁǂǃǄǅǆǇǈǉǊǋǌǍǎǏǐǑǒǓǔǕǖǗǘǙǚǛǜǝǞǟǠǡǢǣǤǥǦǧǨǩǪǫǬǭǮǯǰǱǲǳǴǵǶǷǸǹǺǻǼǽǾǿ"

    init() {
        setupModel()
    }

    private func setupModel() {
        do {
            env = try ORTEnv(loggingLevel: .warning)

            // IMPORTANT: extension must be lowercase "onnx"
            guard let modelPath = Bundle.main.path(forResource: "rec_model", ofType: "onnx") else {
                print("Error: Could not find rec.onnx in bundle")
                return
            }

            let options = try ORTSessionOptions()

            guard let env = env else {
                print("Error: Environment not initialized")
                return
            }

            session = try ORTSession(env: env, modelPath: modelPath, sessionOptions: options)
            print("Text Recognition ONNX session created successfully")

        } catch {
            print("Error setting up Text Recognition model: \(error)")
        }
    }

    // Recognizes text from a cropped text region image
    // - Parameter image: Cropped image containing text
    // - Returns: Recognized text string
    func recognize(_ image: UIImage) async throws -> String {
        guard let session = session else {
            throw ModelError.sessionNotInitialized
        }

        // Preprocess: resize to height=48, width proportional (max 320)
        guard let (inputData, width) = preprocessImageForRecognition(image) else {
            throw ModelError.imagePreprocessingFailed
        }

        // Create input tensor [1, 3, 48, W]
        let inputShape: [NSNumber] = [NSNumber(value : 1), 3, 48, NSNumber(value: width)]
        let inputTensor = try ORTValue(
            tensorData: NSMutableData(data: Data(bytes: inputData, count: inputData.count * MemoryLayout<Float>.size)),
            elementType: .float,
            shape: inputShape
        )

        // Run inference with input name "x" and output name "softmax_2.tmp_0"
        let inputs = ["x": inputTensor]
        let outputs = try session.run(
            withInputs: inputs,
            outputNames: ["fetch_name_0"],
            runOptions: nil
        )

        // Get output tensor [batch, sequence_length, num_classes]
        guard let outputTensor = outputs["fetch_name_0"] else {
            throw ModelError.outputNotFound
        }

        // Get output shape for debugging
        let outputShape = try outputTensor.tensorTypeAndShapeInfo().shape
        print("DEBUG: Output shape: \(outputShape)")

        // Extract probabilities
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

        // Debug: Print sample values
        print("DEBUG: First 10 output values: \(Array(floatArray.prefix(10)))")
        print("DEBUG: Total output elements: \(floatCount)")

        // Get num_classes from shape (last dimension)
        let numClasses = Int(truncating: outputShape.last ?? 97)

        // Decode to text
        let text = decodeOutput(floatArray, numClasses: numClasses)
        print("DEBUG: Decoded text: '\(text)'")
        return text
    }

    // Preprocesses image for recognition model (height must be 48)
    private func preprocessImageForRecognition(_ image: UIImage) -> (data: [Float], width: Int)? {
        let targetHeight = 48
        let maxWidth = 320

        // Calculate proportional width
        let aspectRatio = image.size.width / image.size.height
        var targetWidth = Int(Double(targetHeight) * aspectRatio)

        // Clamp to max width
        if targetWidth > maxWidth {
            targetWidth = maxWidth
        }

        // Ensure width is at least 10
        if targetWidth < 10 {
            targetWidth = 10
        }

        let targetSize = CGSize(width: targetWidth, height: targetHeight)

        // Resize image
        UIGraphicsBeginImageContextWithOptions(targetSize, false, 1.0)
        defer { UIGraphicsEndImageContext() }

        image.draw(in: CGRect(origin: .zero, size: targetSize))
        guard let resizedImage = UIGraphicsGetImageFromCurrentImageContext() else {
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

        // Convert to NCHW format with PaddleOCR normalization
        // PaddleOCR uses mean=[0.5, 0.5, 0.5], std=[0.5, 0.5, 0.5]
        // Formula: (pixel/255.0 - mean) / std = (pixel/255.0 - 0.5) / 0.5
        // This normalizes to [-1, 1] range
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

        return (floatArray, width)
    }

    // Decodes model output to text using greedy CTC decoding
    // Output shape: [batch, sequence_length, num_classes]
    // CTC: Index 0 = blank, Index 1-N = characters
    private func decodeOutput(_ output: [Float], numClasses: Int) -> String {
        // Calculate sequence length from total output size and num_classes
        let sequenceLength = output.count / numClasses

        print("DEBUG: Decoding - sequence length: \(sequenceLength), num classes: \(numClasses)")
        print("DEBUG: Character dictionary size: \(characters.count)")

        var result = ""
        var lastIndex = -1

        // Greedy decoding: take argmax at each timestep
        for t in 0..<sequenceLength {
            let startIdx = t * numClasses
            let endIdx = startIdx + numClasses

            // Find index with max probability
            var maxIdx = 0
            var maxVal: Float = -Float.infinity

            for i in 0..<numClasses {
                let val = output[startIdx + i]
                if val > maxVal {
                    maxVal = val
                    maxIdx = i
                }
            }

            // Debug first few timesteps
            if t < 5 {
                print("DEBUG: Timestep \(t), maxIdx=\(maxIdx), maxVal=\(maxVal)")
            }

            // CTC decoding: skip blank (index 0) and repeated characters
            // Model outputs: 0=blank, 1=first char, 2=second char, etc.
            if maxIdx != 0 && maxIdx != lastIndex {
                // Subtract 1 because model index 1 = characters[0]
                let charIndex = maxIdx - 1
                if charIndex >= 0 && charIndex < characters.count {
                    let char = characters[characters.index(characters.startIndex, offsetBy: charIndex)]
                    result.append(char)
                    print("DEBUG: Added character '\(char)' from index \(maxIdx)")
                }
            }

            lastIndex = maxIdx
        }

        return result
    }

    enum ModelError: Error, LocalizedError {
        case sessionNotInitialized
        case imagePreprocessingFailed
        case outputNotFound

        var errorDescription: String? {
            switch self {
            case .sessionNotInitialized:
                return "Text recognition session not initialized"
            case .imagePreprocessingFailed:
                return "Failed to preprocess image for recognition"
            case .outputNotFound:
                return "Recognition model output not found"
            }
        }
    }
}
#else
class TextRecognitionModel {
    init() {}

    func recognize(_ image: UIImage) async throws -> String {
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

