//
//  ActionButtonsSection.swift
//  MBG Receipt Restoration
//
//  Created by Nicholas Tristandi on 20/05/26.
//

import SwiftUI


struct ActionButtonsSection: View {
    let selectedImage: UIImage?
    let restoredImage: UIImage?
    let isProcessing: Bool
    let onPhotoLibrary: () -> Void
    let onCamera: () -> Void
    let onRestore: () -> Void
    let onSave: () -> Void
    let onClear: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            // Select Image Buttons
            HStack(spacing: 12) {
                Button(action: onPhotoLibrary) {
                    Label("Photo Library", systemImage: "photo.on.rectangle")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .controlSize(.large)

                Button(action: onCamera) {
                    Label("Camera", systemImage: "camera")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .controlSize(.large)
            }

            // Restore Button
            if selectedImage != nil {
                Button(action: onRestore) {
                    if isProcessing {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .frame(maxWidth: .infinity)
                    } else {
                        Label("Restore Receipt", systemImage: "camera.macro.circle")
                            .frame(maxWidth: .infinity)
                    }
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .disabled(isProcessing)
            }

            // Save Button
            if restoredImage != nil {
                Button(action: onSave) {
                    Label("Save to Photos", systemImage: "square.and.arrow.down")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .controlSize(.large)
            }

            // Clear Button
            if selectedImage != nil || restoredImage != nil {
                Button(role: .destructive, action: onClear) {
                    Label("Clear", systemImage: "trash")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .controlSize(.large)
            }
        }
    }
}
