//
//  FavoriteItem.swift
//  Makanan
//
//  Created by Eliza Vornia on 13/05/25.
//

import Foundation
import SwiftData

@Model
class FavoriteItem {
    @Attribute(.unique) var id: String
    var menu: Menu
    var menuName: String
    var imageName: String?
    var stall: Stall
    var dateAdded: Date
    var price: Int
    var stallName: String
    var menuID: String
 
    
    init(menu: Menu, stall: Stall) {
        self.id = UUID().uuidString
        self.menu = menu
        self.menuName = menu.name
        self.stall = stall
        self.dateAdded = Date()
        self.price = menu.price
        self.stallName = stall.name
        self.menuID = menu.id
        self.imageName = menu.imageName
       
    }
}
