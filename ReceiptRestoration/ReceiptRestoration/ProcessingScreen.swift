//
//  ProcessingScreen.swift
//  ReceiptRestoration
//
//  Processing screen with animated progress
//

import SwiftUI

struct ProcessingScreen: View {
    let image: UIImage
    @State private var progress: Double = 0.0
    @State private var currentStage: ProcessingStage = .preprocessing

    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                // Dimmed Receipt Preview with Scanning Effect
                ZStack {
                    // Diagonal stripe background
                    DiagonalStripesBackground()
                        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.xxl))

                    // Image (dimmed)
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .rotationEffect(.degrees(-3))
                        .padding(Spacing.xl)
                        .opacity(0.6)

                    // Scanning line
                    ScanningLine(progress: progress)
                }
                .frame(maxWidth: .infinity)
                .frame(maxHeight: 400)
                .background(Color.appCard)
                .cornerRadius(CornerRadius.xxl)
                .overlay(
                    RoundedRectangle(cornerRadius: CornerRadius.xxl)
                        .stroke(Color.appSeparator, lineWidth: 1)
                )
                .padding(.horizontal, Spacing.gutter)

                Spacer()

                // Progress Card
                ProcessingProgressCard(
                    progress: progress,
                    currentStage: currentStage
                )
                .padding(.horizontal, Spacing.gutter)
                .padding(.bottom, 38)
            }
        }
        .onAppear {
            startAnimation()
        }
    }

    private func startAnimation() {
        // Simulate processing stages
        withAnimation(.linear(duration: 3.0)) {
            progress = 1.0
        }

        // Update stages
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            currentStage = .noiseDetection
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            currentStage = .restoration
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.1) {
            currentStage = .textSharpening
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.7) {
            currentStage = .ocrExtraction
        }
    }
}

// MARK: - Processing Stage

enum ProcessingStage: Int, CaseIterable {
    case preprocessing = 0
    case noiseDetection = 1
    case restoration = 2
    case textSharpening = 3
    case ocrExtraction = 4

    var title: String {
        switch self {
        case .preprocessing: return "Preprocessing"
        case .noiseDetection: return "Noise Detection"
        case .restoration: return "NAFNet Restoration"
        case .textSharpening: return "Text Sharpening"
        case .ocrExtraction: return "OCR Extraction"
        }
    }

    var stepsRemaining: Int {
        return ProcessingStage.allCases.count - self.rawValue - 1
    }
}

// MARK: - Scanning Line

struct ScanningLine: View {
    let progress: Double

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                    .frame(height: geometry.size.height * progress)

                Rectangle()
                    .fill(Color.appAccent)
                    .frame(height: 2)
                    .shadow(color: Color.appAccent, radius: 12, x: 0, y: 0)
                    .shadow(color: Color.appAccent, radius: 4, x: 0, y: 0)
                    .opacity(0.9)

                Spacer()
            }
        }
    }
}

// MARK: - Progress Card

struct ProcessingProgressCard: View {
    let progress: Double
    let currentStage: ProcessingStage

    var body: some View {
        VStack(spacing: Spacing.lg) {
            // Top Row: Progress Ring + Stage Info
            HStack(alignment: .top, spacing: Spacing.md) {
                // Circular Progress Ring
                ZStack {
                    // Background ring
                    Circle()
                        .stroke(Color.appAccentDim, lineWidth: 3)
                        .frame(width: 44, height: 44)

                    // Progress arc
                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(Color.appAccent, lineWidth: 3)
                        .frame(width: 44, height: 44)
                        .rotationEffect(.degrees(-90))
                        .animation(.linear(duration: 0.3), value: progress)

                    // Percentage
                    Text("\(Int(progress * 100))%")
                        .font(.appLabelUppercase)
                        .foregroundColor(.appAccent)
                }

                // Stage Info
                VStack(alignment: .leading, spacing: 4) {
                    Text(currentStage.title)
                        .font(.appSubheadline)
                        .foregroundColor(.appAccent)
                        .tracking(-0.3)

                    Text("Model NAFNet · \(currentStage.stepsRemaining) steps remaining")
                        .font(.appCaption2)
                        .foregroundColor(.appText3)
                }

                Spacer()
            }

            // Pipeline Steps
            VStack(spacing: Spacing.lg) {
                ForEach(ProcessingStage.allCases, id: \.self) { stage in
                    ProcessingStepRow(
                        stage: stage,
                        currentStage: currentStage
                    )
                }
            }
        }
        .padding(Spacing.gutterLg)
        .background(Color.appCard)
        .cornerRadius(22)
        .appShadowCard()
    }
}

// MARK: - Processing Step Row

struct ProcessingStepRow: View {
    let stage: ProcessingStage
    let currentStage: ProcessingStage

    private var status: StepStatus {
        if stage.rawValue < currentStage.rawValue {
            return .done
        } else if stage == currentStage {
            return .active
        } else {
            return .pending
        }
    }

    var body: some View {
        HStack(spacing: 12) {
            // Status Circle
            ZStack {
                Circle()
                    .fill(statusBackgroundColor)
                    .frame(width: 18, height: 18)
                    .overlay(
                        Circle()
                            .stroke(status == .pending ? Color.appSeparator : Color.clear, lineWidth: 1)
                    )

                if status == .done {
                    Image(systemName: "checkmark")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.white)
                } else if status == .active {
                    PulsingDot()
                }
            }

            // Label
            Text(stage.title)
                .font(.appCaption)
                .foregroundColor(status == .pending ? .appText3 : .appText)
                .fontWeight(status == .active ? .semibold : .regular)

            Spacer()
        }
    }

    private var statusBackgroundColor: Color {
        switch status {
        case .done: return .appAccent
        case .active: return .appAccentDim
        case .pending: return .appText4.opacity(0.3)
        }
    }

    enum StepStatus {
        case done, active, pending
    }
}

// MARK: - Pulsing Dot

struct PulsingDot: View {
    @State private var isPulsing = false

    var body: some View {
        Circle()
            .fill(Color.appAccent)
            .frame(width: 7, height: 7)
            .scaleEffect(isPulsing ? 1.4 : 1.0)
            .opacity(isPulsing ? 0.5 : 1.0)
            .animation(
                .easeInOut(duration: 1.0).repeatForever(autoreverses: true),
                value: isPulsing
            )
            .onAppear {
                isPulsing = true
            }
    }
}

#Preview {
    ProcessingScreen(
        image: UIImage(systemName: "doc.text")!
    )
}
