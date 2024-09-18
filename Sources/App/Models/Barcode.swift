//
//  Barcode.swift
//  
//
//  Created by OGyu kwon on 9/18/24.
//

import Vapor
import Fluent

final class Barcode: Model, @unchecked Sendable {
    static let schema = "barcodes"
    
    @Parent(key: "product_id")
    var product: Product
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "barcode_id")
    var barcodeId: String
    
    @Field(key: "product_id")
    var productId: UUID
    
    init() { }
    
    init(barcodeId: String, productId: UUID) {
        self.id = UUID()
        self.barcodeId = barcodeId
        self.productId = productId
    }
}

