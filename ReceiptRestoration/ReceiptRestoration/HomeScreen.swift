//
//  HomeScreen.swift
//  ReceiptRestoration
//
//  Home screen with hero CTA and recent restorations
//

import SwiftUI

struct HomeScreen: View {
    let onPickFromGallery: () -> Void
    let onTakePhoto: () -> Void

    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.xl) {
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

                    // Hero Section
                    VStack(alignment: .leading, spacing: Spacing.md) {
                        Text("Enhance Faded Receipts")
                            .font(.appLargeTitle)
                            .foregroundColor(.appText)
                            .tracking(-0.8)
                            .lineSpacing(4)

                        Text("Pick a degraded receipt photo from your gallery.")
                            .font(.appBody)
                            .foregroundColor(.appText3)
                            .lineSpacing(5)
                    }
                    .padding(.horizontal, Spacing.gutter)

                    // Primary CTA Card
                    Button(action: onPickFromGallery) {
                        HStack(alignment: .top, spacing: 0) {
                            VStack(alignment: .leading, spacing: 8) {
                                // Icon
                                ZStack {
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.white.opacity(0.2))
                                        .frame(width: 44, height: 44)
                                        .background(
                                            .ultraThinMaterial,
                                            in: RoundedRectangle(cornerRadius: 12)
                                        )

                                    Image(systemName: "photo.on.rectangle.angled")
                                        .font(.system(size: 20, weight: .medium))
                                        .foregroundColor(.white)
                                }

                                Spacer()

                                // Text
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Pick from Gallery")
                                        .font(.appTitle2)
                                        .foregroundColor(.white)
                                        .tracking(-0.5)

                                    Text("Take your degraded receipt")
                                        .font(.appCaption)
                                        .foregroundColor(.white.opacity(0.85))
                                }
                            }

                            Spacer()

                            // Badge
                            Text("NAFNet · v2")
                                .font(.appLabelUppercase)
                                .foregroundColor(.white)
                                .tracking(0.4)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(Color.white.opacity(0.2))
                                .cornerRadius(CornerRadius.pill)
                        }
                        .padding(Spacing.gutterLg)
                        .frame(maxWidth: .infinity)
                        .frame(height: 200)
                        .background(LinearGradient.appAccentGradient)
                        .cornerRadius(CornerRadius.xxl)
                        .appShadowHero()
                    }
                    .padding(.horizontal, Spacing.gutter)

                    // Secondary Button
                    Button(action: onTakePhoto) {
                        HStack(spacing: Spacing.md) {
                            // Icon
                            ZStack {
                                RoundedRectangle(cornerRadius: CornerRadius.sm)
                                    .fill(Color.appText4.opacity(0.5))
                                    .frame(width: 36, height: 36)

                                Image(systemName: "camera")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(.appText2)
                            }

                            // Text
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Take New Photo")
                                    .font(.appBodyBold)
                                    .foregroundColor(.appText)

                                Text("Open camera")
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

                    // Recent Section
                    VStack(alignment: .leading, spacing: Spacing.md) {
                        HStack {
                            Text("RECENT")
                                .font(.appLabel)
                                .foregroundColor(.appText3)
                                .tracking(0.4)

                            Spacer()

                            Button(action: {}) {
                                Text("View All")
                                    .font(.appCaptionBold)
                                    .foregroundColor(.appAccent)
                            }
                        }

                        // Recent Grid (placeholder)
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: Spacing.sm) {
                            ForEach(0..<2) { _ in
                                RecentReceiptCard()
                            }
                        }
                    }
                    .padding(.horizontal, Spacing.gutter)
                    .padding(.bottom, Spacing.xxl)
                }
            }
        }
    }
}

// MARK: - Recent Receipt Card

struct RecentReceiptCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Receipt Preview
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white)

                VStack(spacing: 3) {
                    ForEach(0..<8) { _ in
                        RoundedRectangle(cornerRadius: 0.5)
                            .fill(Color.appText4)
                            .frame(height: 2)
                            .padding(.horizontal, 8)
                    }
                }
                .padding(.vertical, 8)
            }
            .frame(height: 78)
            .rotationEffect(.degrees(Double.random(in: -2...2)))

            // Info
            VStack(alignment: .leading, spacing: 2) {
                Text("Xxxxxxx")
                    .font(.appLabel)
                    .foregroundColor(.appText)

                Text("July 24 · Rp xxx,xxx")
                    .font(.appLabelUppercase)
                    .foregroundColor(.appText3)
            }
        }
        .padding(10)
        .background(Color.appCard)
        .cornerRadius(CornerRadius.lg)
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.lg)
                .stroke(Color.appSeparator, lineWidth: 1)
        )
    }
}

#Preview {
    HomeScreen(
        onPickFromGallery: {},
        onTakePhoto: {}
    )
}
