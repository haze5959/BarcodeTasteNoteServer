import Vapor
import Fluent
import FluentPostgresDriver

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    // register routes
    try routes(app)
    app.databases.use(
        .postgres(
            configuration: .init(
                hostname: "localhost",
                username: "ogyukwon",
                password: "134655",
                database: "app",
                tls: .disable
            )
        ),
        as: .psql
    )
}
