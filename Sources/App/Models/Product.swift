//
//  Product.swift
//
//
//  Created by OQ on 2024/09/07.
//

import Vapor
import Fluent

final class Product: Model, Content, @unchecked Sendable {
    static let schema = "products"
    
    @Children(for: \.$product)
    var notes: [Note]
    
    @Children(for: \.$product)
    var favorites: [Favorite]
    
    @Children(for: \.$product)
    var images: [ProductImage]

    @ID(custom: "barcode_id")
    var id: UUID?
    
    @Field(key: "user_id")
    var userId: UUID

    @Field(key: "name")
    var name: String

    init() { }

    init(userId: UUID, name: String) {
        self.id = UUID()
        self.userId = userId
        self.name = name
    }
}
