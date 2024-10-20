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
        try await req.db.transaction { database in
            try await note.save(on: req.db)
            let imageIds = noteInfo.image_ids
            for imageId in imageIds {
                if let image = try await ProductImage.find(imageId, on: req.db) {
                    image.noteId = note.id
                    try await image.update(on: req.db)
                }
            }
        }
        
        return .init(data: note)
    }
    
    // MARK: read
    func show(req: Request) async throws -> ServerResponse<NoteResponse> {
        guard let noteId: UUID = req.parameters.get("id") else {
            throw Abort(.badRequest)
        }
        
        guard let note = try await Note.query(on: req.db)
            .with(\.$product)
            .with(\.$user)
            .filter(\.$id == noteId)
            .first() else {
            throw Abort(.notFound)
        }
        
        let images = try await ProductImage.query(on: req.db)
            .filter(\.$noteId == note.id)
            .range(..<Constants.maxImageCount)
            .all()
        
        return .init(data: .init(note: note, product: note.product, user: note.user, images: images))
    }
    
    func paginate(req: Request) async throws -> ServerResponse<[NoteResponse]> {
        let queryParams = try req.query.decode(Pagination.self)
        var query = Note.query(on: req.db)
            .with(\.$product)
            .with(\.$user)
        if let searchProductId = queryParams.product_id {
            query = query.filter(\.$productId == searchProductId)
        }
        
        let result = try await query.paginate(.init(page: queryParams.page, per: queryParams.per))
        var data: [NoteResponse] = []
        for note in result.items {  // TODO: 튜닝 필요 - DB 조회 부하가 있음
            let limitedImages = try await note.$images.query(on: req.db)
                .range(..<Constants.maxImageCountForThumnnail)  // 최대 3개의 이미지 가져오기
                .all()
            let response = NoteResponse(note: note, product: note.product, user: note.user, images: limitedImages)
            data.append(response)
        }
        
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
        
        var data: [NoteResponse] = []
        for note in result.items {  // TODO: 튜닝 필요 - DB 조회 부하가 있음
            let limitedImages = try await note.$images.query(on: req.db)
                .range(..<Constants.maxImageCountForThumnnail)  // 최대 3개의 이미지 가져오기
                .all()
            let response = NoteResponse(note: note, product: note.product, user: note.user, images: limitedImages)
            data.append(response)
        }
        
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
        let image_ids: [UUID]
    }
    
    struct Pagination: Content {
        let page: Int
        let per: Int
        let product_id: UUID?
    }
}

// MARK: Response
extension NoteController {
    struct NoteResponse: Content  {
        let note: Note
        let product: Product
        let user: User?
        let images: [ProductImage]
    }
}
