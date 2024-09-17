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
    
    @Parent(key: "barcode_id")
    var product: Product
    
    @Parent(key: "user_id")
    var user: User
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "barcode_id")
    var barcodeId: UUID
    
    @Field(key: "user_id")
    var userId: UUID
    
    init() { }
    
    init(barcodeId: UUID, userId: UUID) {
        self.id = UUID()
        self.barcodeId = barcodeId
        self.userId = userId
    }
}
