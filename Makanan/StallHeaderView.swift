//
//  StallHeaderView.swift
//  Makanan
//
//  Created by Eliza Vornia on 08/05/25.
//
import SwiftUI

struct StallHeaderView: View {
    var stall: Stall

    var body: some View {
        HStack {
            Image(stall.images[0])
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 100)
                .cornerRadius(12)
                .padding(8)

            Spacer()

            VStack(alignment: .leading) {
                HStack {
                    Text(stall.name)
                        .font(.headline)
                    Spacer()
                }

                HStack {
                    Image(systemName: "pin.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 15, height: 15)
                        .foregroundColor(.orange)
                    Text(stall.location)
                        .font(.subheadline)
                }

                HStack {
                    Image(systemName: "wallet.bifold.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.orange)
                        .frame(width: 14, height: 14)

                    Text("\(formatPrice(stall.lowestPrice))-\(formatPrice(stall.highestPrice))")
                        .font(.subheadline)
                }

                HStack {
                    Image(systemName: "star.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 15, height: 15)
                        .foregroundColor(.orange)
                    Text(String(format: "%.1f", stall.rating))
                        .font(.subheadline)
                }
            }
        }
    }

    // Fungsi bantu untuk memformat harga
    func formatPrice(_ price: Int) -> String {
        if price >= 1000 {
            let formatted = Double(price) / 1000
            return String(format: "%.0fK", formatted)
        } else {
            return "\(price)"
        }
    }
}

#Preview {
    StallHeaderView(stall: Stall.all[0])
}
