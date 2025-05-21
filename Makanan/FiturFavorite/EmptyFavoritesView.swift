//
//  empty.swift
//  Makanan
//
//  Created by Eliza Vornia on 15/05/25.
//
import SwiftUI

struct EmptyFavoritesView: View {
    @State private var isActive = false
    
    var body: some View {
        NavigationView {
            VStack {
                // Top section
                VStack(spacing: 8) {
                    Text("Opsss!")
                        .font(.largeTitle)
                        .kerning(0.38)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(red: 1, green: 0.44, blue: 0.24))
                        .frame(maxWidth: .infinity, alignment: .top)
                    
                    Text("Kamu belum memilih menu favorit nih")
                        .font(.subheadline)
                        .foregroundColor(Color(red: 0.29, green: 0.2, blue: 0.12))
                }
                .padding(.top, 100)
                
                // Center image
                Spacer()
                Image("shakeomega")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
                Spacer()
                
                // Navigation Button
                NavigationLink(
                    destination: HomePage().navigationBarBackButtonHidden(true),
                    isActive: $isActive
                ) {
                    Button(action: {
                        isActive = true
                    }) {
                        Text("Favoritin Sekarang")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.orange)
                            .cornerRadius(10)
                    }
                }
                .padding(.bottom, 60)
            }
            .padding(.horizontal, 16)
            .navigationBarHidden(true) // Sembunyikan navbar di EmptyFavoritesView
        }
    }
}

struct EmptyFavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyFavoritesView()
    }
}
