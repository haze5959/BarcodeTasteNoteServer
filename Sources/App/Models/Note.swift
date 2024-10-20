//
//  Note.swift
//
//
//  Created by OQ on 2024/09/07.
//

import Vapor
import Fluent

final class Note: Model, Content, @unchecked Sendable {
    static let schema = "notes"
    
    @Parent(key: "product_id")
    var product: Product
    
    @Parent(key: "user_id")
    var user: User
    
    @Children(for: \.$note)
    var images: [ProductImage]

    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "user_id")
    var userId: UUID

    @Field(key: "product_id")
    var productId: UUID
    
    @Field(key: "body")
    var body: String

    @Field(key: "registerd")
    var registerd: Date
    
    init() { }

    init(userId: UUID, productId: UUID, body: String) {
        self.id = UUID()
        self.userId = userId
        self.productId = productId
        self.body = body
        self.registerd = Date()
    }
}
