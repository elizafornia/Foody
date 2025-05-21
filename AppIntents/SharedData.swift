//
//  SharedData.swift
//  Makanan
//
//  Created by Eliza Vornia on 17/05/25.
//

import Foundation


let appGroupID = "group.com.eliza.MakananApp"

// MARK: - Shared Defaults
let sharedDefaults = UserDefaults(suiteName: appGroupID)

// MARK: - Keys
enum SharedKeys {
    static let favoriteMenus = "favoriteMenus"
}

// MARK: - Simpan ke Shared UserDefaults
func saveFavoritesToShared(_ favorites: [String]) {
    sharedDefaults?.set(favorites, forKey: SharedKeys.favoriteMenus)
}

// MARK: - Load dari Shared UserDefaults
//func loadFavoriteMenus() -> [String] {
//    return sharedDefaults?.stringArray(forKey: SharedKeys.favoriteMenus) ?? []
//}

//func loadFavoriteMenus() -> [String] {
//    let sharedDefaults = UserDefaults(suiteName: "group.com.yourcompany.MakananApp")
//    return sharedDefaults?.stringArray(forKey: "favoriteMenus") ?? []
//}
//

