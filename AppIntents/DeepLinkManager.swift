//
//  DeepLinkManager.swift
//  Makanan
//
//  Created by Eliza Vornia on 17/05/25.
//
import Foundation
import Combine

class DeepLinkManager: ObservableObject {
    static let shared = DeepLinkManager()
    
    @Published var currentLink: String?
    @Published var isShowingFavorite = false
    
    func handleDeepLink(_ url: URL) {
        if url.scheme == "makananapp", let host = url.host {
            currentLink = host
            print("Deep link received:", host)
        }
    }
    
    func triggerFavoritePage() {
        currentLink = "favorit"
    }
}
