//
//  UserOrder.swift
//  Makanan
//
//  Created by Eliza Vornia on 08/05/25.
//


import Foundation
import SwiftData

@Model
class UserOrder {
    var id: UUID
    var menuItems: [String]
    var notes: String
    var total: Int
    var date: Date

    init(menuItems: [String], notes: String, total: Int) {
        self.id = UUID()
        self.menuItems = menuItems
        self.notes = notes
        self.total = total
        self.date = Date()
    }
}
