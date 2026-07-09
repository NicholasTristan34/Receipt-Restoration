//
//  DesignTokens.swift
//  ReceiptRestoration
//
//  Design system tokens from Struk Receipt App design
//

import SwiftUI

// MARK: - Colors

extension Color {
    // Primary Colors
    static let appAccent = Color(hex: "D86A36")
    static let appAccentDark = Color(hex: "C25420")
    static let appAccentDim = Color(hex: "D86A36", opacity: 0.10)

    // Background Colors
    static let appBackground = Color(hex: "F2F2F7")
    static let appCard = Color.white

    // Text Colors
    static let appText = Color.black
    static let appText2 = Color(hex: "3C3C43", opacity: 0.78)
    static let appText3 = Color(hex: "3C3C43", opacity: 0.60)
    static let appText4 = Color(hex: "3C3C43", opacity: 0.30)

    // Separator
    static let appSeparator = Color(hex: "3C3C43", opacity: 0.12)

    // Warning Colors
    static let appWarnBg = Color(hex: "FFF4D0")
    static let appWarnBorder = Color(hex: "F3D783")
    static let appWarnText = Color(hex: "7C5300")
    static let appWarnIcon = Color(hex: "C28A18")

    // Success Colors
    static let appSuccess = Color(hex: "1F8A3F")
    static let appSuccessBg = Color(hex: "1F8A3F", opacity: 0.10)

    // Utility initializer
    init(hex: String, opacity: Double = 1.0) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (r, g, b) = ((int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (r, g, b) = (int >> 16, int >> 8 & 0xFF, int & 0xFF)
        default:
            (r, g, b) = (0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: opacity
        )
    }
}

// MARK: - Typography

extension Font {
    // Large Titles
    static let appLargeTitle = Font.system(size: 32, weight: .bold)
        .leading(.tight)

    // Titles
    static let appTitle = Font.system(size: 26, weight: .bold)
    static let appTitle2 = Font.system(size: 22, weight: .bold)

    // Headings
    static let appHeadline = Font.system(size: 17, weight: .semibold)
    static let appSubheadline = Font.system(size: 16, weight: .semibold)

    // Body
    static let appBody = Font.system(size: 15, weight: .regular)
    static let appBodyBold = Font.system(size: 15, weight: .semibold)

    // Captions
    static let appCaption = Font.system(size: 14, weight: .regular)
    static let appCaptionBold = Font.system(size: 14, weight: .semibold)
    static let appCaption2 = Font.system(size: 12.5, weight: .regular)

    // Labels
    static let appLabel = Font.system(size: 13, weight: .semibold)
    static let appLabelUppercase = Font.system(size: 11, weight: .semibold)

    // Monospace (for monetary values)
    static let appMono = Font.system(size: 14, weight: .medium, design: .monospaced)
    static let appMonoBold = Font.system(size: 18, weight: .bold, design: .monospaced)
}

// MARK: - Spacing

struct Spacing {
    static let xs: CGFloat = 6
    static let sm: CGFloat = 10
    static let md: CGFloat = 14
    static let lg: CGFloat = 18
    static let xl: CGFloat = 24
    static let xxl: CGFloat = 32
    static let topPadding : CGFloat = 6

    // Layout specific
    static let gutter: CGFloat = 16
    static let gutterLg: CGFloat = 20
    static let cardPadding: CGFloat = 14
    static let heroPadding: CGFloat = 20
}

// MARK: - Corner Radius

struct CornerRadius {
    static let sm: CGFloat = 10
    static let md: CGFloat = 14
    static let lg: CGFloat = 16
    static let xl: CGFloat = 20
    static let xxl: CGFloat = 24
    static let pill: CGFloat = 9999
}

// MARK: - Shadows

extension View {
    func appShadowCard() -> some View {
        self.shadow(color: Color.black.opacity(0.04), radius: 1, x: 0, y: 1)
            .shadow(color: Color.black.opacity(0.06), radius: 12, x: 0, y: 8)
    }

    func appShadowButton() -> some View {
        self.shadow(color: Color.black.opacity(0.06), radius: 1, x: 0, y: 1)
            .shadow(color: Color.appAccent.opacity(0.28), radius: 11, x: 0, y: 8)
    }

    func appShadowHero() -> some View {
        self.shadow(color: Color.black.opacity(0.06), radius: 3, x: 0, y: 2)
            .shadow(color: Color.appAccent.opacity(0.32), radius: 16, x: 0, y: 16)
    }

    func appShadowFloating() -> some View {
        self.shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Gradients

extension LinearGradient {
    static let appAccentGradient = LinearGradient(
        colors: [Color.appAccent, Color.appAccentDark],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let appFadeUp = LinearGradient(
        colors: [Color.appBackground.opacity(0), Color.appBackground],
        startPoint: .top,
        endPoint: .bottom
    )
}
