//
//  ProductController.swift
//
//
//  Created by OQ on 2024/09/09.
//

import Vapor
import FluentKit

struct ProductController: RouteCollection {
    let authMiddleware: Auth0Middleware
    
    func boot(routes: RoutesBuilder) throws {
        let products = routes.grouped("products")
        products.post(use: create)
        products.get(use: paginate)
        
        products.group(":id") { product in
            product.get(use: show)
            product.delete(use: delete)
        }
        
        products.group("barcode/:barcode_id") { product in
            product.get(use: showByBarcode)
        }
    }
    
    // MARK: create
    func create(req: Request) async throws -> ServerResponse<Product> {
        let productInfo = try req.content.decode(ProductInfo.self)
        guard let type = ProductType(rawValue: productInfo.type) else {
            throw Abort(.badRequest)
        }
        
        let product = Product(name: productInfo.name, type: type)
        try await req.db.transaction { database in
            try await product.save(on: req.db)
            
            if let barcodeId = productInfo.barcodeId, let productId = product.id {
                let barcode = Barcode(barcodeId: barcodeId, productId: productId)
                try await barcode.save(on: req.db)
            }
        }
        
        return .init(data: product)
    }
    
    // MARK: read
    func show(req: Request) async throws -> ServerResponse<Product> {
        guard let productId: UUID = req.parameters.get("id") else {
            throw Abort(.badRequest)
        }
        
        guard let product = try await Product.find(productId, on: req.db) else {
            let error = ServerError(code: .emptyData, msg: "\(productId) product does not exist")
            return .init(error: error)
        }
        return .init(data: product)
    }
    
    func showByBarcode(req: Request) async throws -> ServerResponse<Product> {
        guard let barcodeId: String = req.parameters.get("barcode_id") else {
            throw Abort(.badRequest)
        }
        
        guard let barcode = try? await Barcode.query(on: req.db)
            .filter(\.$barcodeId == barcodeId)
            .first() else {
            let error = ServerError(code: .emptyData, msg: "\(barcodeId) barcode_id does not exist")
            return .init(error: error)
        }
        
        guard let product = try await Product.find(barcode.productId, on: req.db) else {
            let error = ServerError(code: .emptyData, msg: "\(barcode.productId) product does not exist")
            return .init(error: error)
        }
        return .init(data: product)
    }
    
    func paginate(req: Request) async throws -> ServerResponse<[Product]> {
        let queryParams = try req.query.decode(Pagination.self)
        var query = Product.query(on: req.db)
        if let searchName = queryParams.name {
            query = query.filter(\.$name ~~ searchName)
        }
        
        let productPage = try await query.paginate(.init(page: queryParams.page, per: queryParams.per))
        return .init(data: productPage.items)
    }
    
    // MARK: update
    
    // MARK: delete
    func delete(req: Request) async throws -> ServerResponse<Product> {
        guard let product = try await Product.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await product.delete(on: req.db)
        return .init(data: nil)
    }
}

// MARK: Request Body
extension ProductController {
    struct ProductInfo: Content {
        let name: String
        let type: Int
        let barcodeId: String?
    }
    
    struct Pagination: Content {
        let page: Int
        let per: Int
        let name: String?
    }
}
