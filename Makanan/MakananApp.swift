//
//  MakananApp.swift
//  Makanan
//
//  Created by Eliza Vornia on 05/05/25.
//
import SwiftUI
import SwiftData
import AppIntents

@main
struct MakananApp: App {
    @StateObject private var deeplinkManager = DeepLinkManager()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(deeplinkManager)
                .onOpenURL { url in
                    deeplinkManager.handleDeepLink(url)
                    
                }
            
        }
        .modelContainer(for: [Stall.self, Menu.self, FavoriteItem.self])
    }
}

