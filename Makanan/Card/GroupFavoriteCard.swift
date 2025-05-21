//
//  GroupFavoriteCard.swift
//  Makanan
//
//  Created by Eliza Vornia on 18/05/25.
//


import SwiftUI

struct GroupFavoriteCard: View {
    let stall: Stall
    let menuCount: Int
    @Environment(\.modelContext) private var modelContext
    
    
    var body: some View {
        NavigationLink(destination: FavoritPage(selectedStall: stall).environment(\.modelContext, modelContext)){
            VStack(alignment: .leading, spacing: 4) {
                // Stall Image
                Image(stall.images.first ?? "defaultStallImage")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 114, height: 90)
                    .clipped()
                    .cornerRadius(20, corners: [.topLeft, .topRight])
                
                // Stall Info
                VStack(alignment: .leading, spacing: 2) {
                    // Stall Name
                    Text(stall.name)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.primary)
                        .lineLimit(1)
                    
                    // Menu Count
                    Text("\(menuCount) menu")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 8)
                .padding(.bottom, 8)
            }
            .frame(width: 114, height: 140)
            .background(Color(.systemBackground))
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        }
    }
}
// Extension corner radius
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
