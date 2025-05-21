//
//  FavoriteViewModel.swift
//  Makanan
//
//  Created by Eliza Vornia on 11/05/25.
//
import Foundation
import SwiftData
import SwiftUI

class FavoriteViewModel: ObservableObject {
    @Published var menus: [Menu] = []  // Daftar menu yang ada
    @Published var recommendedMenus: [FavoriteItem] = [] // Menu yang direkomendasikan
    @Published var shakeResultText: String? = nil


    private var modelContext: ModelContext

    // Inisialisasi FavoriteViewModel dengan modelContext
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    

    // Menambahkan menu ke favorit #1
    func addToFavorites(menu: Menu) {
        // Jika menu sudah ada dalam favorit, jangan ditambahkan lagi
        if !menus.contains(where: { $0.id == menu.id }) {
            menus.append(menu) // Menambahkan menu ke dalam daftar favorit
            print("Menu '\(menu.name)' berhasil ditambahkan ke favorit.")
            menu.isFavorited = true
            try? modelContext.save() // Simpan perubahan ke SwiftData
        } else {
            print("Menu '\(menu.name)' sudah ada di favorit.")
        }
    }

  //   Menghapus menu dari favorit #2
    func removeFromFavorites(menu: Menu) {
        if let index = menus.firstIndex(where: { $0.id == menu.id }) {
            menus.remove(at: index) // Menghapus menu dari daftar favorit
            print("Menu '\(menu.name)' berhasil dihapus dari favorit.")
            menu.isFavorited = false
            try? modelContext.save() // Simpan perubahan setelah dihapus
        } else {
            print("Menu '\(menu.name)' tidak ditemukan di favorit.")
        }
    }

    // Mendapatkan rekomendasi menu berdasarkan favorit
    func getShakeRecommendation(favoriteMenus: [FavoriteItem]) {
        print("SHAKE DETECTED")
        print("Favorite count: \(menus.filter { $0.isFavorited }.count)")
        print("menu: \(menus.count)")

        if favoriteMenus.isEmpty {
            shakeResultText = "Favoritkan lebih banyak menu dulu!"
            recommendedMenus = []
            print(" RECOMMENDATION: Tidak ada menu favorit.")
            return
        }

        // Mengelompokkan menu favorit berdasarkan stall yang ada di dalam objek Menu
        let groupedByStall = Dictionary(grouping: favoriteMenus, by: { $0.stall.name })

        // Mencari dua menu acak dalam stall yang sama
        for (_, menusInStall) in groupedByStall {
            if menusInStall.count >= 2 {
                // Pilih dua menu acak dari stall yang sama
                let selectedMenus = Array(menusInStall.shuffled().prefix(2))
                recommendedMenus = selectedMenus
                shakeResultText = " \(selectedMenus[0].stall.name): \(selectedMenus[0].menuName), \(selectedMenus[1].menuName)"
                print("RECOMMENDATION: Two random menus from the same stall")
                return
            }
        }

        // Tidak ada kombinasi yang cocok
        recommendedMenus = []
        shakeResultText = "Hmmm belum ada hasil yang cocok nih untuk kamu,\n yuk favoritkan lebih banyak menu lagi!"
        print("RECOMMENDATION: Tidak ada yang cocok")
    }
}

