//
//  User.swift
//
//
//  Created by OQ on 2024/09/07.
//

import Vapor
import Fluent

final class User: Model, Content, @unchecked Sendable {
    static let schema = "user"
    
    @Children(for: \.$user)
    var notes: [Note]
    
    @Children(for: \.$user)
    var favorites: [Favorite]
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "sub")
    var sub: String
    
    @Field(key: "nick_name")
    var name: String
    
    init() { }
    
    init(sub: String, name: String) {
        self.id = UUID()
        self.sub = sub
        self.name = name
    }
    
    static func getUser(sub: String, db: Database) async -> User? {
        guard let user = try? await User.query(on: db)
            .filter(\.$sub == sub)
            .first(),
              let userId = user.id else {
            return nil
        }
        
        return user
    }
}
