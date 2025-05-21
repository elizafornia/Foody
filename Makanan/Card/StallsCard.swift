//
//  StallsCard.swift
//  Makanan
//
//  Created by Eliza Vornia on 08/05/25.
//
import Foundation
import SwiftUI
import SwiftData


struct StallsCard: View {
    var stall: Stall
    
    var body: some View {
        HStack {
            Image(stall.images[0])
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 90, height: 90)
                .cornerRadius(10)
                .padding(10)
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 6) {
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
                        .font(.system(size: 14))
                        .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                    
                }
                
                HStack {
                    Image(systemName: "wallet.bifold.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 14, height: 14)
                        .foregroundColor(.orange)
                    
                    Text("Rp\(stall.lowestPrice) - \(stall.highestPrice)")
                        .font(.system(size: 14))
                        .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))                }
                
                HStack {
                    Image(systemName: "star.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 15, height: 15)
                        .foregroundColor(.orange)
                    Text(String(format: "%.1f", stall.rating))
                        .font(.system(size: 14))
                        .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                }
            }
        }
    }
}

#Preview {
    StallsCard(stall: Stall.all[0])
}
