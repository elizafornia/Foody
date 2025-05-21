//
//  ShakeViewModel.swift
//  Makanan
//
//  Created by Eliza Vornia on 12/05/25.
//

import SwiftUI
import SwiftData

class ShakeViewModel: ObservableObject {
    @Published var favoriteMenus: [Menu] = []
    
    @Environment(\.modelContext) private var modelContext
    
    init() {
        fetchFavoriteMenus()
    }
    
    func fetchFavoriteMenus() {
        do {
            let descriptor = FetchDescriptor<Menu>(
                predicate: #Predicate { $0.isFavorited == true }
            )
            favoriteMenus = try modelContext.fetch(descriptor)
        } catch {
            print("❌ Gagal mengambil menu favorit: \(error)")
        }
    }

    func getRandomRecommendation() -> Menu? {
        return favoriteMenus.randomElement()
    }
}

//#Preview {
//    ShakeViewModel()
//}
