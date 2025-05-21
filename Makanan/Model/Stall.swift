//
//  Stall.swift
//  Makanan
//
//  Created by Eliza Vornia on 05/05/25.
//
import Foundation
import SwiftData

@Model
class Stall: Identifiable {
    var id: UUID
    var name: String
    var images: [String]
    var rating: Double
    var location: String
    var category: [String]
    var lowestPrice: Int
    var highestPrice: Int
    var wasOrdered: Bool
    var whatsAppNumber: String
    var menuImage: String

    @Relationship var menuList: [Menu] // Relasi menu


    init(
        id: UUID = UUID(),
        name: String,
        images: [String],
        rating: Double,
        location: String,
        category: [String],
        lowestPrice: Int,
        highestPrice: Int,
        wasOrdered: Bool = false,
        menuList: [Menu] = [], // Default ke array kosong
        whatsAppNumber: String,
        menuImage: String
    ) {
        self.id = id
        self.name = name
        self.images = images
        self.rating = rating
        self.location = location
        self.category = category
        self.lowestPrice = lowestPrice
        self.highestPrice = highestPrice
        self.wasOrdered = wasOrdered
        self.menuList = menuList 
        self.whatsAppNumber = whatsAppNumber
        self.menuImage = menuImage
    }
}

// MARK: - MenuType Enum
enum MenuType: String, Codable, CaseIterable {
    case carb
    case protein
    case fiber
    case drink
    case complete
}

// MARK: - Menu Model
@Model
class Menu: Identifiable {
    @Attribute(.unique) var id: String
    var name: String
    var type: MenuType
    var price: Int
    var imageName: String
    var isFavorited: Bool = false 
    var stallName: String
    var stallLocation: String
    var stall: Stall?
    var stallID: String
    var quantity: Int

    init(
        id: String = UUID().uuidString,
        name: String,
        type: MenuType,
        price: Int,
        imageName: String = "defaultImage",
        isFavorited: Bool = false,
        stallName: String,
        stallLocation: String,
        stall: Stall? = nil,
        stallID: String,
        quantity: Int = 0 // Added with default value
    ) {
        self.id = id
        self.name = name
        self.type = type
        self.price = price
        self.imageName = imageName
        self.isFavorited = isFavorited
        self.stallName = stallName
        self.stallLocation = stallLocation
        self.stall = stall
        self.stallID = stallID
        self.quantity = quantity // Initialize quantity
    }
}

