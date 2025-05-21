//
//  CartModalView.swift
//  Cheat
//
//  Created by Eliza Vornia on 13/05/25.
//
import SwiftUI
import SwiftData

struct CartModalView: View {
    let orderItems: [OrderItem]
    let favoriteItems: [FavoriteItem]
    let onClose: () -> Void
    
    var totalPrice: Int {
        orderItems.reduce(0) { $0 + ($1.price * $1.quantity) }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Keranjang Pesanan")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                
                Button(action: onClose) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.gray)
                }
            }
            .padding()
            
            Divider()
            
            // List items
            ScrollView {
                VStack(spacing: 16) {
                    if orderItems.isEmpty {
                        Text("Keranjang kosong")
                            .foregroundColor(.gray)
                            .padding(.vertical, 40)
                    } else {
                        ForEach(orderItems) { item in
                            if let favoriteItem = favoriteItems.first(where: { $0.menu.name == item.menuName }) {
                                HStack(alignment: .top) {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(favoriteItem.menu.name)
                                            .font(.headline)
                                        
                                        Text("Rp\(item.price)")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                    
                                    Spacer()
                                    
                                    Text("\(item.quantity) × Rp\(item.price)")
                                        .font(.subheadline)
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                }
                .padding(.vertical)
            }
            
            // Footer with total
            if !orderItems.isEmpty {
                Divider()
                
                HStack {
                    Text("Total")
                        .font(.headline)
                    
                    Spacer()
                    
                    Text("Rp\(totalPrice)")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.orange)
                }
                .padding()
            }
        }
        .background(Color(.systemBackground))
    }
}
