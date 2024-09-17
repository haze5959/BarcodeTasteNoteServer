//
//  NoteController.swift
//
//
//  Created by OQ on 2024/09/09.
//

import Vapor
import FluentKit

struct NoteController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let notes = routes.grouped("notes")
        notes.get(use: index)
        notes.post(use: create)

        notes.group(":id") { todo in
            todo.get(use: show)
            todo.put(use: update)
            todo.delete(use: delete)
        }
    }
    
    // MARK: create
    func create(req: Request) async throws -> Note {
        let todo = try req.content.decode(Note.self)
        try await todo.save(on: req.db)
        return todo
    }
    
    // MARK: read
    func index(req: Request) async throws -> [Note] {
        try await Note.query(on: req.db).all()
    }

    func show(req: Request) async throws -> Note {
        guard let todo = try await Note.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        return todo
    }
    
    // MARK: update
    func update(req: Request) async throws -> Note {
        guard let note = try await Note.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        let updatedTodo = try req.content.decode(Note.self)
        note.body = updatedTodo.body
        try await note.save(on: req.db)
        return note
    }
    
    // MARK: delete
    func delete(req: Request) async throws -> HTTPStatus {
        guard let note = try await Note.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await note.delete(on: req.db)
        return .ok
    }
}
