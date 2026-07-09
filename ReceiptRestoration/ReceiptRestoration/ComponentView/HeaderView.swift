//
//  HeaderView.swift
//  MBG Receipt Restoration
//
//  Created by Nicholas Tristandi on 20/05/26.
//

import SwiftUI

struct HeaderView: View {
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "doc.text.image")
                .font(.system(size: 60))
                .foregroundColor(.blue)
            Text("Receipt Restoration")
                .font(.title2)
                .fontWeight(.bold)
            Text("Restore and enhance damaged receipts")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    HeaderView()
}
