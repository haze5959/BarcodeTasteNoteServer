//
//  ProductImage.swift
//
//
//  Created by OQ on 2024/09/07.
//

import Vapor
import Fluent

final class ProductImage: Model, @unchecked Sendable {
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
    var noteId: UUID

    init() { }

    init(productId: UUID, noteId: UUID) {
        self.id = UUID()
        self.productId = productId
        self.noteId = noteId
    }
}
