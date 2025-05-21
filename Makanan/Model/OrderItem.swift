//
//  OrderItem.swift
//  Makanan
//
//  Created by Eliza Vornia on 12/05/25.
//


import SwiftData
import Foundation

@Model
class OrderItem {
    var id = UUID()
    var menuName: String
    var price: Int
    var quantity: Int = 0

    init(menuName: String, price: Int, quantity: Int = 0) {
        self.menuName = menuName
        self.price = price
        self.quantity = quantity
    }
}
