//
//  ImageDisplaySection.swift
//  MBG Receipt Restoration
//
//  Created by Nicholas Tristandi on 20/05/26.
//

import SwiftUI

struct ImageDisplaySection: View {
    let selectedImage: UIImage?
    let restoredImage: UIImage?
    @Binding var showComparison: Bool
    @Binding var comparisonSliderValue: Double

    var body: some View {
        if selectedImage != nil || restoredImage != nil {
            VStack(spacing: 16) {
                // Comparison Toggle
                if selectedImage != nil && restoredImage != nil {
                    Picker("View Mode", selection: $showComparison) {
                        Text("Side by Side").tag(false)
                        Text("Comparison").tag(true)
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                }

                if showComparison && selectedImage != nil && restoredImage != nil {
                    // Comparison Slider View
                    ComparisonSliderView(
                        beforeImage: selectedImage!,
                        afterImage: restoredImage!,
                        sliderValue: $comparisonSliderValue
                    )
                    .frame(height: 400)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal)
                } else {
                    // Side by Side View (centered)
                    HStack(spacing: 16) {
                        if let selectedImage = selectedImage {
                            ImageCard(image: selectedImage, label: "Original")
                        }

                        if let restoredImage = restoredImage {
                            ImageCard(image: restoredImage, label: "Restored")
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.horizontal)
                }
            }
        } else {
            // Placeholder
            PlaceholderView()
                .padding(.horizontal)
        }
    }
}
