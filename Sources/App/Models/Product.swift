//
//  Product.swift
//
//
//  Created by OQ on 2024/09/07.
//

import Vapor
import Fluent

enum ProductType: Int {
    case wine = 0
    case beer = 1
    case whisky = 2
    case sake = 3
    case soju = 4
    case nonAlcoholic = 5
    case etc = 99
}

final class Product: Model, Content, @unchecked Sendable {
    static let schema = "products"
    
    @Children(for: \.$product)
    var barcodes: [Barcode]
    
    @Children(for: \.$product)
    var notes: [Note]
    
    @Children(for: \.$product)
    var favorites: [Favorite]
    
    @Children(for: \.$product)
    var images: [ProductImage]
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "type")
    var type: Int
    
    init() { }
    
    init(name: String, type: ProductType) {
        self.id = UUID()
        self.name = name
        self.type = type.rawValue
    }
}
