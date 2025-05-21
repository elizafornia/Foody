//
//  MenuPage.swift
//  Makanan
//
//  Created by Eliza Vornia on 08/05/25.
//
import SwiftUI
import SwiftData


extension View {
    func hideKeyboardOnTap() -> some View {
        self.gesture(
            TapGesture().onEnded {
                UIApplication.shared.sendAction(
                    #selector(UIResponder.resignFirstResponder),
                    to: nil, from: nil, for: nil
                )
            }
        )
    }
}

struct MenuPage: View {
    @Environment(\.modelContext) private var modelContext
    @State private var orderItemsState: [OrderItem] = []
    @State private var notes: String = ""
    @State private var showConfirmationModal = false
    @State private var showQuantityAlert = false
    @State private var menus: [Menu] = []
    @State private var showFavoriteToast: Bool = false
    @State private var isShowFilter: Bool = false
    @State private var showCartModal = false
    @State private var toastMessage: String = ""
    @State private var showToast: Bool = false

    let stall: Stall
    
    init(stall: Stall, menus: [Menu]? = nil) {
        self.stall = stall
        if let menus = menus {
            self._menus = State(initialValue: menus)
        }
    }

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 16) {
                        StallHeaderView(stall: stall)

                        Divider()
                            .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 2)

                        menuListView
                    }
                    .padding(.horizontal)
                }

                Divider()

                TotalView(
                    total: calculateTotal(),
                    itemCount: calculateItemCount(),
                    onSave: {
                        if orderItemsState.contains(where: { $0.quantity > 0 }) {
                            showConfirmationModal = true
                        } else {
                            showQuantityAlert = true
                        }
                    },
                    onCartTapped: {
                        showCartModal.toggle()
                    }
                )
                .frame(maxWidth: .infinity)
            }

            if showToast {
                toastView
            }
        }
        .hideKeyboardOnTap()
        .ignoresSafeArea(edges: .bottom)
        .onAppear {
            if orderItemsState.isEmpty {
                loadOrderItems()
            }
        }
        .sheet(isPresented: $showConfirmationModal) {
            OrderConfirmationModal(
                stall: stall,
                notes: $notes,
                orderItems: orderItemsState.filter { $0.quantity > 0 },
                whatsAppNumber: stall.whatsAppNumber,
                estimatedTotal: calculateTotal(),
                onPlaceOrder: {
                    saveOrder()
                    showConfirmationModal = false
                    toastMessage = "Pesanan berhasil dibuat!"
                    showToast = true
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            showToast = false
                        }
                    }
                }
            )
        }
        .alert("Oops.. pilih menu dulu yuk!", isPresented: $showQuantityAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Anda belum memilih menu apapun.")
        }
        .sheet(isPresented: $showCartModal) {
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("Keranjang Pesanan")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Button(action: { showCartModal = false }) {
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
                        if orderItemsState.filter({ $0.quantity > 0 }).isEmpty {
                            Text("Keranjang kosong")
                                .foregroundColor(.gray)
                                .padding(.vertical, 40)
                        } else {
                            ForEach(orderItemsState.filter { $0.quantity > 0 }, id: \.id) { item in
                                if let menuItem = stall.menuList.first(where: { $0.name == item.menuName }) {
                                    HStack(alignment: .top) {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(menuItem.name)
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
                if !orderItemsState.filter({ $0.quantity > 0 }).isEmpty {
                    Divider()
                    
                    HStack {
                        Text("Total")
                            .font(.headline)
                        
                        Spacer()
                        
                        Text("Rp\(calculateTotal())")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.orange)
                    }
                    .padding()
                }
            }
            .background(Color(.systemBackground))
            .presentationDetents([.medium, .large])
        }
    }

    private var menuListView: some View {
        VStack(spacing: 16) {
            ForEach($menus.indices, id: \.self) { index in
                let menu = menus[index]
                if let itemIndex = orderItemsState.firstIndex(where: { $0.menuName == menu.name }) {
                    MenuCard(
                        viewModel: MenuCardViewModel(
                            menu: menu,
                            stall: stall,
                            initialQuantity: orderItemsState[itemIndex].quantity,
                            onQuantityChanged: { newQty in
                                orderItemsState[itemIndex].quantity = newQty
                            }
                        ),
                        menu: $menus[index],
                        quantity: $orderItemsState[itemIndex].quantity
                    )
                }
            }
        }
    }

    private func loadOrderItems() {
        orderItemsState = stall.menuList.map {
            OrderItem(menuName: $0.name, price: Int($0.price))
        }
        menus = stall.menuList
    }

    private func calculateTotal() -> Int {
        orderItemsState.reduce(0) { $0 + ($1.price * $1.quantity) }
    }

    private func calculateItemCount() -> Int {
        orderItemsState.reduce(0) { $0 + $1.quantity }
    }

    private func saveOrder() {
        do {
            try modelContext.save()
            print("✅ Order saved successfully")
        } catch {
            print("❌ Failed to save order: \(error)")
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
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .animation(.easeInOut(duration: 0.3), value: showToast)
        }
    }
}

// MARK: - Warna Utama
extension Color {
    static let orangePrimary = Color(red: 1, green: 0.44, blue: 0.24)
}

