//
//  FavoriteMenuCard.swift
//  Makanan
//
//  Created by Eliza Vornia on 18/05/25.
//

import SwiftUI
import SwiftData

struct FavoriteMenuCard: View {
    let menu: Menu
    @Binding var quantity: Int
    @Binding var refreshID: UUID
    @Environment(\.modelContext) private var context
    @Query var favoriteItems: [FavoriteItem]

    var body: some View {
        HStack(spacing: 12) {
            Image(menu.imageName.isEmpty ? "defaultImage" : menu.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 60)
                .cornerRadius(8)
                .clipped()

            VStack(alignment: .leading, spacing: 4) {
                Text(menu.name)
                    .font(.headline)
                Text("Rp\(menu.price)")
                    .font(.subheadline)
            }

            Spacer()

            VStack(spacing: 8) {
                Button(action: {
                    removeFromFavorites()
                }) {
                    Image(systemName: "trash")
                        .resizable()
                        .frame(width: 22, height: 22)
                        .foregroundColor(.gray)
                }
                .buttonStyle(.plain)

                CustomStepper(value: $quantity)
            }
        }
        .padding(.horizontal)
        .id(refreshID)
    }

    private func removeFromFavorites() {
        if let favoriteToRemove = favoriteItems.first(where: { $0.menu.id == menu.id }) {
            context.delete(favoriteToRemove)
            try? context.save()
        }
    }
}

