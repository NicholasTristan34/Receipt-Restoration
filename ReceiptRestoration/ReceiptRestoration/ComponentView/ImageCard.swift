//
//  ImageCard.swift
//  MBG Receipt Restoration
//
//  Created by Nicholas Tristandi on 20/05/26.
//

import SwiftUI

struct ImageCard: View {
    let image: UIImage
    let label: String

    var body: some View {
        VStack(spacing: 8) {
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 300)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .frame(maxWidth: .infinity)
    }
}
