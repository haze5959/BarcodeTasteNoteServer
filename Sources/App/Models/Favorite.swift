//
//  Favorite.swift
//
//
//  Created by OQ on 2024/09/07.
//

import Vapor
import Fluent

final class Favorite: Model, @unchecked Sendable {
    static let schema = "favorites"
    
    @Parent(key: "product_id")
    var product: Product
    
    @Parent(key: "user_id")
    var user: User
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "product_id")
    var productId: UUID
    
    @Field(key: "user_id")
    var userId: UUID
    
    init() { }
    
    init(productId: UUID, userId: UUID) {
        self.id = UUID()
        self.productId = productId
        self.userId = userId
    }
}
