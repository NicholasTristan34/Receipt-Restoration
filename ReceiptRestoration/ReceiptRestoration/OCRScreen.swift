//
//  OCRScreen.swift
//  ReceiptRestoration
//
//  OCR structured data display screen
//

import SwiftUI

struct OCRScreen: View {
    let ocrData: OCRData
    let onBack: () -> Void

    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Top Bar
                HStack {
                    Button(action: onBack) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.appText)
                    }
                    .iconButtonStyle()

                    Spacer()

                    Text("Receipt Data")
                        .font(.appBodyBold)
                        .foregroundColor(.appText)

                    Spacer()

                    Button(action: {}) {
                        Image(systemName: "doc.on.doc")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.appAccent)
                    }
                    .iconButtonStyle(backgroundColor: Color.appAccentDim)
                }
                .padding(.horizontal, Spacing.gutter)
                .padding(.top, Spacing.topPadding)

                ScrollView {
                    VStack(alignment: .leading, spacing: Spacing.lg) {
                        // Header Row
                        HStack(alignment: .top, spacing: Spacing.md) {
                            // Mini Receipt Thumbnail
                            ZStack {
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color.appCard)

                                VStack(spacing: 2) {
                                    ForEach(0..<8) { _ in
                                        RoundedRectangle(cornerRadius: 0.5)
                                            .fill(Color.appText4)
                                            .frame(height: 2)
                                            .padding(.horizontal, 6)
                                    }
                                }
                            }
                            .frame(width: 56, height: 72)
                            .overlay(
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(Color.appSeparator, lineWidth: 1)
                            )

                            // Store Info
                            VStack(alignment: .leading, spacing: 4) {
                                Text(ocrData.store.name)
                                    .font(.appTitle2)
                                    .foregroundColor(.appText)
                                    .tracking(-0.5)

                                Text(ocrData.receipt.datetime)
                                    .font(.appLabel)
                                    .foregroundColor(.appText3)

                                // Accuracy Badge
                                Text("Accuracy \(Int(ocrData.confidence * 100))%")
                                    .font(.appLabelUppercase)
                                    .tracking(0.4)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.appSuccessBg)
                                    .foregroundColor(.appSuccess)
                                    .cornerRadius(CornerRadius.pill)
                            }
                        }
                        .padding(.horizontal, Spacing.gutter)
                        .padding(.top, Spacing.xl)

                        // Meta Card
                        VStack(spacing: 0) {
                            OCRDataRow(label: "Store", value: ocrData.store.name)
                            Divider().background(Color.appSeparator)
                            OCRDataRow(label: "Address", value: ocrData.store.address)
                            Divider().background(Color.appSeparator)
                            OCRDataRow(label: "Receipt No.", value: ocrData.receipt.number)
                            Divider().background(Color.appSeparator)
                            OCRDataRow(label: "Cashier", value: ocrData.receipt.cashier)
                        }
                        .padding(Spacing.md)
                        .background(Color.appCard)
                        .cornerRadius(CornerRadius.lg)
                        .overlay(
                            RoundedRectangle(cornerRadius: CornerRadius.lg)
                                .stroke(Color.appSeparator, lineWidth: 1)
                        )
                        .padding(.horizontal, Spacing.gutter)

                        // Items Section Header
                        HStack {
                            Text("ITEMS · \(ocrData.items.count)")
                                .font(.appLabel)
                                .foregroundColor(.appText3)
                                .tracking(0.4)

                            Spacer()

                            Text(formatCurrency(ocrData.totals.subtotal))
                                .font(.appLabel)
                                .foregroundColor(.appText3)
                        }
                        .padding(.horizontal, Spacing.gutter)

                        // Items Card
                        VStack(spacing: 0) {
                            ForEach(ocrData.items.indices, id: \.self) { index in
                                ItemRow(item: ocrData.items[index])
                                if index < ocrData.items.count - 1 {
                                    Divider().background(Color.appSeparator)
                                }
                            }
                        }
                        .padding(Spacing.md)
                        .background(Color.appCard)
                        .cornerRadius(CornerRadius.lg)
                        .overlay(
                            RoundedRectangle(cornerRadius: CornerRadius.lg)
                                .stroke(Color.appSeparator, lineWidth: 1)
                        )
                        .padding(.horizontal, Spacing.gutter)

                        // Totals Card
                        VStack(spacing: 0) {
                            TotalRow(label: "Subtotal", value: ocrData.totals.subtotal, isTotal: false)
                            Divider().background(Color.appSeparator)
                            TotalRow(label: ocrData.totals.tax.label, value: ocrData.totals.tax.amount, isTotal: false)
                            Divider().background(Color.appSeparator)
                            TotalRow(label: "TOTAL", value: ocrData.totals.total, isTotal: true)
                        }
                        .padding(Spacing.md)
                        .background(Color.appCard)
                        .cornerRadius(CornerRadius.lg)
                        .overlay(
                            RoundedRectangle(cornerRadius: CornerRadius.lg)
                                .stroke(Color.appSeparator, lineWidth: 1)
                        )
                        .padding(.horizontal, Spacing.gutter)

                        // Payment Card
                        VStack(spacing: 0) {
                            PaymentRow(label: "Cash", value: ocrData.payment.paid)
                            Divider().background(Color.appSeparator)
                            PaymentRow(label: "Change", value: ocrData.payment.change)
                        }
                        .padding(Spacing.md)
                        .background(Color.appCard)
                        .cornerRadius(CornerRadius.lg)
                        .overlay(
                            RoundedRectangle(cornerRadius: CornerRadius.lg)
                                .stroke(Color.appSeparator, lineWidth: 1)
                        )
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

                            Text("Copy All")
                        }
                    }
                    .secondaryButtonStyle()

                    Button(action: {}) {
                        HStack(spacing: 8) {
                            Image(systemName: "square.and.arrow.up")
                                .font(.system(size: 16, weight: .medium))

                            Text("Export")
                        }
                    }
                    .primaryButtonStyle()
                }
                .padding(.horizontal, Spacing.gutter)
                .padding(.top, Spacing.topPadding)
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

    private func formatCurrency(_ amount: Double) -> String {
        return "Rp \(Int(amount).formatted())"
    }
}

