//
//  RootView.swift
//  Makanan
//
//  Created by Eliza Vornia on 17/05/25.
//
import SwiftUI

struct RootView: View {
    @EnvironmentObject private var deeplinkManager: DeepLinkManager
    
    var body: some View {
        NavigationStack {
            HomePage(stalls: Stall.all)
                .navigationDestination(isPresented: $deeplinkManager.isShowingFavorite) {
                    FavoritPage()
                }
                .onChange(of: deeplinkManager.currentLink) { newValue in
                    if newValue == "favorit" {
                        deeplinkManager.isShowingFavorite = true
                        deeplinkManager.currentLink = nil
                    }
                }
        }
    }
}
