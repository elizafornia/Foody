//
//  FavoritPage.swift
//  Makanan
//
//  Created by Eliza Vornia on 08/05/25.
//
import SwiftUI
import SwiftData
import Foundation

extension Notification.Name {
    static let didAddFavorite = Notification.Name("didAddFavorite")
}

struct FavoritPage: View {
    @Query var favoriteItems: [FavoriteItem]
    @Environment(\.modelContext) private var modelContext
    @State private var showStallMismatchAlert = false
    @State private var pendingUpdate: (menu: Menu, newValue: Int)? = nil
    @State private var showToast = false
    @State private var toastMessage = ""
    @State private var orderItems: [OrderItem] = []
    @State private var showCartModal = false
    @State private var notes: String = ""
    @State private var showConfirmationModal = false
    @State private var refreshID = UUID()
    
    @State var selectedStall: Stall?
    
    var groupedFavorites: [(stallName: String, items: [FavoriteItem])] {
        let filteredItems = favoriteItems.filter { item in
            selectedStall == nil || item.menu.stallName == selectedStall?.name
        }
        
        let grouped = Dictionary(grouping: filteredItems, by: { $0.menu.stallName })
        return grouped.map { (stallName: $0.key, items: $0.value) }
            .sorted { $0.stallName < $1.stallName }
    }
    
    var body: some View {
        ZStack {
            if favoriteItems.isEmpty {
                EmptyFavoritesView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white)
                    .edgesIgnoringSafeArea(.all)
            } else {
                VStack(spacing: 0) {
                    // Header untuk stall yang dipilih (tanpa gambar)
                    if let stall = selectedStall {
                        HStack {
                            Text(stall.name)
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Spacer()
                        }
                        .padding()
                    }
                    
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(groupedFavorites, id: \.stallName) { group in
                                VStack(alignment: .leading, spacing: 10) {
                                    if selectedStall == nil {
                                        Text(group.stallName)
                                            .font(.title3)
                                            .fontWeight(.semibold)
                                            .padding(.horizontal)
                                    }
                                    
                                    ForEach(group.items.indices, id: \.self) { index in
                                        let item = group.items[index]
                                        FavoriteMenuCard(
                                            menu: item.menu,
                                            quantity: getQuantityBinding(for: item.menu),
                                            refreshID: $refreshID
                                        )
                                        
                                        if index < group.items.count - 1 {
                                            Divider()
                                                .padding(.leading, 72)
                                        }
                                    }
                                }
                                .padding(.bottom)
                                .id(refreshID)
                            }
                        }
                        .padding()
                        .padding(.bottom, 80)
                    }
                    
                    TotalView(
                        total: calculateTotal(),
                        itemCount: calculateItemCount(),
                        onSave: handleSaveOrder,
                        onCartTapped: { showCartModal.toggle() }
                    )
                }
            }
            
            if showToast {
                toastView
            }
        }
        .sheet(isPresented: $showCartModal) {
            CartModalView(
                orderItems: orderItems.filter { $0.quantity > 0 },
                favoriteItems: favoriteItems,
                onClose: { showCartModal = false }
            )
            .presentationDetents([.medium, .large])
            
        }
        .alert("Oopss!", isPresented: $showStallMismatchAlert) {
            Button("Ya", role: .destructive) { applyPendingUpdate() }
            Button("Tidak", role: .cancel) { pendingUpdate = nil }
        } message: {
            Text("Menambahkan menu dari stall lain akan mereset keranjangmu. Lanjut?")
        }
        .sheet(isPresented: $showConfirmationModal) {
            if let stall = selectedStall ?? (orderItems.first { $0.quantity > 0 }.flatMap { item in
                favoriteItems.first { $0.menu.name == item.menuName }?.menu.stall
            }) {
                OrderConfirmationModal(
                    stall: stall,
                    notes: $notes,
                    orderItems: orderItems.filter { $0.quantity > 0 },
                    whatsAppNumber: stall.whatsAppNumber,
                    estimatedTotal: calculateTotal(),
                    onPlaceOrder: confirmOrder
                )
                .presentationDetents([.large])
            }
        }
        .onAppear(perform: initializeOrderItems)
        .onChange(of: orderItems) { _ in refreshID = UUID() }
        .navigationTitle(selectedStall == nil ? "Favorit" : "")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Helper Functions
    private func initializeOrderItems() {
        orderItems = favoriteItems.map {
            OrderItem(menuName: $0.menu.name, price: Int($0.menu.price))
        }
    }
    
    private func getQuantityBinding(for menu: Menu) -> Binding<Int> {
        Binding(
            get: { orderItems.first { $0.menuName == menu.name }?.quantity ?? 0 },
            set: { newValue in
                let currentStalls = orderItems
                    .filter { $0.quantity > 0 }
                    .compactMap { item in
                        favoriteItems.first { $0.menu.name == item.menuName }?.menu.stallName
                    }
                
                if currentStalls.isEmpty || currentStalls.allSatisfy { $0 == menu.stallName } {
                    if let index = orderItems.firstIndex(where: { $0.menuName == menu.name }) {
                        orderItems[index].quantity = newValue
                    }
                } else {
                    pendingUpdate = (menu, newValue)
                    showStallMismatchAlert = true
                }
            }
        )
    }
    
    private func calculateTotal() -> Int {
        orderItems.reduce(0) { $0 + ($1.price * $1.quantity) }
    }
    
    private func calculateItemCount() -> Int {
        orderItems.reduce(0) { $0 + $1.quantity }
    }
    
    private func handleSaveOrder() {
        if let firstItem = orderItems.first(where: { $0.quantity > 0 }),
           let matchingFavorite = favoriteItems.first(where: { $0.menu.name == firstItem.menuName }),
           let stall = matchingFavorite.menu.stall {
            showConfirmationModal = true
        }
    }
    
    private func applyPendingUpdate() {
        if let pending = pendingUpdate {
            orderItems = orderItems.map { item in
                var newItem = item
                newItem.quantity = (item.menuName == pending.menu.name) ? pending.newValue : 0
                return newItem
            }
            pendingUpdate = nil
        }
    }
    
    private func confirmOrder() {
        orderItems = orderItems.map { item in
            var newItem = item
            newItem.quantity = 0
            return newItem
        }
        notes = ""
        showConfirmationModal = false
        toastMessage = "Pesanan berhasil dibuat!"
        showToast = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation { showToast = false }
        }
    }
    
    private var toastView: some View {
        VStack {
            Spacer()
            Text(toastMessage)
                .font(.subheadline)
                .foregroundColor(.white)
                .padding()
                .background(Color.black.opacity(0.85))
                .cornerRadius(10)
                .padding(.bottom, 20)
                .transition(.move(edge: .bottom))
                .animation(.easeInOut(duration: 0.3), value: showToast)
        }
    }
}
