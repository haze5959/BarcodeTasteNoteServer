import Vapor

func routes(_ app: Application) throws {
    app.get { req async in
        "It works!"
    }

    try app.register(collection: NoteController())
    try app.register(collection: ProductController())
    try app.register(collection: UserController())
}
