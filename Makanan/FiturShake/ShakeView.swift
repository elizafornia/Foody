//
//  ShakeView.swift
//  Makanan
//
//  Created by Eliza Vornia on 11/05/25.
//
import SwiftUI
import UIKit
import SwiftData

struct ShakeView: View {
    @Environment(\.modelContext) private var modelContext
    @ObservedObject var viewModel: FavoriteViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showOrderConfirmation = false
    @State private var orderNotes = ""
    @State private var isShaking = false
    
    static var fetchDescriptor: FetchDescriptor<FavoriteItem> {
        let descriptor = FetchDescriptor<FavoriteItem>(
            predicate: #Predicate { $0.menu.isFavorited == true },
            sortBy: [SortDescriptor(\.dateAdded)]
        )
        return descriptor
    }
    
    var body: some View {
        VStack {
            // Back Button
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.orange)
                    Text("Back")
                        .foregroundColor(.orange)
                }
                .padding()
                Spacer()
            }
            
            if viewModel.recommendedMenus.isEmpty {
                // Shake Instruction View
                VStack(spacing: 24) {
                    Spacer()
                    
                    VStack(spacing: 8) {
                        Text("Shake Handphone kamu\nuntuk mendapatkan rekomendasi\npaket random dari menu favoritmu!")
                            .font(.system(size: 20, weight: .bold))
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(red: 0.29, green: 0.2, blue: 0.12))
                    }
                    
                    VStack(spacing: 12) {
                        Text("SHAKE!")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                        
                        Image("shakeomega")
                            .resizable()
                            .frame(width: 300, height: 300)
                            .rotationEffect(.degrees(isShaking ? 10 : -10))
                                                        .animation(
                                                            Animation.easeInOut(duration: 0.1)
                                                                .repeatCount(5, autoreverses: true),
                                                            value: isShaking
                                                        )
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 6) {
                        Text("Atau mau order dari favoritmu saja?")
                            .font(.body)
                            .foregroundColor(.black.opacity(0.8))
                        
                        NavigationLink(destination: FavoritPage()) {
                            Text("Klik disini")
                                .fontWeight(.semibold)
                                .foregroundColor(.orange)
                                .underline()
                        }
                    }
                    
                    Spacer(minLength: 80)
                }
            } else {
                // Recommendations View
                ScrollView {
                    VStack(spacing: 16) {
                        // Header
                        VStack(spacing: 8) {
                            Text("YUMMY!!")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.orange)
                            
                            Text("Menu makan kamu hari ini adalah...")
                                .font(.subheadline)
                                .foregroundColor(.black)
                        }
                        .padding(.top, 20)
                        
                        // Stall Name
                        Text(viewModel.recommendedMenus.first?.stallName ?? "Stall")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.bottom, 8)
                        
                    
                        VStack(spacing: 12) {
                            ForEach(viewModel.recommendedMenus, id: \.id) { item in
                                MenuItemCard(item: item)
                            }
                        }
                        .padding(.vertical, 16)
                    }
                    .padding(.horizontal, 20)
                }
                
                // Confirm Order Button
                Button(action: {
                    showOrderConfirmation = true
                }) {
                    Text("Konfirmasi Pesanan")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    
                }
                .padding(20)
                .sheet(isPresented: $showOrderConfirmation) {
                    if let firstItem = viewModel.recommendedMenus.first {
                        OrderConfirmationModal(
                            stall: firstItem.stall,
                            notes: $orderNotes,
                            orderItems: viewModel.recommendedMenus.map {
                                OrderItem(
                                    menuName: $0.menuName,
                                    price: $0.price,
                                    quantity: 1 // Fixed quantity = 1
                                )
                            },
                            whatsAppNumber: firstItem.stall.whatsAppNumber,
                            estimatedTotal: viewModel.recommendedMenus.reduce(0) { $0 + $1.price },
                            onPlaceOrder: {
                                // Reset after order
                                viewModel.recommendedMenus = []
                                orderNotes = ""
                            }
                        )
                    }
                }
            }
        }
        .background(ShakeDetector {
            isShaking = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            isShaking = false
                        }
            // Haptic feedback on shake
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
            
            do {
                let favoriteItems = try modelContext.fetch(ShakeView.fetchDescriptor)
                viewModel.getShakeRecommendation(favoriteMenus: favoriteItems)
            } catch {
                viewModel.getShakeRecommendation(favoriteMenus: [])
            }
        })
        .navigationBarHidden(true)
        .onAppear {
            // resert recommended menus when view appears
            viewModel.recommendedMenus = []
            orderNotes = ""
        }
    }
}


struct MenuItemCard: View {
    let item: FavoriteItem
    
    var body: some View {
        HStack(spacing: 16) {
          
            let imageName = item.menu.imageName.isEmpty ? item.imageName ?? "" : item.menu.imageName
            
            if !imageName.isEmpty {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(.systemGray4), lineWidth: 1)
                    )
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.gray)
                    .background(Color(.systemGray5))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.menuName)
                    .font(.body)
                    .fontWeight(.medium)
                
                Text("Rp\(item.price)")
                    .font(.subheadline)
                    .foregroundColor(.orange)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(.systemGray4), lineWidth: 1)
        )
    }
}
