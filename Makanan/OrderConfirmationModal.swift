//
//  OrderConfirmationModal.swift
//  Makanan
//
//  Created by Eliza Vornia on 08/05/25.
//
import SwiftUI
import SwiftData

struct OrderConfirmationModal: View {
    @Bindable var stall: Stall
    @Binding var notes: String
    var orderItems: [OrderItem]
    var whatsAppNumber: String
    var estimatedTotal: Int
    var onPlaceOrder: () -> Void

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var showPlaceOrderAlert = false
    @State private var openWhatsApp = false

    var totalItems: Int {
        orderItems.reduce(0) { $0 + $1.quantity }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Konfirmasi Pesanan")
                .font(.title)
                .bold()
                .padding(.top, 25)

            VStack(alignment: .leading, spacing: 8) {
                Text("📝 Catatan")
                    .font(.headline)
                TextField("tambahkan catatan...", text: $notes)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("📋 Ringkasan Pesanan")
                    .font(.headline)

                ScrollView {
                    VStack(spacing: 8) {
                        ForEach(orderItems, id: \.menuName) { order in
                            HStack {
                                Text(order.menuName)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text("x\(order.quantity)")
                                    .frame(width: 40, alignment: .center)
                                Text("Rp \(order.price * order.quantity),-")
                                    .frame(width: 100, alignment: .trailing)
                            }
                            .padding(.vertical, 4)
                            Divider()
                        }
                    }
                    .padding(.horizontal)
                }
                .frame(maxWidth: .infinity)
                .background(Color(.systemGray6).opacity(0.5))
                .cornerRadius(12)
            }

            Spacer()

            VStack(alignment: .leading, spacing: 4) {
                Text("🍽️ Total Item: \(totalItems)")
                    .font(.headline)
                Text("💰 Total Estimasi Harga: Rp \(estimatedTotal.formatted(.number.grouping(.automatic))),-")
                    .font(.headline)
            }

            Button(action: {
                showPlaceOrderAlert = true
            }) {
                HStack(alignment: .center, spacing: 10) {
                    // Body/Emphasized
                    Text("Pesan Lewat WhatsApp")
                      .font(
                        Font.custom("SF Pro", size: 17)
                          .weight(.semibold)
                      )
                      .foregroundColor(Color(red: 1, green: 0.96, blue: 0.94))
                }
                
                .padding(.trailing, 16)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .frame(width: 329, alignment: .center)
                .background(Color(red: 1, green: 0.44, blue: 0.24))
                .cornerRadius(8)
            }
        }
        .padding()
        .alert("Lanjutkan Pemesanan?", isPresented: $showPlaceOrderAlert) {
            Button("Batal", role: .cancel) {}
            Button("Ya") {
                stall.wasOrdered = true
                let menuNames = orderItems.map { "\($0.menuName) x\($0.quantity)" }
                let order = UserOrder(menuItems: menuNames, notes: notes, total: estimatedTotal)
                modelContext.insert(order)
                onPlaceOrder()
                openWhatsApp = true
            }
        }
        .onChange(of: openWhatsApp) {
            if openWhatsApp {
                openWhatsAppURL()
            }
        }
    }

    private func openWhatsAppURL() {
        let text = """
        Halo 👋, saya ingin order. Berikut detailnya:
        \(orderItems.map { "- \($0.menuName) x\($0.quantity)" }.joined(separator: "\n"))
        \(notes.isEmpty ? "" : "\n📝 Catatan: \(notes)")

        Mohon infonya, total harga pastinya berapa ya? Terima kasih 🙏
        """

        guard let encodedText = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://wa.me/\(whatsAppNumber)?text=\(encodedText)"),
              UIApplication.shared.canOpenURL(url) else {
            print("⚠️ Gagal membuat atau membuka URL WhatsApp")
            return
        }

        UIApplication.shared.open(url) { success in
            if success {
                print("✅ WhatsApp opened successfully")
            } else {
                print("❌ Failed to open WhatsApp")
            }
        }
    }
}
