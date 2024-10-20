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
        let authenticated = products.grouped(authMiddleware)
        authenticated.post(use: create)
        
        products.get(use: paginate)
        products.group(":id") { product in
            product.get(use: show)
            product.delete(use: delete)
        }
        
        products.group("barcode/:id") { product in
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
            
            if let barcodeId = productInfo.barcode_id, let productId = product.id {
                let barcode = Barcode(barcodeId: barcodeId, productId: productId)
                try await barcode.save(on: req.db)
            }
        }
        
        return .init(data: product)
    }
    
    // MARK: read
    func show(req: Request) async throws -> ServerResponse<ProductDefail> {
        guard let productId: UUID = req.parameters.get("id") else {
            throw Abort(.badRequest)
        }
        
        guard let product = try await Product.find(productId, on: req.db) else {
            let error = ServerError(code: .emptyData, msg: "\(productId) product does not exist")
            return .init(error: error)
        }
        
        let images = try await product.$images.query(on: req.db)
            .range(..<Constants.maxImageCount)
            .all()
        let favoriteCount = try await product.$favorites.query(on: req.db).count()
        
        let data = ProductDefail(product: product, images: images, favoriteCount: favoriteCount)
        return .init(data: data)
    }
    
    func showByBarcode(req: Request) async throws -> ServerResponse<ProductDefail> {
        guard let barcodeId: String = req.parameters.get("id") else {
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
        
        let images = try await product.$images.query(on: req.db)
            .range(..<Constants.maxImageCount)
            .all()
        let favoriteCount = try await product.$favorites.query(on: req.db).count()
        
        let data = ProductDefail(product: product, images: images, favoriteCount: favoriteCount)
        return .init(data: data)
    }
    
    func paginate(req: Request) async throws -> ServerResponse<[ProductDefail]> {
        let queryParams = try req.query.decode(Pagination.self)
        var query = Product.query(on: req.db)
        if let searchName = queryParams.name {
            query = query.filter(\.$name ~~ searchName)
        }
        
        let productPage = try await query.paginate(.init(page: queryParams.page, per: queryParams.per))
        var data: [ProductDefail] = []
        for product in productPage.items {  // TODO: 튜닝 필요 - DB 조회 부하가 있음
            let limitedImages = try await product.$images.query(on: req.db)
                .range(..<Constants.maxImageCountForThumnnail)  // 최대 3개의 이미지 가져오기
                .all()
            let detail = ProductDefail(product: product, images: limitedImages, favoriteCount: nil)
            data.append(detail)
        }

        return .init(data: data)
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
        let barcode_id: String?
    }
    
    struct Pagination: Content {
        let page: Int
        let per: Int
        let name: String?
    }
}

// MARK: Response
extension ProductController {
    struct ProductDefail: Content {
        let product: Product
        let images: [ProductImage]
        let favoriteCount: Int?
    }
}
