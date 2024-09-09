//
//  Product.swift
//
//
//  Created by OQ on 2024/09/07.
//

import Foundation

final class Product: Model {
    static let schema = "products"
    
    @Children(for: \.$note)
    var notes: [Note]
    
    @Children(for: \.$favorte)
    var favorites: [Favorite]
    
    @Children(for: \.$productImage)
    var images: [ProductImage]

    @ID(key: .id)
    var id: Int
    
    @Field(key: "user_id")
    var userId: Int

    @Field(key: "nick_name")
    var nickName: String

    init() { }

    init(id: Int, nickName: String) {
        self.id = id
        self.userId = userId
        self.nickName = nickName
    }
}
