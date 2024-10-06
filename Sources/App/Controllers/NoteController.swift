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
        notes.post(use: create)
        notes.get(use: paginate)
        
        notes.group(":id") { note in
            note.get(use: show)
            note.put(use: update)
            note.delete(use: delete)
        }
    }
    
    // MARK: create
    func create(req: Request) async throws -> ServerResponse<Note> {
        let noteInfo = try req.content.decode(NoteInfo.self)
        let note = Note(userId: noteInfo.user_id, productId: noteInfo.product_id, body: noteInfo.body)
        try await note.save(on: req.db)
        return .init(data: note)
    }
    
    // MARK: read
    func show(req: Request) async throws -> ServerResponse<Note> {
        guard let noteId: UUID = req.parameters.get("id") else {
            throw Abort(.badRequest)
        }
        
        guard let note = try await Note.find(noteId, on: req.db) else {
            throw Abort(.notFound)
        }
        return .init(data: note)
    }
    
    func paginate(req: Request) async throws -> ServerResponse<[Note]> {
        let queryParams = try req.query.decode(Pagination.self)
        var query = Note.query(on: req.db)
        if let searchProductId = queryParams.product_id {
            query = query.filter(\.$productId == searchProductId)
        }
        
        let notePage = try await query.paginate(.init(page: queryParams.page, per: queryParams.per))
        return .init(data: notePage.items)
    }
    
    // MARK: update
    func update(req: Request) async throws -> ServerResponse<Note> {
        guard let noteId: UUID = req.parameters.get("id") else {
            throw Abort(.badRequest)
        }
        
        guard let note = try await Note.find(noteId, on: req.db) else {
            throw Abort(.notFound)
        }
        let updatedInfo = try req.content.decode(NoteInfo.self)
        note.productId = updatedInfo.product_id
        note.body = updatedInfo.body
        try await note.save(on: req.db)
        return .init(data: note)
    }
    
    // MARK: delete
    func delete(req: Request) async throws -> ServerResponse<Note> {
        guard let note = try await Note.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await note.delete(on: req.db)
        return .init(data: nil)
    }
}

// MARK: Request Body
extension NoteController {
    struct NoteInfo: Content {
        let user_id: UUID
        let product_id: UUID
        let body: String
    }
    
    struct Pagination: Content {
        let page: Int
        let per: Int
        let product_id: UUID?
    }
}
