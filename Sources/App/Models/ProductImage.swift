//
//  ProductImage.swift
//
//
//  Created by OQ on 2024/09/07.
//

import Foundation

final class ProductImage: Model {
    static let schema = "product_images"
    
    @Parent(key: "barcode_id")
    var product: Product
    
    @Parent(key: "note_id")
    var note: Note

    @ID(key: .id)
    var id: Int
    
    @Field(key: "barcode_id")
    var barcodeId: Int

    @Field(key: "note_id")
    var noteId: Int

    init() { }

    init(id: Int, barcodeId: Int, noteId: Int) {
        self.id = id
        self.barcodeId = barcodeId
        self.noteId = noteId
    }
}
