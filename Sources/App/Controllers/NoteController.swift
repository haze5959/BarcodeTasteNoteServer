//
//  NoteController.swift
//
//
//  Created by OQ on 2024/09/09.
//

import Vapor
import FluentKit

struct NoteController: RouteCollection {
    let authMiddleware: Auth0Middleware
    
    func boot(routes: RoutesBuilder) throws {
        let notes = routes.grouped("notes")
        let authenticated = notes.grouped(authMiddleware)
        authenticated.post(use: create)
        authenticated.group(":id") { note in
            note.put(use: update)
            note.delete(use: delete)
        }
        
        notes.get(use: paginate)
        notes.group(":id") { note in
            note.get(use: show)
        }
        
        notes.group("user/:id") { note in
            note.get(use: paginateByUserId)
        }
    }
    
    // MARK: create
    func create(req: Request) async throws -> ServerResponse<Note> {
        let token = try req.requireToken()
        let sub = token.sub.value
        guard let user = await User.getUser(sub: sub, db: req.db),
              let userId = user.id else {
            let error = ServerError(code: .emptyData, msg: "user does not exist")
            return .init(error: error)
        }
        
        let noteInfo = try req.content.decode(NoteInfo.self)
        let note = Note(userId: userId, productId: noteInfo.product_id, body: noteInfo.body)
        try await note.save(on: req.db)
        return .init(data: note)
    }
    
    // MARK: read
    func show(req: Request) async throws -> ServerResponse<NoteResponse> {
        guard let noteId: UUID = req.parameters.get("id") else {
            throw Abort(.badRequest)
        }
        
        guard let note = try await Note.find(noteId, on: req.db) else {
            throw Abort(.notFound)
        }
        
        guard let user = try await User.find(note.userId, on: req.db) else {
            throw Abort(.notFound)
        }
        
        return .init(data: .init(note: note, user: user))
    }
    
    func paginate(req: Request) async throws -> ServerResponse<[NoteResponse]> {
        let queryParams = try req.query.decode(Pagination.self)
        var query = Note.query(on: req.db)
            .join(User.self, on: \Note.$userId == \User.$id)
        if let searchProductId = queryParams.product_id {
            query = query.filter(\.$productId == searchProductId)
        }
        
        let result = try await query.paginate(.init(page: queryParams.page, per: queryParams.per))
        let data = result.items.map { NoteResponse(note: $0, user: try? $0.joined(User.self)) }
        return .init(data: data)
    }
    
    func paginateByUserId(req: Request) async throws -> ServerResponse<[NoteResponse]> {
        guard let userId: UUID = req.parameters.get("id") else {
            throw Abort(.badRequest)
        }
        
        guard let user = try await User.find(userId, on: req.db) else {
            throw Abort(.notFound)
        }
        
        let queryParams = try req.query.decode(Pagination.self)
        let result = try await Note.query(on: req.db)
            .filter(\.$userId == userId)
            .paginate(.init(page: queryParams.page, per: queryParams.per))
        
        let data = result.items.map { NoteResponse(note: $0, user: user) }
        return .init(data: data)
    }
    
    // MARK: update
    func update(req: Request) async throws -> ServerResponse<Note> {
        guard let noteId: UUID = req.parameters.get("id") else {
            throw Abort(.badRequest)
        }
        
        let token = try req.requireToken()
        let sub = token.sub.value
        guard let user = await User.getUser(sub: sub, db: req.db),
              let userId = user.id else {
            let error = ServerError(code: .emptyData, msg: "user does not exist")
            return .init(error: error)
        }
        
        guard let note = try await Note.find(noteId, on: req.db) else {
            throw Abort(.notFound)
        }
        
        guard note.userId == userId else {
            let error = ServerError(code: .authenticatedFail, msg: "User authentication failed.")
            return .init(error: error)
        }
        
        let updatedInfo = try req.content.decode(NoteInfo.self)
        note.productId = updatedInfo.product_id
        note.body = updatedInfo.body
        try await note.save(on: req.db)
        return .init(data: note)
    }
    
    // MARK: delete
    func delete(req: Request) async throws -> ServerResponse<Note> {
        let token = try req.requireToken()
        let sub = token.sub.value
        guard let user = await User.getUser(sub: sub, db: req.db),
              let userId = user.id else {
            let error = ServerError(code: .emptyData, msg: "user does not exist")
            return .init(error: error)
        }
        
        guard let note = try await Note.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        guard note.userId == userId else {
            let error = ServerError(code: .authenticatedFail, msg: "User authentication failed.")
            return .init(error: error)
        }
        
        try await note.delete(on: req.db)
        return .init(data: nil)
    }
}

// MARK: Request Body
extension NoteController {
    struct NoteInfo: Content {
        let product_id: UUID
        let body: String
    }
    
    struct Pagination: Content {
        let page: Int
        let per: Int
        let product_id: UUID?
    }
    
    struct NoteResponse: Content  {
        let note: Note
        let user: User?
    }
}
