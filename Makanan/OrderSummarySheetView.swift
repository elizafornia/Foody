//
//  OrderSummarySheetView.swift
//  Makanan
//
//  Created by Eliza Vornia on 13/05/25.
//

import SwiftUI

struct OrderSummarySheetView: View {
    let orderItems: [OrderItem]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Ringkasan Pesanan")
                .font(.headline)
                .padding(.top)

            ForEach(orderItems, id: \.menuName) { item in
                HStack {
                    Text(item.menuName)
                    Spacer()
                    Text("x\(item.quantity)")
                    Text("Rp \(item.price * item.quantity)")
                }
                .font(.subheadline)
            }

            Spacer()
        }
        .padding()
    }
}

