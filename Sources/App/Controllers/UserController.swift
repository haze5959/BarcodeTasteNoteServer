//
//  UserController.swift
//
//
//  Created by OQ on 2024/09/09.
//

import Vapor
import FluentKit

struct UserController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let users = routes.grouped("users")
        users.post(use: create)
        users.get(use: showByNickName)
        
        users.group(":id") { user in
            user.get(use: show)
            user.put(use: updateNickName)
            user.delete(use: delete)
        }
    }
    
    // MARK: create
    func create(req: Request) async throws -> ServerResponse<User> {
        let user = try req.content.decode(User.self)
        let count = try await User.query(on: req.db)
            .filter(\.$name == user.name)
            .count()
        
        guard count == 0 else {
            let error = ServerError(code: .nickNameAlreadyExist, msg: "\(user.name) user already exist")
            return .init(error: error)
        }
        
        try await user.create(on: req.db)
        return .init(data: user)
    }
    
    // MARK: read
    func show(req: Request) async throws -> ServerResponse<User> {
        guard let userId: UUID = req.parameters.get("id") else {
            throw Abort(.badRequest)
        }
        
        guard let user = try await User.find(userId, on: req.db) else {
            let error = ServerError(code: .emptyData, msg: "\(userId) user does not exist")
            return .init(error: error)
        }
        return .init(data: user)
    }
    
    func showByNickName(req: Request) async throws -> ServerResponse<User> {
        let queryParams = try req.query.decode(NickName.self)
        
        guard let user = try? await User.query(on: req.db)
            .filter(\.$name == queryParams.nick_name)
            .first() else {
            let error = ServerError(code: .emptyData, msg: "\(queryParams.nick_name) user does not exist")
            return .init(error: error)
        }
        return .init(data: user)
    }
    
    // MARK: update
    func updateNickName(req: Request) async throws -> ServerResponse<User> {
        let reqBody = try req.content.decode(NickName.self)
        let count = try await User.query(on: req.db)
            .filter(\.$name == reqBody.nick_name)
            .count()
        
        guard count == 0 else {
            let error = ServerError(code: .nickNameAlreadyExist, msg: "\(reqBody.nick_name) user already exist")
            return .init(error: error)
        }
        
        guard let userId: UUID = req.parameters.get("id") else {
            throw Abort(.badRequest)
        }
        
        guard let user = try await User.find(userId, on: req.db) else {
            let error = ServerError(code: .emptyData, msg: "\(userId) user does not exist")
            return .init(error: error)
        }
        
        user.name = reqBody.nick_name
        try await user.update(on: req.db)
        return .init(data: user)
    }
    
    // MARK: delete
    func delete(req: Request) async throws -> ServerResponse<User> {
        guard let userId: UUID = req.parameters.get("id") else {
            throw Abort(.badRequest)
        }
        
        guard let user = try await User.find(userId, on: req.db) else {
            let error = ServerError(code: .emptyData, msg: "\(userId) user does not exist")
            return .init(error: error)
        }
        
        try await user.delete(on: req.db)
        return .init(data: nil)
    }
}

// MARK: Request Body
extension UserController {
    struct NickName: Content {
        let nick_name: String
    }
}
