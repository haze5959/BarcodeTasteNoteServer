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
    
    @Parent(key: "barcode_id")
    var product: Product
    
    @Parent(key: "user_id")
    var user: User

    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "user_id")
    var userId: UUID

    @Field(key: "barcode_id")
    var barcodeId: UUID
    
    @Field(key: "body")
    var body: String

    @Field(key: "registerd")
    var registerd: Date
    
    init() { }

    init(userId: UUID, barcodeId: UUID, body: String, registerd: Date) {
        self.id = UUID()
        self.userId = userId
        self.barcodeId = barcodeId
        self.body = body
        self.registerd = registerd
    }
}

struct NoteContent: Content {
    let id: UUID
    let userId: UUID
    let barcodeId: UUID
    let body: String
    let registerd: Date
}
