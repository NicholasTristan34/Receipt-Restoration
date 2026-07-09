//
//  VisionTextRecognizer.swift
//  ReceiptRestoration
//
//  Created by Claude Code
//

import Foundation
import UIKit
import Vision

class VisionTextRecognizer {

    /// Recognizes text from an image using Apple's Vision framework
    /// - Parameter image: Input image to recognize text from
    /// - Returns: Array of recognized text observations with text content and bounding boxes
    func recognizeText(from image: UIImage) async throws -> [TextObservation] {
        guard let cgImage = image.cgImage else {
            throw RecognitionError.invalidImage
        }

        return try await withCheckedThrowingContinuation { continuation in
            // Create text recognition request
            let request = VNRecognizeTextRequest { request, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }

                guard let observations = request.results as? [VNRecognizedTextObservation] else {
                    continuation.resume(throwing: RecognitionError.noTextFound)
                    return
                }

                // Convert to our TextObservation type
                let textObservations = observations.compactMap { observation -> TextObservation? in
                    guard let topCandidate = observation.topCandidates(1).first else {
                        return nil
                    }

                    // Convert normalized coordinates to image coordinates
                    let boundingBox = observation.boundingBox
                    let imageRect = self.convertVisionRect(
                        boundingBox,
                        imageSize: CGSize(width: cgImage.width, height: cgImage.height)
                    )

                    return TextObservation(
                        text: topCandidate.string,
                        confidence: topCandidate.confidence,
                        boundingBox: imageRect
                    )
                }

                print("=== VISION TEXT RECOGNITION ===")
                print("Found \(textObservations.count) text regions")
                for (i, obs) in textObservations.enumerated() {
                    print("  \(i+1). \"\(obs.text)\" (confidence: \(String(format: "%.2f", obs.confidence)))")
                }
                print("================================")

                continuation.resume(returning: textObservations)
            }

            // Configure request for best accuracy
            request.recognitionLevel = .accurate
            request.usesLanguageCorrection = true

            // Support multiple languages if needed
            request.recognitionLanguages = ["en-US", "id-ID"] // English and Indonesian

            // Perform request
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            do {
                try handler.perform([request])
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }

    /// Recognizes text and returns all text as a single string
    /// - Parameter image: Input image
    /// - Returns: Concatenated text from all observations
    func recognizeTextAsString(from image: UIImage) async throws -> String {
        let observations = try await recognizeText(from: image)

        // Sort observations by vertical position (top to bottom)
        let sorted = observations.sorted { $0.boundingBox.minY < $1.boundingBox.minY }

        // Join text with newlines
        return sorted.map { $0.text }.joined(separator: "\n")
    }

    /// Detects text regions without recognizing the text
    /// - Parameter image: Input image
    /// - Returns: Array of bounding boxes where text was detected
    func detectTextRegions(from image: UIImage) async throws -> [CGRect] {
        guard let cgImage = image.cgImage else {
            throw RecognitionError.invalidImage
        }

        return try await withCheckedThrowingContinuation { continuation in
            // Create text detection request (faster than recognition)
            let request = VNDetectTextRectanglesRequest { request, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }

                guard let observations = request.results as? [VNTextObservation] else {
                    continuation.resume(throwing: RecognitionError.noTextFound)
                    return
                }

                // Convert to image coordinates
                let rects = observations.map { observation -> CGRect in
                    self.convertVisionRect(
                        observation.boundingBox,
                        imageSize: CGSize(width: cgImage.width, height: cgImage.height)
                    )
                }

                print("=== VISION TEXT DETECTION ===")
                print("Found \(rects.count) text regions")
                print("==============================")

                continuation.resume(returning: rects)
            }

            request.reportCharacterBoxes = true

            // Perform request
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            do {
                try handler.perform([request])
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }

    /// Converts Vision's normalized coordinates (0-1, origin bottom-left) to image coordinates (origin top-left)
    private func convertVisionRect(_ visionRect: CGRect, imageSize: CGSize) -> CGRect {
        // Vision uses normalized coordinates with origin at bottom-left
        // We need to convert to image coordinates with origin at top-left

        let x = visionRect.minX * imageSize.width
        let y = (1 - visionRect.maxY) * imageSize.height // Flip Y axis
        let width = visionRect.width * imageSize.width
        let height = visionRect.height * imageSize.height

        return CGRect(x: x, y: y, width: width, height: height)
    }

    // MARK: - Types

    struct TextObservation {
        let text: String
        let confidence: Float
        let boundingBox: CGRect
    }

    enum RecognitionError: Error, LocalizedError {
        case invalidImage
        case noTextFound

        var errorDescription: String? {
            switch self {
            case .invalidImage:
                return "Invalid image format"
            case .noTextFound:
                return "No text found in image"
            }
        }
    }
}
