//
//  ContentView.swift
//  ReceiptRestoration
//
//  Redesigned with Struk design system
//

import SwiftUI
import PhotosUI

enum AppScreen {
    case home
    case empty
    case picked
    case processing
    case results
    case ocr
}

struct ContentView: View {
    @State private var currentScreen: AppScreen = .home
    @State private var selectedImage: UIImage?
    @State private var restoredImage: UIImage?
    @State private var qualityScore: Double = 1.0
    @State private var processingTime: Double = 0.0
    @State private var showImagePicker = false
    @State private var showCamera = false
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var ocrData: OCRData?

    private let model = ReceiptRestorationModel()
    private let visionRecognizer = VisionTextRecognizer()

    var body: some View {
        ZStack {
            // Screen Navigation
            switch currentScreen {
            case .home:
                HomeScreen(
                    onPickFromGallery: {
                        showImagePicker = true
                    },
                    onTakePhoto: {
                        showCamera = true
                    }
                )

            case .empty:
                EmptyScreen(
                    onPickFromGallery: {
                        showImagePicker = true
                    },
                    onTakePhoto: {
                        showCamera = true
                    }
                )

            case .picked:
                if let image = selectedImage {
                    PickedScreen(
                        image: image,
                        qualityScore: qualityScore,
                        onRestore: {
                            Task { await performRestoration() }
                        },
                        onPickAnother: {
                            showImagePicker = true
                        },
                        onClose: {
                            currentScreen = .home
                            selectedImage = nil
                        }
                    )
                }

            case .processing:
                if let image = selectedImage {
                    ProcessingScreen(image: image)
                        .onAppear {
                            // Auto-navigate after animation completes
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3.2) {
                                if restoredImage != nil {
                                    currentScreen = .results
                                }
                            }
                        }
                }

            case .results:
                if let before = selectedImage, let after = restoredImage {
                    ResultsScreen(
                        beforeImage: before,
                        afterImage: after,
                        processingTime: processingTime,
                        onViewData: {
                            // Extract OCR data if not already done
                            if ocrData == nil {
                                Task { await extractOCRData() }
                            }
                            currentScreen = .ocr
                        },
                        onSave: {
                            saveImageToPhotos()
                        },
                        onClose: {
                            currentScreen = .home
                            selectedImage = nil
                            restoredImage = nil
                        }
                    )
                }

            case .ocr:
                if let data = ocrData {
                    OCRScreen(
                        ocrData: data,
                        onBack: {
                            currentScreen = .results
                        }
                    )
                }
            }
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $selectedImage, sourceType: .photoLibrary)
                .onDisappear {
                    if let image = selectedImage {
                        handleImageSelected(image)
                    }
                }
        }
        .sheet(isPresented: $showCamera) {
            ImagePicker(image: $selectedImage, sourceType: .camera)
                .onDisappear {
                    if let image = selectedImage {
                        handleImageSelected(image)
                    }
                }
        }
        .alert("Error", isPresented: $showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(errorMessage)
        }
        .animation(.easeInOut(duration: 0.3), value: currentScreen)
    }

    // MARK: - Image Handling

    private func handleImageSelected(_ image: UIImage) {
        selectedImage = image

        // Assess quality
        qualityScore = QualityAssessment.assessQuality(of: image)

        currentScreen = .picked
    }

    // MARK: - Restoration

    private func performRestoration() async {
        guard let selectedImage = selectedImage else { return }

        // Navigate to processing screen
        await MainActor.run {
            currentScreen = .processing
        }

        let startTime = Date()

        do {
            let restored = try await model.restoreReceipt(selectedImage)

            let endTime = Date()
            let duration = endTime.timeIntervalSince(startTime)

            await MainActor.run {
                restoredImage = restored
                processingTime = duration
                // Processing screen will auto-navigate after animation
            }
        } catch {
            await MainActor.run {
                errorMessage = error.localizedDescription
                showError = true
                currentScreen = .picked
            }
        }
    }

    // MARK: - OCR Extraction

    private func extractOCRData() async {
        guard let restoredImage = restoredImage else { return }

        do {
            let observations = try await visionRecognizer.recognizeText(from: restoredImage)

            // Parse text observations into structured data
            let parsedData = parseOCRObservations(observations)

            await MainActor.run {
                ocrData = parsedData
            }
        } catch {
            print("OCR extraction error: \(error)")
            // Create empty data structure with "-" placeholders
            await MainActor.run {
                ocrData = createEmptyOCRData()
            }
        }
    }

    private func parseOCRObservations(_ observations: [VisionTextRecognizer.TextObservation]) -> OCRData {
        // Extract all text from observations
        let allText = observations.map { $0.text }.joined(separator: "\n")
        let lines = allText.split(separator: "\n").map { String($0) }

        print("=== OCR PARSING ===")
        print("Total lines detected: \(lines.count)")
        lines.enumerated().forEach { index, line in
            print("\(index + 1). \(line)")
        }

        // Parse store name (usually first line or largest text)
        let storeName = lines.first ?? "-"

        // Try to find address (usually second line or contains street keywords)
        let address = lines.dropFirst().first(where: {
            $0.lowercased().contains("jl") ||
            $0.lowercased().contains("street") ||
            $0.lowercased().contains("no")
        }) ?? "-"

        // Try to find receipt number (look for patterns like "NO:", "NOTA:", numbers with slashes)
        let receiptNumber = lines.first(where: {
            $0.contains("/") ||
            $0.lowercased().contains("no.") ||
            $0.lowercased().contains("receipt")
        })?.components(separatedBy: ":").last?.trimmingCharacters(in: .whitespaces) ?? "-"

        // Try to find cashier (look for "KASIR", "CASHIER", "SERVED BY")
        let cashier = lines.first(where: {
            $0.lowercased().contains("kasir") ||
            $0.lowercased().contains("cashier") ||
            $0.lowercased().contains("served")
        })?.components(separatedBy: ":").last?.trimmingCharacters(in: .whitespaces) ?? "-"

        // Try to find date/time
        let datetime = findDateTime(in: lines) ?? "-"

        // Parse items (lines that look like "item name price" or contain "x" for quantity)
        let parsedItems = parseItems(from: lines)

        // Parse totals
        let totals = parseTotals(from: lines)

        // Calculate average confidence
        let avgConfidence = observations.isEmpty ? 0.0 :
            observations.map { Double($0.confidence) }.reduce(0, +) / Double(observations.count)

        return OCRData(
            store: OCRData.Store(
                name: storeName,
                address: address,
                phone: nil
            ),
            receipt: OCRData.Receipt(
                number: receiptNumber,
                cashier: cashier,
                datetime: datetime
            ),
            items: parsedItems.isEmpty ? [OCRItem(name: "-", quantity: 1, unitPrice: 0, lineTotal: 0)] : parsedItems,
            totals: totals,
            payment: OCRData.Payment(
                method: "-",
                paid: 0,
                change: 0
            ),
            confidence: avgConfidence
        )
    }

    private func findDateTime(in lines: [String]) -> String? {
        // Look for date patterns
        let datePattern = #"\d{1,2}[-/]\d{1,2}[-/]\d{2,4}"#
        for line in lines {
            if let _ = line.range(of: datePattern, options: .regularExpression) {
                return line
            }
        }
        return nil
    }

    private func parseItems(from lines: [String]) -> [OCRItem] {
        var items: [OCRItem] = []

        for line in lines {
            // Skip common header/footer terms
            if line.lowercased().contains("total") ||
               line.lowercased().contains("subtotal") ||
               line.lowercased().contains("tax") ||
               line.lowercased().contains("ppn") ||
               line.lowercased().contains("terima kasih") ||
               line.lowercased().contains("thank you") {
                continue
            }

            // Look for lines with quantity pattern (e.g., "item x2" or "2x item")
            let quantityPattern = #"(\d+)\s*[xX×]|[xX×]\s*(\d+)"#
            if let match = line.range(of: quantityPattern, options: .regularExpression) {
                let quantity = Int(line[match].filter { $0.isNumber }) ?? 1
                let name = line.replacingOccurrences(of: quantityPattern, with: "", options: .regularExpression)
                    .trimmingCharacters(in: .whitespaces)
                    .replacingOccurrences(of: #"\d+[.,]\d+"#, with: "", options: .regularExpression)
                    .trimmingCharacters(in: .whitespaces)

                // Try to extract price
                let pricePattern = #"(\d+[.,]\d+|\d+)"#
                var price: Double = 0
                if let priceMatch = line.range(of: pricePattern, options: .regularExpression) {
                    let priceStr = String(line[priceMatch]).replacingOccurrences(of: ",", with: ".")
                    price = Double(priceStr) ?? 0
                }

                if !name.isEmpty && name != "-" {
                    items.append(OCRItem(
                        name: name,
                        quantity: quantity,
                        unitPrice: price / Double(quantity),
                        lineTotal: price
                    ))
                }
            }
            // Look for lines with price at the end
            else if let priceMatch = line.range(of: #"\d+[.,]\d+$|\d+$"#, options: .regularExpression) {
                let priceStr = String(line[priceMatch]).replacingOccurrences(of: ",", with: ".")
                if let price = Double(priceStr), price > 0 {
                    let name = line.replacingOccurrences(of: priceStr, with: "")
                        .trimmingCharacters(in: .whitespaces)

                    if !name.isEmpty && name.count > 2 {
                        items.append(OCRItem(
                            name: name,
                            quantity: 1,
                            unitPrice: price,
                            lineTotal: price
                        ))
                    }
                }
            }
        }

        return items
    }

    private func parseTotals(from lines: [String]) -> OCRData.Totals {
        var subtotal: Double = 0
        var tax: Double = 0
        var total: Double = 0
        var taxLabel = "-"

        for line in lines {
            let lowercased = line.lowercased()

            // Extract price from line
            if let priceMatch = line.range(of: #"(\d+[.,]\d+|\d+)$"#, options: .regularExpression) {
                let priceStr = String(line[priceMatch]).replacingOccurrences(of: ",", with: "")
                let price = Double(priceStr) ?? 0

                if lowercased.contains("subtotal") || lowercased.contains("sub total") {
                    subtotal = price
                } else if lowercased.contains("tax") || lowercased.contains("ppn") || lowercased.contains("pajak") {
                    tax = price
                    // Extract tax label
                    if lowercased.contains("ppn") {
                        taxLabel = line.components(separatedBy: CharacterSet.decimalDigits.inverted)
                            .joined()
                            .prefix(2).isEmpty ? "PPN" : "PPN \(line.components(separatedBy: CharacterSet.decimalDigits.inverted).joined().prefix(2))%"
                    } else {
                        taxLabel = "Tax"
                    }
                } else if lowercased.contains("total") && !lowercased.contains("subtotal") {
                    total = price
                }
            }
        }

        // If no explicit values found, use "-"
        if total == 0 && subtotal == 0 {
            return OCRData.Totals(
                subtotal: 0,
                tax: OCRData.Totals.Tax(label: "-", amount: 0),
                total: 0
            )
        }

        // Calculate missing values if possible
        if total == 0 {
            total = subtotal + tax
        }
        if subtotal == 0 {
            subtotal = total - tax
        }

        return OCRData.Totals(
            subtotal: subtotal,
            tax: OCRData.Totals.Tax(label: taxLabel, amount: tax),
            total: total
        )
    }

    private func createEmptyOCRData() -> OCRData {
        return OCRData(
            store: OCRData.Store(
                name: "-",
                address: "-",
                phone: nil
            ),
            receipt: OCRData.Receipt(
                number: "-",
                cashier: "-",
                datetime: "-"
            ),
            items: [OCRItem(name: "-", quantity: 1, unitPrice: 0, lineTotal: 0)],
            totals: OCRData.Totals(
                subtotal: 0,
                tax: OCRData.Totals.Tax(label: "-", amount: 0),
                total: 0
            ),
            payment: OCRData.Payment(
                method: "-",
                paid: 0,
                change: 0
            ),
            confidence: 0.0
        )
    }

    // MARK: - Save to Photos

    private func saveImageToPhotos() {
        guard let restoredImage = restoredImage else { return }
        UIImageWriteToSavedPhotosAlbum(restoredImage, nil, nil, nil)
    }
}

#Preview {
    ContentView()
}
