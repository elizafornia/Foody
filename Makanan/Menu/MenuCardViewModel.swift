//
//  MenuCardViewModel.swift
//  Makanan
//
//  Created by Eliza Vornia on 13/05/25.
//
import SwiftUI
import SwiftData

@MainActor
class MenuCardViewModel: ObservableObject {
    let menu: Menu
    let stall: Stall
    @Published var quantity: Int
    private var onQuantityChanged: (Int) -> Void
    
    // Debug identifier
    private let debugPrefix = "[MenuCardViewModel]"
    
    init(menu: Menu, stall: Stall, initialQuantity: Int, onQuantityChanged: @escaping (Int) -> Void) {
        self.menu = menu
        self.stall = stall
        self.quantity = initialQuantity
        self.onQuantityChanged = onQuantityChanged
        print("\(debugPrefix) Initialized for \(menu.name)")
    }

    func toggleFavorite(isFavorited: Bool, context: ModelContext) {
        print("\(debugPrefix) Toggling favorite for \(menu.name) to \(isFavorited)")
        
        menu.isFavorited = isFavorited
        
        do {
            if isFavorited {
                let favoriteItem = FavoriteItem(menu: menu, stall: stall)
                context.insert(favoriteItem)
                print("\(debugPrefix) Added to favorites: \(menu.name)")
                NotificationCenter.default.post(
                    name: .didAddFavorite,
                    object: nil,
                    userInfo: ["menuName": menu.name]
                )
            } else {
                let targetMenuID = menu.id
                let fetchRequest = FetchDescriptor<FavoriteItem>(
                    predicate: #Predicate { $0.menuID == targetMenuID }
                )
                
                if let existing = try? context.fetch(fetchRequest).first {
                    context.delete(existing)
                    print("\(debugPrefix) Removed from favorites: \(menu.name)")
                } else {
                    print("\(debugPrefix) Warning: Favorite item not found for \(menu.name)")
                }
            }
            
            try context.save()
            print("\(debugPrefix) Successfully saved context")
        } catch {
            print("\(debugPrefix) Error saving favorite state: \(error.localizedDescription)")
            // Revert the UI state if save fails
            DispatchQueue.main.async {
                self.menu.isFavorited = !isFavorited
            }
        }
    }
    
    func incrementQuantity() {
        quantity += 1
        onQuantityChanged(quantity)
        print("\(debugPrefix) Incremented \(menu.name) quantity to \(quantity)")
    }

    func decrementQuantity() {
        if quantity > 0 {
            quantity -= 1
            onQuantityChanged(quantity)
            print("\(debugPrefix) Decremented \(menu.name) quantity to \(quantity)")
        } else {
            print("\(debugPrefix) Attempted to decrement below zero for \(menu.name)")
        }
    }

    var formattedPrice: String {
        let formatted = "Rp \(menu.price.formatted(.number.grouping(.automatic))),-"
        print("\(debugPrefix) Formatted price for \(menu.name): \(formatted)")
        return formatted
    }
    
    // Helper function to debug current state
    func debugState() {
        print("""
        \(debugPrefix) Current State:
        Menu: \(menu.name)
        Stall: \(stall.name)
        Quantity: \(quantity)
        IsFavorited: \(menu.isFavorited)
        """)
    }
}
