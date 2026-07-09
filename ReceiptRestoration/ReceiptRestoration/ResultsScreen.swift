//
//  ResultsScreen.swift
//  ReceiptRestoration
//
//  Results screen with before/after comparison and metrics
//

import SwiftUI

struct ResultsScreen: View {
    let beforeImage: UIImage
    let afterImage: UIImage
    let processingTime: Double
    let onViewData: () -> Void
    let onSave: () -> Void
    let onClose: () -> Void

    @State private var sliderValue: Double = 0.5

    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Top Bar
                HStack {
                    Button(action: onClose) {
                        Image(systemName: "xmark")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.appText)
                    }
                    .iconButtonStyle()

                    Spacer()

                    // Status Pill
                    HStack(spacing: 6) {
                        Circle()
                            .fill(Color.appSuccess)
                            .frame(width: 6, height: 6)

                        Text("Restoration complete · \(String(format: "%.1f", processingTime))s")
                            .font(.appCaption2)
                            .foregroundColor(.appText2)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.appCard)
                    .cornerRadius(CornerRadius.pill)
                    .overlay(
                        RoundedRectangle(cornerRadius: CornerRadius.pill)
                            .stroke(Color.appSeparator, lineWidth: 1)
                    )

                    Spacer()

                    // Spacer for symmetry
                    Color.clear
                        .frame(width: 36, height: 36)
                }
                .padding(.horizontal, Spacing.gutter)
                .padding(.top, Spacing.topPadding)

                ScrollView {
                    VStack(alignment: .leading, spacing: Spacing.xl) {
                        // Title Section
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Slide to Compare")
                                .font(.appTitle)
                                .foregroundColor(.appText)
                                .tracking(-0.6)

                            Text("Drag the line to see the restoration results.")
                                .font(.appCaption)
                                .foregroundColor(.appText3)
                        }
                        .padding(.horizontal, Spacing.gutter)
                        .padding(.top, Spacing.xl)

                        // Before/After Slider
                        ComparisonSliderView(
                            beforeImage: beforeImage,
                            afterImage: afterImage,
                            sliderValue: $sliderValue
                        )
                        .frame(height: 380)
                        .padding(.horizontal, Spacing.gutter)

                        // Metrics Grid
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                            MetricCard(label: "SHARPNESS", value: "Enhanced", isPositive: true)
                            MetricCard(label: "NOISE", value: "Reduced", isPositive: true)
                            MetricCard(label: "OCR", value: "Captures", isPositive: true)
                        }
                        .padding(.horizontal, Spacing.gutter)

                        // View Data Card
                        Button(action: onViewData) {
                            HStack(spacing: Spacing.md) {
                                // Icon
                                ZStack {
                                    RoundedRectangle(cornerRadius: CornerRadius.sm)
                                        .fill(Color.appAccentDim)
                                        .frame(width: 36, height: 36)

                                    Image(systemName: "doc.text")
                                        .font(.system(size: 18, weight: .medium))
                                        .foregroundColor(.appAccent)
                                }

                                // Text
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("View Extracted Data")
                                        .font(.appBodyBold)
                                        .foregroundColor(.appText)
                                        .tracking(-0.3)

                                    Text("OCR results may not be fully accurate.")
                                        .font(.appCaption2)
                                        .foregroundColor(.appText3)
                                }

                                Spacer()

                                Image(systemName: "chevron.right")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.appText4)
                            }
                            .padding(Spacing.md)
                            .background(Color.appCard)
                            .cornerRadius(CornerRadius.lg)
                            .overlay(
                                RoundedRectangle(cornerRadius: CornerRadius.lg)
                                    .stroke(Color.appSeparator, lineWidth: 1)
                            )
                        }
                        .padding(.horizontal, Spacing.gutter)
                        .padding(.bottom, 100) // Space for bottom bar
                    }
                }

                // Bottom Action Bar
                HStack(spacing: Spacing.sm) {
                    Button(action: {}) {
                        HStack(spacing: 8) {
                            Image(systemName: "doc.on.doc")
                                .font(.system(size: 16, weight: .medium))

                            Text("Copy Text")
                        }
                    }
                    .secondaryButtonStyle()

                    Button(action: onSave) {
                        HStack(spacing: 8) {
                            Image(systemName: "square.and.arrow.down")
                                .font(.system(size: 16, weight: .medium))

                            Text("Save")
                        }
                    }
                    .primaryButtonStyle()
                }
                .padding(.horizontal, Spacing.gutter)
                .padding(.top, Spacing.md)
                .padding(.bottom, 38)
                .background(
                    LinearGradient.appFadeUp
                        .frame(height: 120)
                        .offset(y: -80)
                        .allowsHitTesting(false)
                )
            }
        }
    }
}

// MARK: - Metric Card

struct MetricCard: View {
    let label: String
    let value: String
    let isPositive: Bool

    var body: some View {
        VStack(spacing: 6) {
            Text(label)
                .font(.appLabelUppercase)
                .foregroundColor(.appText3)
                .tracking(0.4)

            Text(value)
                .font(.appHeadline)
                .fontWeight(.bold)
                .foregroundColor(isPositive ? .appSuccess : .appText)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Spacing.sm)
        .background(Color.appCard)
        .cornerRadius(CornerRadius.md)
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.md)
                .stroke(Color.appSeparator, lineWidth: 1)
        )
    }
}

#Preview {
    ResultsScreen(
        beforeImage: UIImage(systemName: "doc.text")!,
        afterImage: UIImage(systemName: "doc.text.fill")!,
        processingTime: 2.3,
        onViewData: {},
        onSave: {},
        onClose: {}
    )
}
