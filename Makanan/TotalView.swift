//
//  TotalView.swift
//  Makanan
//
//  Created by Eliza Vornia on 08/05/25.
//
import SwiftUI

struct TotalView: View {
    var total: Int
    var itemCount: Int
    var onSave: () -> Void
    var onCartTapped: () -> Void

    var body: some View {
        HStack {
            // Cart icon with price
            Button(action: onCartTapped) {
                HStack(spacing: 8) {
                    Image(systemName: "cart.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .overlay(alignment: .topTrailing) {
                            if itemCount > 0 {
                                Text("\(itemCount)")
                                    .font(.caption2.bold())
                                    .foregroundColor(.white)
                                    .padding(4)
                                    .background(Color.orange)
                                    .clipShape(Circle())
                                    .offset(x: 6, y: -8)
                            }
                        }
                    
                    Text("Rp \(total.formatted(.number.grouping(.automatic))),-")
                        .font(.system(size: 18))
                        .foregroundColor(.black)
                }
            }

            Spacer()

            // Konfirmasi button
            Button(action: {
                onSave()
            }) {
                Text("Pesan")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 24)
                    .background(Color.orange)
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .padding(.horizontal)
    }
}
