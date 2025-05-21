//
//  ShortcutsIntent.swift
//  Makanan
//
//  Created by Eliza Vornia on 16/05/25.
//
//
//import Foundation
//import AppIntents
//
//// MARK: -- Your Item
//enum CoffeeType: String, AppEnum {
//    case latte, cappuccino, macchiato
//    
//    static var typeDisplayRepresentation: TypeDisplayRepresentation {
//        "Coffee Type"
//    }
//
//    static var caseDisplayRepresentations: [CoffeeType : DisplayRepresentation] {
//        [
//            .latte: "Latte",
//            .cappuccino: "Cappuccino",
//            .macchiato: "Macchiato"
//        ]
//    }
//}
//
//// MARK: -- Step 2: Make Your App Intent Accessible in Your Device Here
//
//
//struct AppIntentShortcutProvider: AppShortcutsProvider {
//    
//    @AppShortcutsBuilder
//    static var appShortcuts: [AppShortcut] {
//        AppShortcut(intent: OrderCoffee(),
//                    phrases: ["Order coffee in \(.applicationName)"]
//                    ,shortTitle: "Order Coffee", systemImageName: "cup.and.saucer.fill")
//        
//        AppShortcut(intent: OrderCappuccino(),
//                    phrases: ["Order a cappuccino in \(.applicationName)"]
//                    ,shortTitle: "Order Cappuccino", systemImageName: "cup.and.saucer.fill")
//        
//        AppShortcut(intent: YourOwnAction(),
//                    phrases: ["My Own Action in \(.applicationName)"]
//                    ,shortTitle: "Own Action", systemImageName: "heart.fill")
//        
//    }
//    
//}
//
//// MARK: -- Step 1: Create Your App Intent Here
//struct OrderCoffee: AppIntent {
//    
//    @Parameter(title: "Coffee Type") var coffeeType: CoffeeType
//    @Parameter(title: "Quantity") var quantity: Int
//    @Parameter(title: "Your Name") var name: String
//    
//    static var title: LocalizedStringResource = LocalizedStringResource("Order Coffee")
//    
//    func perform() async throws -> some IntentResult {
//        print("Selected Coffee Type: \(coffeeType)")
//        OrderViewModel.shared.addOrder(name: name, coffeeType: coffeeType.rawValue.capitalized, quantity: quantity)
//        print(OrderViewModel.shared.orderList)
//        return .result()
//    }
//}
//
//struct OrderCappuccino: AppIntent {
//    
//    @Parameter(title: "Quantity") var quantity: Int
//    @Parameter(title: "Your Name") var name: String
//
//    static var title: LocalizedStringResource = LocalizedStringResource("Order Cappuccino")
//    
//    func perform() async throws -> some IntentResult {
//        OrderViewModel.shared.addOrder(name: name, coffeeType: "Cappuccino", quantity: quantity)
//        return .result()
//    }
//    
//}
//
//// MARK: -- Customize Your Own
//struct YourOwnAction: AppIntent {
//    
//    @Parameter(title: "Your Parameter") var parameter1: Int //untuk meminta data sesuai kebututhan aplikasi
//    @Parameter(title: "Your Parameter") var parameter2: String //
//
//    static var title: LocalizedStringResource = LocalizedStringResource("Your Own")
//    
//    func perform() async throws -> some IntentResult {
//        print("this is your input, parameter1: \(parameter1), parameter2: \(parameter2)")
//        return .result()
//    }
//    
//}
//
//import AppIntents
//import SwiftData
//
//// MARK: - Helper untuk baca/tulis favorite menu di UserDefaults App Group
//
//let appGroupSuiteName = "group.com.yourcompany.MakananApp"
//let favoritesKey = "favoriteMenus"
//
//func loadFavoriteMenus() -> [String] {
//    guard let userDefaults = UserDefaults(suiteName: appGroupSuiteName) else {
//        print("❌ Gagal akses UserDefaults App Group")
//        return []
//    }
//    return userDefaults.stringArray(forKey: favoritesKey) ?? []
//}
//
//func saveFavoriteMenus(_ menus: [String]) {
//    guard let userDefaults = UserDefaults(suiteName: appGroupSuiteName) else {
//        print("❌ Gagal akses UserDefaults App Group")
//        return
//    }
//    userDefaults.set(menus, forKey: favoritesKey)
//    userDefaults.synchronize()
//}
//
//// MARK: - Entity untuk Menu Favorit
//struct FavoriteMenuEntity: AppEntity, Identifiable {
//    var id: String { name }
//    var name: String
//
//    static var typeDisplayRepresentation: TypeDisplayRepresentation {
//        TypeDisplayRepresentation(name: "Menu Favorit")
//    }
//
//    static var defaultQuery = FavoriteMenuQuery()
//
//    var displayRepresentation: DisplayRepresentation {
//        DisplayRepresentation(title: LocalizedStringResource(stringLiteral: name))
//    }
//}
//
//// MARK: - Intent Dinamis untuk Order Menu Favorit
//struct OrderFavoriteMenu: AppIntent {
//    static var title: LocalizedStringResource = "Order Favorite Menu"
//
//    @Parameter(title: "Menu Favorit")
//    var menu: FavoriteMenuEntity
//
//    @Parameter(title: "Jumlah")
//    var quantity: Int
//
//    @Parameter(title: "Nama Pemesan")
//    var name: String
//
//    func perform() async throws -> some IntentResult {
//        print("📦 User \(name) memesan \(quantity) porsi \(menu.name)")
//        return .result(value: "Berhasil pesan \(quantity) \(menu.name) atas nama \(name)")
//    }
//}
//
//// MARK: - Query untuk menyarankan Menu Favorit
//struct FavoriteMenuQuery: EntityQuery {
//    func entities(for identifiers: [String]) async throws -> [FavoriteMenuEntity] {
//        let all = loadFavoriteMenus()
//        return all
//            .filter { identifiers.contains($0) }
//            .map { FavoriteMenuEntity(name: $0) }
//    }
//
//    func suggestedEntities() async throws -> [FavoriteMenuEntity] {
//        let all = loadFavoriteMenus()
//        print("🔍 Suggested menus: \(all)")
//        return all.map { FavoriteMenuEntity(name: $0) }
//    }
//}
//
//// MARK: - Shortcut Provider
//struct AppIntentShortcutProvider: AppShortcutsProvider {
//    @AppShortcutsBuilder
//    static var appShortcuts: [AppShortcut] {
//        AppShortcut(
//            intent: OrderFavoriteMenu(),
//            phrases: [
//                "Pesan menu favorit di \(.applicationName)",
//                "Order makanan favorit saya di \(.applicationName)"
//            ],
//            shortTitle: "Order Favorit",
//            systemImageName: "cart.fill"
//        )
//    }
//}
import AppIntents

struct OpenFavoritePageIntent: AppIntent {
    static var title: LocalizedStringResource = "Buka Halaman Favorit"
    static var description = IntentDescription("Membuka halaman makanan favorit")
    
    @MainActor
    func perform() async throws -> some IntentResult {
        DeepLinkManager.shared.triggerFavoritePage()
        return .result()
    }
}

struct AppIntentShortcutProvider: AppShortcutsProvider {
    @AppShortcutsBuilder
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: OpenFavoritePageIntent(),
            phrases: [
                "Buka halaman favorit di \(.applicationName)",
                "Tampilkan makanan favorit di \(.applicationName)"
            ],
            shortTitle: "Buka Favorit",
            systemImageName: "heart.fill"
        )
    }
}