// MARK: - OCR Data Row

struct OCRDataRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .font(.appLabel)
                .foregroundColor(.appText3)

            Spacer()

            Text(value)
                .font(.appCaption)
                .fontWeight(.medium)
                .foregroundColor(value == "-" ? .appText3 : .appText)
                .multilineTextAlignment(.trailing)
                .frame(maxWidth: .infinity * 0.7, alignment: .trailing)
        }
        .padding(.vertical, 6)
    }
}

// MARK: - Item Row

struct ItemRow: View {
    let item: OCRItem

    var body: some View {
        HStack(alignment: .center, spacing: Spacing.sm) {
            // Quantity Chip (hide if name is "-")
            if item.name != "-" {
                Text("×\(item.quantity)")
                    .font(.appLabelUppercase)
                    .foregroundColor(.appText2)
                    .tracking(0.4)
                    .frame(width: 24, height: 24)
                    .background(Color.appText4.opacity(0.3))
                    .cornerRadius(4)
            }

            // Item Name
            Text(item.name)
                .font(.appBody)
                .foregroundColor(item.name == "-" ? .appText3 : .appText)

            Spacer()

            // Price (show "-" if amount is 0)
            Text(item.lineTotal == 0 ? "-" : formatCurrency(item.lineTotal))
                .font(.appMono)
                .foregroundColor(item.lineTotal == 0 ? .appText3 : .appText)
        }
        .padding(.vertical, 6)
    }

    private func formatCurrency(_ amount: Double) -> String {
        return "Rp \(Int(amount).formatted())"
    }
}

// MARK: - Total Row

struct TotalRow: View {
    let label: String
    let value: Double
    let isTotal: Bool

    var body: some View {
        HStack {
            Text(label)
                .font(isTotal ? .appSubheadline : .appCaption)
                .foregroundColor(isTotal ? .appText : .appText2)

            Spacer()

            Text(value == 0 && label != "TOTAL" ? "-" : formatCurrency(value))
                .font(isTotal ? .appMonoBold : .appMono)
                .foregroundColor(isTotal ? .appAccent : (value == 0 ? .appText3 : .appText))
        }
        .padding(.vertical, isTotal ? 8 : 6)
    }

    private func formatCurrency(_ amount: Double) -> String {
        if amount == 0 {
            return "-"
        }
        return "Rp \(Int(amount).formatted())"
    }
}

// MARK: - Payment Row

struct PaymentRow: View {
    let label: String
    let value: Double

    var body: some View {
        HStack {
            Text(label)
                .font(.appCaption)
                .foregroundColor(.appText2)

            Spacer()

            Text(value == 0 ? "-" : formatCurrency(value))
                .font(.appMono)
                .foregroundColor(value == 0 ? .appText3 : .appText)
        }
        .padding(.vertical, 6)
    }

    private func formatCurrency(_ amount: Double) -> String {
        if amount == 0 {
            return "-"
        }
        return "Rp \(Int(amount).formatted())"
    }
}

// MARK: - OCR Data Model

struct OCRData {
    let store: Store
    let receipt: Receipt
    let items: [OCRItem]
    let totals: Totals
    let payment: Payment
    let confidence: Double

    struct Store {
        let name: String
        let address: String
        let phone: String?
    }

    struct Receipt {
        let number: String
        let cashier: String
        let datetime: String
    }

    struct Totals {
        let subtotal: Double
        let tax: Tax
        let total: Double

        struct Tax {
            let label: String
            let amount: Double
        }
    }

    struct Payment {
        let method: String
        let paid: Double
        let change: Double
    }
}

struct OCRItem {
    let name: String
    let quantity: Int
    let unitPrice: Double?
    let lineTotal: Double
}

// MARK: - Preview

#Preview {
    OCRScreen(
        ocrData: OCRData(
            store: OCRData.Store(name: "Indomaret", address: "Jl. Sudirman No. 45", phone: nil),
            receipt: OCRData.Receipt(number: "20260518/0123", cashier: "ANDI", datetime: "May 18, 2026 · 14:32"),
            items: [
                OCRItem(name: "Indomie Goreng", quantity: 3, unitPrice: 3500, lineTotal: 10500),
                OCRItem(name: "Aqua 600ml", quantity: 2, unitPrice: 3000, lineTotal: 6000),
                OCRItem(name: "Teh Botol Sosro", quantity: 1, unitPrice: 4500, lineTotal: 4500),
            ],
            totals: OCRData.Totals(
                subtotal: 92500,
                tax: OCRData.Totals.Tax(label: "PPN 11%", amount: 10175),
                total: 102675
            ),
            payment: OCRData.Payment(method: "Cash", paid: 110000, change: 7325),
            confidence: 0.98
        ),
        onBack: {}
    )
}
