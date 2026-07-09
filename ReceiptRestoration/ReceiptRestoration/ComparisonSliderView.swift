//
//  ComparisonSliderView.swift
//  ReceiptRestoration
//
//  Created by Nicholas Tristandi on 17/05/26.
//  Enhanced with Struk design system
//

import SwiftUI

struct ComparisonSliderView: View {
    let beforeImage: UIImage
    let afterImage: UIImage
    @Binding var sliderValue: Double

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Diagonal stripe background
                DiagonalStripesBackground()

                // After image (restored - full)
                Image(uiImage: afterImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: geometry.size.width, height: geometry.size.height)

                // Before image (degraded - clipped)
                Image(uiImage: beforeImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .mask(
                        Rectangle()
                            .frame(width: geometry.size.width * sliderValue)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    )

                // Divider line with halo
                Rectangle()
                    .fill(Color.white)
                    .frame(width: 2)
                    .shadow(color: Color.black.opacity(0.5), radius: 8, x: 0, y: 0)
                    .offset(x: 1)
                    .position(x: geometry.size.width * sliderValue, y: geometry.size.height / 2)

                // Slider handle
                ZStack {
                    // Outer halo
                    Circle()
                        .fill(Color.white.opacity(0.18))
                        .frame(width: 46, height: 46)

                    // Main circle
                    Circle()
                        .fill(Color.white)
                        .frame(width: 38, height: 38)
                        .shadow(color: Color.black.opacity(0.25), radius: 6, x: 0, y: 4)

                    // Chevrons
                    HStack(spacing: 2) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.appText2)

                        Image(systemName: "chevron.right")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.appText2)
                    }
                }
                .position(x: geometry.size.width * sliderValue, y: geometry.size.height / 2)

                // Labels
                VStack {
                    HStack {
                        // Before Label
                        Text("BEFORE")
                            .font(.appLabelUppercase)
                            .tracking(0.4)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(Color.black.opacity(0.55))
                            .foregroundColor(Color(hex: "A3B4C5"))
                            .cornerRadius(CornerRadius.pill)
                            .padding(10)

                        Spacer()

                        // After Label
                        Text("AFTER")
                            .font(.appLabelUppercase)
                            .tracking(0.4)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(Color.appAccent)
                            .foregroundColor(.white)
                            .cornerRadius(CornerRadius.pill)
                            .padding(10)
                    }
                    Spacer()
                }
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        sliderValue = min(max(0, value.location.x / geometry.size.width), 1)
                    }
            )
        }
        .background(Color(hex: "111111"))
        .cornerRadius(CornerRadius.xl)
    }
}
