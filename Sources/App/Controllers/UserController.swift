//
//  UserController.swift
//
//
//  Created by OQ on 2024/09/09.
//

import Vapor
import FluentKit

struct UserController: RouteCollection {
    let authMiddleware: Auth0Middleware
    
    func boot(routes: RoutesBuilder) throws {
        let users = routes.grouped("users")
        let authenticated = users.grouped(authMiddleware)
        authenticated.post(use: create)
        authenticated.get(use: show)
        authenticated.put(use: updateNickName)
        authenticated.delete(use: delete)

        users.group("search") { user in
            user.get(use: showByNickName)
        }
    }
    
    // MARK: create
    func create(req: Request) async throws -> ServerResponse<User> {
        let token = try req.requireToken()
        let sub = token.sub.value
        
        let reqBody = try req.content.decode(NickName.self)
        let count = try await User.query(on: req.db)
            .filter(\.$name == reqBody.nick_name)
            .count()
        
        guard count == 0 else {
            let error = ServerError(code: .nickNameAlreadyExist, msg: "\(reqBody.nick_name) user already exist")
            return .init(error: error)
        }
        
        let user = User(sub: sub, name: reqBody.nick_name)
        try await user.create(on: req.db)
        return .init(data: user)
    }
    
    // MARK: read
    func show(req: Request) async throws -> ServerResponse<User> {
        let token = try req.requireToken()
        let sub = token.sub.value

        guard let user = await User.getUser(sub: sub, db: req.db) else {
            let error = ServerError(code: .emptyData, msg: "user does not exist")
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
        
        let token = try req.requireToken()
        let sub = token.sub.value

        guard let user = await User.getUser(sub: sub, db: req.db) else {
            let error = ServerError(code: .emptyData, msg: "user does not exist")
            return .init(error: error)
        }
        
        user.name = reqBody.nick_name
        try await user.update(on: req.db)
        return .init(data: user)
    }
    
    // MARK: delete
    func delete(req: Request) async throws -> ServerResponse<User> {
        let token = try req.requireToken()
        let sub = token.sub.value

        guard let user = await User.getUser(sub: sub, db: req.db) else {
            let error = ServerError(code: .emptyData, msg: "user does not exist")
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
