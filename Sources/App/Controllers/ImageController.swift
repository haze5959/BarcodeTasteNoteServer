//
//  ImageController.swift
//
//
//  Created by OQ on 2024/09/09.
//

import Vapor
import FluentKit

struct ImageController: RouteCollection {
    let authMiddleware: Auth0Middleware
    
    func boot(routes: RoutesBuilder) throws {
        let images = routes.grouped("images")
        let authenticated = images.grouped(authMiddleware)
        authenticated.post(use: create)
        
        authenticated.group(":id") { image in
            image.delete(use: delete)
        }
    }
    
    // MARK: create
    func create(req: Request) async throws -> ServerResponse<ProductImage> {
        let token = try req.requireToken()
        let sub = token.sub.value
        guard let user = await User.getUser(sub: sub, db: req.db),
              let userId = user.id else {
            let error = ServerError(code: .emptyData, msg: "user does not exist")
            return .init(error: error)
        }
        
        let imageInfo = try req.content.decode(ImageInfo.self)
        let productImage = ProductImage(productId: imageInfo.product_id, noteId: imageInfo.note_id, userId: userId)
        try await productImage.save(on: req.db)
        return .init(data: productImage)
    }
    
    // MARK: read
    
    // MARK: update
    
    // MARK: delete
    func delete(req: Request) async throws -> ServerResponse<ProductImage> {
        let token = try req.requireToken()
        let sub = token.sub.value
        guard let user = await User.getUser(sub: sub, db: req.db),
              let userId = user.id else {
            let error = ServerError(code: .emptyData, msg: "user does not exist")
            return .init(error: error)
        }
        
        guard let productImage = try await ProductImage.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        guard productImage.userId == userId else {
            let error = ServerError(code: .authenticatedFail, msg: "User authentication failed.")
            return .init(error: error)
        }
        
        try await productImage.delete(on: req.db)
        return .init(data: nil)
    }
}

// MARK: Request Body
extension ImageController {
    struct ImageInfo: Content {
        let product_id: UUID
        let note_id: UUID?
    }
}
