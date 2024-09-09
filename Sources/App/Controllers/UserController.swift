//
//  UserController.swift
//
//
//  Created by OQ on 2024/09/09.
//

import Vapor

struct UserController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let users = routes.grouped("users")
        users.post(use: create)
        
        users.group(":id") { user in
            user.get(use: show)
            user.put(use: update)
            user.delete(use: delete)
        }
    }
    
    func create(req: Request) async throws -> User {
        let user = try req.content.decode(User.self)
        try await user.save(on: req.db)
        return user
    }
    
    func show(req: Request) async throws -> User {
        guard let user = try await User.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        return user
    }
    
    func update(req: Request) async throws -> User {
        guard let user = try await User.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        let updatedUser = try req.content.decode(User.self)
        user.name = updatedUser.name
        try await user.save(on: req.db)
        return user
    }
    
    func delete(req: Request) async throws -> HTTPStatus {
        guard let user = try await User.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await user.delete(on: req.db)
        return .ok
    }
}
