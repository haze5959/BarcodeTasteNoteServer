//
//  Favorite.swift
//
//
//  Created by OQ on 2024/09/07.
//

import Foundation

final class Favorite: Model {
    static let schema = "favorites"
    
    @Parent(key: "barcode_id")
    var product: Product
    
    @Parent(key: "user_id")
    var user: User
    
    @ID(key: .id)
    var id: UUID
    
    @Field(key: "barcode_id")
    var barcodeId: Int
    
    @Field(key: "user_id")
    var userId: Int
    
    init() { }
    
    init(barcodeId: Int, userId: Int) {
        self.id = UUID()
        self.barcodeId = barcodeId
        self.userId = userId
    }
}
