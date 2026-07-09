//
//  QualityAssessment.swift
//  ReceiptRestoration
//
//  Image quality assessment using Laplacian variance
//

import UIKit
import Accelerate

class QualityAssessment {

    /// Assesses image quality using blur detection
    /// - Parameter image: Input image to assess
    /// - Returns: Quality score from 0.0 (poor) to 1.0 (excellent)
    static func assessQuality(of image: UIImage) -> Double {
        guard let cgImage = image.cgImage else { return 0.5 }

        // Calculate blur score using Laplacian variance
        let blurScore = calculateLaplacianVariance(cgImage)

        // Normalize: typical sharp images have variance > 100
        // Blurry images have variance < 50
        let normalizedScore = min(blurScore / 100.0, 1.0)

        return normalizedScore
    }

    /// Determines if quality warning should be shown
    /// - Parameter score: Quality score from assessQuality
    /// - Returns: True if quality is below threshold
    static func shouldShowWarning(score: Double) -> Bool {
        return score < 0.5 // Show warning if quality score below 50%
    }

    // MARK: - Private Methods

    private static func calculateLaplacianVariance(_ cgImage: CGImage) -> Double {
        let width = cgImage.width
        let height = cgImage.height

        // Create grayscale context
        guard let context = CGContext(
            data: nil,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: width,
            space: CGColorSpaceCreateDeviceGray(),
            bitmapInfo: CGImageAlphaInfo.none.rawValue
        ) else {
            return 0.0
        }

        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))

        guard let data = context.data else { return 0.0 }

        let pixels = data.assumingMemoryBound(to: UInt8.self)

        // Apply Laplacian kernel (simplified 3x3)
        // Kernel: [0, 1, 0]
        //         [1,-4, 1]
        //         [0, 1, 0]
        var variance: Double = 0.0
        var count = 0

        for y in 1..<(height - 1) {
            for x in 1..<(width - 1) {
                let center = Int(pixels[y * width + x])
                let top = Int(pixels[(y - 1) * width + x])
                let bottom = Int(pixels[(y + 1) * width + x])
                let left = Int(pixels[y * width + (x - 1)])
                let right = Int(pixels[y * width + (x + 1)])

                let laplacian = abs(-4 * center + top + bottom + left + right)
                variance += Double(laplacian * laplacian)
                count += 1
            }
        }

        return count > 0 ? variance / Double(count) : 0.0
    }
}
