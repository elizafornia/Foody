//
//  MenuCard.swift
//  Makanan
//
//  Created by Eliza Vornia on 08/05/25.
//
import SwiftUI
import SwiftData

struct MenuCard: View {
    @StateObject var viewModel: MenuCardViewModel
    @Environment(\.modelContext) private var modelContext
    @Binding var menu: Menu
    @Binding var quantity: Int
    
    var body: some View {
        HStack(spacing: 16) {
            // Left side - Image
            Image(menu.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            
            // Middle - Text info
            VStack(alignment: .leading, spacing: 24) {
                Text(menu.name)
                    .font(.subheadline)
                  
                
                Text(viewModel.formattedPrice)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
          
            VStack(alignment: .trailing, spacing: 8) {
                Button(action: toggleFavorite) {
                    Image(systemName: menu.isFavorited ? "heart.fill" : "heart")
                        .foregroundColor(.red)
                        .font(.system(size: 18))
                }
                .frame(width: 25, height: 25, alignment: .topTrailing)
                .offset(x: 4, y: -4)
                
                
                CustomStepper(value: $quantity)
                    .labelsHidden()
                    .frame(width: 25, height: 25, alignment: .bottomTrailing)
                    .offset(x: 4, y: 4)
            }
            .frame(width: 44)
        }
        .padding(12)
        .background(Color(.systemBackground))
        .cornerRadius(12)

        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(menu.isFavorited ? Color.red.opacity(0.3) : Color.clear, lineWidth: 1)
        )
    }
    
    private func toggleFavorite() {
        let newValue = !menu.isFavorited
        viewModel.toggleFavorite(isFavorited: newValue, context: modelContext)
    }
}
