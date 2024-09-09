//
//  Note.swift
//
//
//  Created by OQ on 2024/09/07.
//

import Foundation

final class Note: Model {
    static let schema = "notes"
    
    @Parent(key: "barcode_id")
    var product: Product
    
    @Parent(key: "user_id")
    var user: User

    @ID(key: .id)
    var id: Int
    
    @Field(key: "user_id")
    var userId: Int

    @Field(key: "barcode_id")
    var barcodeId: Int
    
    @Field(key: "body")
    var body: String

    @Field(key: "registerd")
    var registerd: Date
    
    init() { }

    init(id: Int, userId: Int, barcodeId: Int, body: String, registerd: Date) {
        self.id = id
        self.userId = userId
        self.barcodeId = barcodeId
        self.body = body
        self.registerd = registerd
    }
}
