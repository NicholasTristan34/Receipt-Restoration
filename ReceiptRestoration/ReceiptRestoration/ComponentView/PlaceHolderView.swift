//
//  PlaceHolderView.swift
//  MBG Receipt Restoration
//
//  Created by Nicholas Tristandi on 20/05/26.
//

import SwiftUI

struct PlaceholderView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "photo.on.rectangle.angled")
                .font(.system(size: 80))
                .foregroundColor(.gray)
            Text("No image selected")
                .font(.headline)
                .foregroundColor(.secondary)
            Text("Choose a photo or take a picture to get started")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(height: 300)
        .frame(maxWidth: .infinity)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
