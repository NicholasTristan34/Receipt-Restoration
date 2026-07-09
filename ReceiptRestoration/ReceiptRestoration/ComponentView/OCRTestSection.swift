//
//  OCRTestSection.swift
//  MBG Receipt Restoration
//
//  Created by Nicholas Tristandi on 20/05/26.
//

import SwiftUI

struct OCRTestSection: View {
    let selectedImage: UIImage?
    let isTestingOCR: Bool
    let onTestDetection: () -> Void
    let onTestRecognition: () -> Void
    let onTestVision: () -> Void

    var body: some View {
        if selectedImage != nil {
            VStack(spacing: 12) {
                Divider()
                    .padding(.vertical, 8)

                Text("OCR Tests")
                    .font(.headline)
                    .foregroundColor(.secondary)

                VStack(spacing: 12) {
                    // Recommended: Vision OCR
                    Button(action: onTestVision) {
                        HStack {
                            Label("Vision OCR (Recommended)", systemImage: "text.viewfinder")
                            Spacer()
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                                .font(.caption)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .disabled(isTestingOCR)

                    // ONNX Models (experimental)
                    DisclosureGroup("ONNX Models (Experimental)") {
                        VStack(spacing: 8) {
                            Button(action: onTestDetection) {
                                Label("Test Detection", systemImage: "rectangle.3.group")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.bordered)
                            .controlSize(.regular)
                            .disabled(isTestingOCR)

                            Button(action: onTestRecognition) {
                                Label("Test Recognition", systemImage: "doc.text.magnifyingglass")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.bordered)
                            .controlSize(.regular)
                            .disabled(isTestingOCR)
                        }
                        .padding(.top, 8)
                    }
                    .font(.caption)
                }

                if isTestingOCR {
                    ProgressView("Testing OCR...")
                        .padding(.top, 8)
                }
            }
        }
    }
}
