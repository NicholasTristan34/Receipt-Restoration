//
//  EmptyScreen.swift
//  ReceiptRestoration
//
//  First-launch / empty state screen
//

import SwiftUI

struct EmptyScreen: View {
    let onPickFromGallery: () -> Void
    let onTakePhoto: () -> Void

    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("STRUK")
                        .font(.appLabelUppercase)
                        .foregroundColor(.appAccent)
                        .tracking(1.6)

                    Spacer()

                    Button(action: {}) {
                        Image(systemName: "info.circle")
                            .font(.system(size: 16))
                            .foregroundColor(.appAccent)
                    }
                    .iconButtonStyle(size: 32, backgroundColor: Color.appAccentDim)
                }
                .padding(.top, Spacing.topPadding)
                .padding(.horizontal, Spacing.gutter)

                Spacer()

                // Empty State Illustration
                VStack(spacing: Spacing.xl) {
                    // Fanned Receipt Cards with Sparkle
                    ZStack {
                        // Card 1 (degraded, left)
                        MiniReceiptCard(variant: .degraded)
                            .rotationEffect(.degrees(-14))
                            .offset(x: -40, y: 0)
                            .scaleEffect(0.85)

                        // Card 2 (degraded, center)
                        MiniReceiptCard(variant: .degraded)
                            .rotationEffect(.degrees(3))
                            .scaleEffect(0.85)

                        // Card 3 (restored, right)
                        MiniReceiptCard(variant: .restored)
                            .rotationEffect(.degrees(16))
                            .offset(x: 40, y: 0)
                            .scaleEffect(0.85)

                        // Sparkle Overlay
                        VStack {
                            HStack {
                                Spacer()

                                ZStack {
                                    Circle()
                                        .fill(Color.appAccent)
                                        .frame(width: 38, height: 38)
                                        .shadow(color: Color.appAccent.opacity(0.4), radius: 10, x: 0, y: 6)

                                    Image(systemName: "sparkles")
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(.white)
                                }
                                .offset(x: 20, y: -10)
                            }

                            Spacer()
                        }
                        .frame(height: 180)
                    }
                    .frame(height: 180)

                    // Text
                    VStack(spacing: Spacing.sm) {
                        Text("No Receipts Yet")
                            .font(.appTitle)
                            .foregroundColor(.appText)
                            .tracking(-0.5)

                        Text("Pick a faded or blurry receipt photo\nand let AI make it clearer.")
                            .font(.appBody)
                            .foregroundColor(.appText3)
                            .multilineTextAlignment(.center)
                            .lineSpacing(5)
                    }
                }

                Spacer()

                // Bottom Actions
                VStack(spacing: 4) {
                    Button(action: onPickFromGallery) {
                        HStack(spacing: 8) {
                            Image(systemName: "photo.on.rectangle.angled")
                                .font(.system(size: 20, weight: .medium))

                            Text("Pick from Gallery")
                        }
                    }
                    .primaryButtonStyle()

                    Button(action: onTakePhoto) {
                        HStack(spacing: 8) {
                            Image(systemName: "camera")
                                .font(.system(size: 18, weight: .medium))

                            Text("Take Photo")
                        }
                    }
                    .ghostButtonStyle()
                }
                .padding(.horizontal, Spacing.gutter)
                .padding(.bottom, 38)
            }
        }
    }
}

// MARK: - Mini Receipt Card

struct MiniReceiptCard: View {
    enum Variant {
        case degraded, restored
    }

    let variant: Variant

    var body: some View {
        ZStack {
            // Card Background
            RoundedRectangle(cornerRadius: 12)
                .fill(variant == .restored ? Color.white : Color(hex: "F5F1E8"))
                .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)

            // Receipt Lines
            VStack(spacing: 3) {
                // Title line (thicker)
                RoundedRectangle(cornerRadius: 1)
                    .fill(Color.appText.opacity(variant == .restored ? 0.9 : 0.4))
                    .frame(height: 3)
                    .padding(.horizontal, 16)

                // Subtitle
                RoundedRectangle(cornerRadius: 0.5)
                    .fill(Color.appText.opacity(variant == .restored ? 0.6 : 0.3))
                    .frame(height: 2)
                    .frame(width: 80)

                Spacer().frame(height: 8)

                // Item lines
                ForEach(0..<8) { _ in
                    RoundedRectangle(cornerRadius: 0.5)
                        .fill(Color.appText.opacity(variant == .restored ? 0.5 : 0.25))
                        .frame(height: 2)
                        .padding(.horizontal, 12)
                }

                Spacer().frame(height: 6)

                // Total line (thicker)
                RoundedRectangle(cornerRadius: 1)
                    .fill(Color.appText.opacity(variant == .restored ? 0.8 : 0.35))
                    .frame(height: 3)
                    .padding(.horizontal, 16)
            }
            .padding(.vertical, 16)
        }
        .frame(width: 120, height: 180)
        .opacity(variant == .restored ? 1.0 : 0.85)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.appSeparator.opacity(0.5), lineWidth: 1)
        )
    }
}

#Preview {
    EmptyScreen(
        onPickFromGallery: {},
        onTakePhoto: {}
    )
}
