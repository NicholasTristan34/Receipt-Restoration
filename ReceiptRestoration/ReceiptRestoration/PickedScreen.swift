//
//  PickedScreen.swift
//  ReceiptRestoration
//
//  Preview screen with quality warning
//

import SwiftUI

struct PickedScreen: View {
    let image: UIImage
    let qualityScore: Double
    let onRestore: () -> Void
    let onPickAnother: () -> Void
    let onClose: () -> Void

    private var showWarning: Bool {
        QualityAssessment.shouldShowWarning(score: qualityScore)
    }

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

                    Text("Preview")
                        .font(.appBodyBold)
                        .foregroundColor(.appText)

                    Spacer()

                    // Spacer for symmetry
                    Color.clear
                        .frame(width: 36, height: 36)
                }
                .padding(.horizontal, Spacing.gutter)
                .padding(.top, Spacing.topPadding)

                Spacer()

                // Preview Frame
                ZStack {
                    // Diagonal stripe background
                    DiagonalStripesBackground()
                        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.xxl))

                    // Image
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .rotationEffect(.degrees(-3))
                        .padding(Spacing.xl)
                }
                .frame(maxWidth: .infinity)
                .frame(maxHeight: 500)
                .background(Color.appCard)
                .cornerRadius(CornerRadius.xxl)
                .overlay(
                    RoundedRectangle(cornerRadius: CornerRadius.xxl)
                        .stroke(Color.appSeparator, lineWidth: 1)
                )
                .padding(.horizontal, Spacing.gutter)

                Spacer()

                // Warning Banner (conditional)
                if showWarning {
                    QualityWarningBanner()
                        .padding(.horizontal, Spacing.gutter)
                        .padding(.bottom, Spacing.md)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }

                // Bottom Actions
                VStack(spacing: 4) {
                    Button(action: onRestore) {
                        HStack(spacing: 8) {
                            Image(systemName: "camera.macro.circle")
                                .font(.system(size: 18, weight: .semibold))

                            Text("Restore Receipt")
                        }
                    }
                    .primaryButtonStyle()

                    Button(action: onPickAnother) {
                        Text("Pick another photo")
                    }
                    .ghostButtonStyle()
                }
                .padding(.horizontal, Spacing.gutter)
                .padding(.top, Spacing.gutterLg)
                .padding(.bottom, 38)
                .background(
                    LinearGradient.appFadeUp
                        .frame(height: 150)
                        .offset(y: -100)
                        .allowsHitTesting(false)
                )
            }
        }
        .animation(.easeInOut(duration: 0.3), value: showWarning)
    }
}

// MARK: - Quality Warning Banner

struct QualityWarningBanner: View {
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Warning Icon
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 20))
                .foregroundColor(.appWarnIcon)

            // Text
            VStack(alignment: .leading, spacing: 4) {
                Text("Low Image Quality")
                    .font(.appCaptionBold)
                    .foregroundColor(.appWarnText)

                Text("Photo is blurry and ink is faded. Restoration can still proceed, but some text may not be readable.")
                    .font(.appCaption2)
                    .foregroundColor(.appWarnText.opacity(0.8))
                    .lineSpacing(2)
            }
        }
        .padding(Spacing.md)
        .background(Color.appWarnBg)
        .cornerRadius(CornerRadius.md)
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.md)
                .stroke(Color.appWarnBorder, lineWidth: 1)
        )
    }
}

// MARK: - Diagonal Stripes Background

struct DiagonalStripesBackground: View {
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let spacing: CGFloat = 20
                let lineWidth: CGFloat = 1
                let angle: CGFloat = 45

                let diagonal = sqrt(pow(geometry.size.width, 2) + pow(geometry.size.height, 2))
                let count = Int(diagonal / spacing)

                for i in 0...count {
                    let offset = CGFloat(i) * spacing

                    path.move(to: CGPoint(x: -geometry.size.height + offset, y: 0))
                    path.addLine(to: CGPoint(x: offset, y: geometry.size.height))
                }
            }
            .stroke(Color.appSeparator.opacity(0.3), lineWidth: 0.5)
        }
    }
}

#Preview {
    PickedScreen(
        image: UIImage(systemName: "doc.text")!,
        qualityScore: 0.3,
        onRestore: {},
        onPickAnother: {},
        onClose: {}
    )
}
