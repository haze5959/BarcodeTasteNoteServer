//
//  ProductImage.swift
//
//
//  Created by OQ on 2024/09/07.
//

import Vapor
import Fluent

final class ProductImage: Model, Content, @unchecked Sendable {
    static let schema = "product_images"
    
    @Parent(key: "product_id")
    var product: Product
    
    @Parent(key: "note_id")
    var note: Note

    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "product_id")
    var productId: UUID

    @Field(key: "note_id")
    var noteId: UUID?
    
    @Field(key: "user_id")
    var userId: UUID

    init() { }

    init(productId: UUID, noteId: UUID?, userId: UUID) {
        self.id = UUID()
        self.productId = productId
        self.noteId = noteId
        self.userId = userId
    }
}
