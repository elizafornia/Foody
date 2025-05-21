//
//  StallDetailView.swift
//  Makanan
//
//  Created by Eliza Vornia on 15/05/25.
//


import SwiftUI

struct StallDetailView: View {
    let stall: Stall

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(stall.name)
                .font(.title2)
                .fontWeight(.bold)

            Text(stall.location)
                .font(.subheadline)
                .foregroundColor(.gray)

        }
        .padding()
    }
}