extension Stall {
    static let all: [Stall] = {
        let mustafa = Stall(
            name: "Mustafa Minang",
            images: ["mustafaminang"],
            rating: 4.8,
            location: "GOP 9",
            category: ["Nasi", "Sayuran"],
            lowestPrice: 5000,
            highestPrice: 25000,
            whatsAppNumber: "6285945553570",
            menuImage: "Kasturi"
        )

        mustafa.menuList = [
            Menu(name: "Nasi Padang", type: .complete, price: 15000, imageName: "nasipadang", stallName: mustafa.name, stallLocation: mustafa.location, stall: mustafa, stallID: mustafa.id.uuidString),
            Menu(name: "Nasi Telur Balado", type: .complete, price: 15000, imageName: "telurbalado", stallName: mustafa.name, stallLocation: mustafa.location, stall: mustafa, stallID: mustafa.id.uuidString),
            Menu(name: "Nasi Bakar", type: .complete, price: 15000, imageName: "bakarnasi", stallName: mustafa.name, stallLocation: mustafa.location, stall: mustafa, stallID: mustafa.id.uuidString),
            Menu(name: "Sayur sop", type: .fiber, price: 7000, imageName: "sopsop", stallName: mustafa.name, stallLocation: mustafa.location, stall: mustafa, stallID: mustafa.id.uuidString),
            Menu(name: "Sayur Nangka", type: .fiber, price: 5000, imageName: "sayurnangka", stallName: mustafa.name, stallLocation: mustafa.location, stall: mustafa, stallID: mustafa.id.uuidString),
            Menu(name: "Sayur Asem", type: .fiber, price: 10000, imageName: "sayurasem", stallName: mustafa.name, stallLocation: mustafa.location, stall: mustafa, stallID: mustafa.id.uuidString),
            Menu(name: "Nasi Sambal goreng Ati", type: .complete, price: 23000, imageName: "ayam", stallName: mustafa.name, stallLocation: mustafa.location, stall: mustafa, stallID: mustafa.id.uuidString),
            Menu(name: "Nasi Gulai Otak", type: .complete, price: 25000, imageName: "otak", stallName: mustafa.name, stallLocation: mustafa.location, stall: mustafa, stallID: mustafa.id.uuidString)
        ]



        let ahza = Stall(
            name: "Ahza Snack & Beverage",
            images: ["ahza"],
            rating: 4.9,
            location: "GOP 9",
            category: ["Cemilan", "Minuman", "Mie"],
            lowestPrice: 3000,
            highestPrice: 12000,
            whatsAppNumber: "6289516851555",
            menuImage: "Kasturi"
        )

        ahza.menuList = [
            Menu(name: "Salad Buah", type: .fiber, price: 12000, imageName: "saladbuah", stallName: ahza.name, stallLocation: ahza.location, stall: ahza, stallID: ahza.id.uuidString),
            Menu(name: "Jus Mangga", type: .drink, price: 8000, imageName: "jusmangga", stallName: ahza.name, stallLocation: ahza.location, stall: ahza, stallID: ahza.id.uuidString),
            Menu(name: "Jus Apel", type: .drink, price: 8000, imageName: "jusapel", stallName: ahza.name, stallLocation: ahza.location, stall: ahza, stallID: ahza.id.uuidString),
            Menu(name: "Jus Jeruk", type: .drink, price: 8000, imageName: "jusjeruk", stallName: ahza.name, stallLocation: ahza.location, stall: ahza, stallID: ahza.id.uuidString),
            Menu(name: "Jus Alpukat", type: .drink, price: 10000, imageName: "jusalpukat", stallName: ahza.name, stallLocation: ahza.location, stall: ahza, stallID: ahza.id.uuidString),
            Menu(name: "Salad", type: .fiber, price: 10000, imageName: "saladbuah", stallName: ahza.name, stallLocation: ahza.location, stall: ahza, stallID: ahza.id.uuidString),
            Menu(name: "Teh Tawar Panas", type: .drink, price: 3000, imageName: "esteh", stallName: ahza.name, stallLocation: ahza.location, stall: ahza, stallID: ahza.id.uuidString),
            Menu(name: "Indomeie Goreng/Kuah", type: .carb, price: 7000, imageName: "indomietelor", stallName: ahza.name, stallLocation: ahza.location, stall: ahza, stallID: ahza.id.uuidString),
            Menu(name: "Indomie Telor", type: .carb, price: 10000, imageName: "miedaging", stallName: ahza.name, stallLocation: ahza.location, stall: ahza, stallID: ahza.id.uuidString),
            Menu(name: "Jus Buah Naga", type: .drink, price: 10000, imageName: "jusnaga", stallName: ahza.name, stallLocation: ahza.location, stall: ahza, stallID: ahza.id.uuidString),
        ]
        
        let kasturi = Stall(
            name: "Kasturi",
            images: ["Kasturi"],
            rating: 4.9,
            location: "GOP 9",
            category: ["Cemilan", "Minuman", "Mie"],
            lowestPrice: 3000,
            highestPrice: 15000,
            whatsAppNumber: "6289516851555",
            menuImage: "Kasturi"
        )
        kasturi.menuList = [
            Menu(name: "Nasi Ayam Teriyaki", type: .complete, price: 13000, imageName: "nasiteriyaki", stallName: kasturi.name, stallLocation: kasturi.location, stall: kasturi, stallID: kasturi.id.uuidString),
            Menu(name: "Nasi Cumi Cabe Ijo", type: .complete, price: 14000, imageName: "cumiijo", stallName: kasturi.name, stallLocation: kasturi.location, stall: kasturi, stallID: kasturi.id.uuidString),
            Menu(name: "Kentang balado", type: .carb, price: 15000, imageName: "kentang", stallName: kasturi.name, stallLocation: kasturi.location, stall: kasturi, stallID: kasturi.id.uuidString),
            Menu(name: "Sayur Pokcoy", type: .fiber, price: 3000, imageName: "pokcoy", stallName: kasturi.name, stallLocation: kasturi.location, stall: kasturi, stallID: kasturi.id.uuidString),
            Menu(name: "Sayur Toge", type: .fiber, price: 3000, imageName: "toge", stallName: kasturi.name, stallLocation: kasturi.location, stall: kasturi, stallID: kasturi.id.uuidString),
            Menu(name: "Sayur Terong", type: .fiber, price: 5000, imageName: "tumiskacang", stallName: kasturi.name, stallLocation: kasturi.location, stall: kasturi, stallID: kasturi.id.uuidString),
            Menu(name: "Sayur Nangka", type: .fiber, price: 5000, imageName: "sayurnangka", stallName: kasturi.name, stallLocation: kasturi.location, stall: kasturi, stallID: kasturi.id.uuidString),
            Menu(name: "Sayur Krecek", type: .fiber, price: 5000, imageName: "krecek", stallName: kasturi.name, stallLocation: kasturi.location, stall: kasturi, stallID: kasturi.id.uuidString),
        ]
        
        let Kencana = Stall(
            name: "Dapur Kencana",
            images: ["kedai2nyonya"],
            rating: 4.9,
            location: "GOP 1",
            category: ["Cemilan", "Minuman", "Mie"],
            lowestPrice: 3000,
            highestPrice: 25000,
            whatsAppNumber: "6289516851555",
            menuImage: "Kasturi"
        )
        
        Kencana.menuList = [
            Menu(name: "Nasi Ayam/Ikan", type: .complete, price: 15000, imageName: "ayam", stallName: Kencana.name, stallLocation: Kencana.location, stall: Kencana, stallID: Kencana.id.uuidString),
            Menu(name: "Bakmie Ayam Pangsit", type: .complete, price: 20000, imageName: "miedaging", stallName: Kencana.name, stallLocation: Kencana.location, stall: Kencana, stallID: Kencana.id.uuidString),
            Menu(name: "Soto Betawi Ayam", type: .complete, price: 22000, imageName: "sop", stallName: Kencana.name, stallLocation: Kencana.location, stall: Kencana, stallID: Kencana.id.uuidString),
            Menu(name: "Lontong Sayur", type: .complete, price: 3000, imageName: "gado", stallName: Kencana.name, stallLocation: Kencana.location, stall: Kencana, stallID: Kencana.id.uuidString),
            Menu(name: "Bakso Sapi", type: .complete, price: 3000, imageName: "bakso", stallName: Kencana.name, stallLocation: Kencana.location, stall: Kencana, stallID: Kencana.id.uuidString),
            Menu(name: "Siomay", type: .carb, price: 15000, imageName: "siomay", stallName: Kencana.name, stallLocation: Kencana.location, stall: Kencana, stallID: Kencana.id.uuidString),
            Menu(name: "Nasi Goreng Spesial", type: .complete, price: 25000, imageName: "nasigorengtelor", stallName: ahza.name, stallLocation: Kencana.location, stall: Kencana, stallID: Kencana.id.uuidString),
            Menu(name: "Nasi Uduk Telur Balado", type: .complete, price: 20000, imageName: "telurbalado", stallName: Kencana.name, stallLocation:  Kencana.location, stall: Kencana, stallID: Kencana.id.uuidString),
            Menu(name: "Sandwich Ragout", type: .complete, price: 19000, imageName: "sandwich", stallName: Kencana.name, stallLocation: Kencana.location, stall: Kencana, stallID: Kencana.id.uuidString),
        ]

        let djempol = Stall(
            name: "Mama Djempol",
            images: ["mamadjempol"],
            rating: 4.9,
            location: "GOP 9",
            category: ["Cemilan", "Minuman", "Mie"],
            lowestPrice: 6000,
            highestPrice: 18000,
            whatsAppNumber: "6289516851555",
            menuImage: "Kasturi"
        )
        
        djempol.menuList = [
            Menu(name: "Nasi goreng", type: .complete, price: 15000, imageName: "nasigoreng", stallName: djempol.name, stallLocation: djempol.location, stall: djempol, stallID: djempol.id.uuidString),
            Menu(name: "Daging Ayam Pedas Manis", type: .protein, price: 6000, imageName: "ayam", stallName: djempol.name, stallLocation: djempol.location, stall: djempol, stallID: djempol.id.uuidString),
            Menu(name: "Tumis Kacang Panjang", type: .fiber, price: 6000, imageName: "tumiskacang", stallName: djempol.name, stallLocation: djempol.location, stall: djempol, stallID: djempol.id.uuidString),
            Menu(name: "Ikan Dori Goreng", type: .complete, price: 15000, imageName: "ikandori", stallName: djempol.name, stallLocation: djempol.location, stall: djempol, stallID: djempol.id.uuidString),
            Menu(name: "Tumis Capcay", type: .fiber, price: 6000, imageName: "capcay", stallName: djempol.name, stallLocation: djempol.location, stall: djempol, stallID: djempol.id.uuidString),
            Menu(name: "Paket Ikan Gurame", type: .fiber, price: 18000, imageName: "gurame", stallName: djempol.name, stallLocation: djempol.location, stall: djempol, stallID: djempol.id.uuidString)
        ]

        let mimin = Stall(
            name: "Dapur Mimin",
            images: ["dapurmimin"],
            rating: 4.9,
            location: "GOP 9",
            category: ["Cemilan", "Minuman", "Mie"],
            lowestPrice: 3000,
            highestPrice: 27000,
            whatsAppNumber: "6289516851555",
            menuImage: "Kasturi"
        )
        mimin.menuList = [
            Menu(name: "Gado-gado", type: .complete, price: 17000, imageName: "gado", stallName: mimin.name, stallLocation: mimin.location, stall: mimin, stallID: mimin.id.uuidString),
            Menu(name: "Gado-gado Lontong", type: .complete, price: 22000, imageName: "ketoprak", stallName: mimin.name, stallLocation: mimin.location, stall: mimin, stallID: mimin.id.uuidString),
            Menu(name: "Ketoprak", type: .carb, price: 19000, imageName: "gado", stallName: mimin.name, stallLocation: mimin.location, stall: mimin, stallID: mimin.id.uuidString),
            Menu(name: "Ketoprak Mie+Telur", type: .complete, price: 27000, imageName: "ketoprak", stallName: mimin.name, stallLocation: mimin.location, stall: mimin, stallID: mimin.id.uuidString),
            Menu(name: "Kuah", type: .complete, price: 3000, imageName: "sop", stallName: mimin.name, stallLocation: mimin.location, stall: mimin, stallID: mimin.id.uuidString),
            Menu(name: "Jamur Cabe Garam", type: .fiber, price: 5000, imageName: "cabegaram", stallName: mimin.name, stallLocation: mimin.location, stall: mimin, stallID: mimin.id.uuidString),
            Menu(name: "Nasi Kebuli/Briyani", type: .complete, price: 18000, imageName: "kebuli", stallName: mimin.name, stallLocation: mimin.location, stall: mimin, stallID: mimin.id.uuidString)
        ]

        let kapau = Stall(
            name: "Nasi Kapau Nusantara",
            images: ["nasikapaunusantara"],
            rating: 4.9,
            location: "GOP 6",
            category: ["Cemilan", "Minuman", "Mie"],
            lowestPrice: 4000,
            highestPrice: 10000,
            whatsAppNumber: "6289516851555",
            menuImage: "Kasturi"
        )
        kapau.menuList = [
            Menu(name: "Ayam Gulai", type: .complete, price: 20000, imageName: "sayurnangka", stallName: kapau.name, stallLocation: kapau.location, stall: kapau, stallID: kapau.id.uuidString),
            Menu(name: "Ayam Pop", type: .complete, price: 22000, imageName: "nasipadang", stallName: kapau.name, stallLocation: kapau.location, stall: kapau, stallID: kapau.id.uuidString),
            Menu(name: "Ayam Goreng", type: .carb, price: 19000, imageName: "ayam", stallName: kapau.name, stallLocation: kapau.location, stall: kapau, stallID: kapau.id.uuidString),
            Menu(name: "Rendang", type: .complete, price: 27000, imageName: "nasipadang", stallName: kapau.name, stallLocation: kapau.location, stall: kapau, stallID: kapau.id.uuidString),
            Menu(name: "Nasi Paket Gulai Otak", type: .complete, price: 3000, imageName: "otak", stallName: kapau.name, stallLocation: kapau.location, stall: kapau, stallID: kapau.id.uuidString),
            Menu(name: "Nasi Paket Dendeng Kering", type: .fiber, price: 5000, imageName: "nasipadang", stallName: kapau.name, stallLocation: kapau.location, stall: kapau, stallID: kapau.id.uuidString),
            Menu(name: "Nasi Paket Paru", type: .complete, price: 18000, imageName: "otak", stallName: kapau.name, stallLocation: kapau.location, stall: kapau, stallID: kapau.id.uuidString)
            
        ]
        
        let pais = Stall(
            name: "Warkop pais",
            images: ["warkoppais"],
            rating: 4.9,
            location: "GOP 6",
            category: ["Cemilan", "Minuman", "Mie"],
            lowestPrice: 8000,
            highestPrice: 12000,
            whatsAppNumber: "6289516851555",
            menuImage: "Kasturi"
        )
        pais.menuList = [
            Menu(name: "Lontong Sayur", type: .complete, price: 12000, imageName: "gado", stallName: pais.name, stallLocation: pais.location, stall: pais, stallID: pais.id.uuidString),
            Menu(name: "Nasi Uduk", type: .complete, price: 12000, imageName: "nasiuduk", stallName: kapau.name, stallLocation: kapau.location, stall: kapau, stallID: kapau.id.uuidString),
            Menu(name: "Nasi Goreng", type: .carb, price: 12000, imageName: "nasigorengtelor", stallName: kapau.name, stallLocation: kapau.location, stall: kapau, stallID: kapau.id.uuidString),
            Menu(name: "Indomie+Telur", type: .complete, price: 12000, imageName: "indomietelor", stallName: kapau.name, stallLocation: kapau.location, stall: kapau, stallID: kapau.id.uuidString),
            Menu(name: "Indomie Jumbo+Telur", type: .complete, price: 14000, imageName: "miedaging", stallName: kapau.name, stallLocation: kapau.location, stall: kapau, stallID: kapau.id.uuidString),
            Menu(name: "Jus jeruk", type: .drink, price: 8000, imageName: "jusjeruk", stallName: kapau.name, stallLocation: kapau.location, stall: kapau, stallID: kapau.id.uuidString),
            Menu(name: "Jus apel", type: .drink, price: 8000, imageName: "jusapel", stallName: kapau.name, stallLocation: kapau.location, stall: kapau, stallID: kapau.id.uuidString),
            Menu(name: "Jus Mangga", type: .drink, price: 8000, imageName: "jusmangga", stallName: pais.name, stallLocation: pais.location, stall: pais, stallID: pais.id.uuidString)
            
        ]
        
        let lading = Stall(
            name: "La Ding",
            images: ["lading"],
            rating: 4.9,
            location: "GOP 9",
            category: ["Cemilan", "Minuman", "Mie"],
            lowestPrice: 6000,
            highestPrice: 27000,
            whatsAppNumber: "6289516851555",
            menuImage: "Kasturi"
        )
        lading.menuList = [
            Menu(name: "Soto Mie Bogor", type: .complete, price: 20000, imageName: "sop", stallName: lading.name, stallLocation: lading.location, stall: lading, stallID: lading.id.uuidString),
            Menu(name: "Sop Daging", type: .complete, price: 27000, imageName: "sopdaging", stallName: lading.name, stallLocation: lading.location, stall: lading, stallID: lading.id.uuidString),
            Menu(name: "miedaging", type: .carb, price: 27000, imageName: "Kasturi", stallName: lading.name, stallLocation: lading.location, stall: lading, stallID: lading.id.uuidString),
            Menu(name: "Nasi Uduk", type: .complete, price: 17000, imageName: "nasiuduk", stallName: lading.name, stallLocation: lading.location, stall: lading, stallID: lading.id.uuidString),
            Menu(name: "Siomay", type: .complete, price: 6000, imageName: "siomay", stallName: lading.name, stallLocation: lading.location, stall: lading, stallID: lading.id.uuidString),
        ]
        
        let bakwan = Stall(
            name: "Ikan & Bakso Bakwan Malang Jos",
            images: ["bakwan"],
            rating: 4.9,
            location: "GOP 9",
            category: ["Cemilan", "Minuman", "Mie"],
            lowestPrice: 15000,
            highestPrice: 28000,
            whatsAppNumber: "6289516851555",
            menuImage: "Kasturi"
        )
        bakwan.menuList = [
            Menu(name: "Bakso", type: .complete, price: 20000, imageName: "Kasturi", stallName: bakwan.name, stallLocation: bakwan.location, stall: bakwan, stallID: bakwan.id.uuidString),
            Menu(name: "Bakso Rawit", type: .complete, price: 27000, imageName: "baksocabe", stallName: bakwan.name, stallLocation: bakwan.location, stall: bakwan, stallID: bakwan.id.uuidString),
            Menu(name: "Bakso Telur", type: .carb, price: 27000, imageName: "baksotelor", stallName: bakwan.name, stallLocation: bakwan.location, stall: bakwan, stallID: bakwan.id.uuidString),
            Menu(name: "Paket Komplit Bakso", type: .complete, price: 28000, imageName: "miedaging", stallName: bakwan.name, stallLocation: bakwan.location, stall: bakwan, stallID: bakwan.id.uuidString),
            Menu(name: "Paket Komplit Bakwan Malang", type: .complete, price: 15000, imageName: "baksourat", stallName: bakwan.name, stallLocation: bakwan.location, stall: bakwan, stallID: bakwan.id.uuidString),
        ]


        return [mustafa, ahza, kasturi, Kencana, djempol, mimin, kapau, lading, bakwan  ]
    }()
}
