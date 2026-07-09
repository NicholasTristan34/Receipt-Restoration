//
//  TestResultsSection.swift
//  MBG Receipt Restoration
//
//  Created by Nicholas Tristandi on 20/05/26.
//

import SwiftUI

struct TestResultsSection: View {
    let detectionResult: String
    let recognitionResult: String

    var body: some View {
        if !detectionResult.isEmpty || !recognitionResult.isEmpty {
            VStack(alignment: .leading, spacing: 12) {
                Text("Test Results")
                    .font(.headline)

                if !detectionResult.isEmpty {
                    ResultCard(title: "Detection Model:", result: detectionResult)
                }

                if !recognitionResult.isEmpty {
                    ResultCard(title: "Recognition Model:", result: recognitionResult)
                }
            }
            .padding(.top, 8)
        }
    }
}
