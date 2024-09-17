//
//  ProductController.swift
//
//
//  Created by OQ on 2024/09/09.
//

import Vapor
import FluentKit

struct ProductController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let users = routes.grouped("product")
        users.get(use: index)
        users.post(use: create)

        users.group(":id") { product in
            product.get(use: show)
            product.put(use: update)
            product.delete(use: delete)
        }
    }
    
    // MARK: create
    func create(req: Request) async throws -> Product {
        let product = try req.content.decode(Product.self)
        try await product.save(on: req.db)
        return product
    }
    
    // MARK: read
    func index(req: Request) async throws -> [Product] {
        try await Product.query(on: req.db).all()
    }
    
    func show(req: Request) async throws -> Product {
        guard let product = try await Product.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        return product
    }
    
    // MARK: update
    func update(req: Request) async throws -> Product {
        guard let product = try await Product.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        let updatedProduct = try req.content.decode(Product.self)
        product.name = updatedProduct.name
        try await product.save(on: req.db)
        return product
    }
    
    // MARK: delete
    func delete(req: Request) async throws -> HTTPStatus {
        guard let product = try await Product.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await product.delete(on: req.db)
        return .ok
    }
}
