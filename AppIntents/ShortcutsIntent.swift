//
//  ShortcutsIntent.swift
//  Makanan
//
//  Created by Eliza Vornia on 16/05/25.
//
//

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
