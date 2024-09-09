//
//  User.swift
//
//
//  Created by OQ on 2024/09/07.
//

import Foundation

final class User: Model {
    static let schema = "user"
    
    @Children(for: \.$note)
    var notes: [Note]
    
    @Children(for: \.$favorte)
    var favorites: [Favorite]

    @ID(key: .id)
    var id: Int

    @Field(key: "name")
    var name: String

    init() { }

    init(barcodeId: Int, name: String) {
        self.barcodeId = barcodeId
        self.name = name
    }
}
