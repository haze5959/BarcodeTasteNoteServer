import Vapor
import JWTKit

func routes(_ app: Application) throws {
    app.get { req async in
        "It works!"
    }
    
    let auth0 = try getAuth0(app: app)
    let auth0Middleware = Auth0Middleware(
        auth0: auth0,
        requiresAuthentication: true
    )

    try app.register(collection: NoteController(authMiddleware: auth0Middleware))
    try app.register(collection: ProductController(authMiddleware: auth0Middleware))
    try app.register(collection: UserController(authMiddleware: auth0Middleware))
    try app.register(collection: ImageController(authMiddleware: auth0Middleware))
}

private func getAuth0(app: Application) throws -> Auth0 {
    let auth0Audience = "https://dev-0ey2zkme2zf6lczu.us.auth0.com/api/v2/"
    let auth0Issuer = "https://dev-0ey2zkme2zf6lczu.us.auth0.com/"
    let certificate = try String(contentsOfFile: "/Users/ogyukwon/Documents/Projects/BarcodeTasteNoteServer/certificate.pem")
    let key = try RSAKey.certificate(pem: certificate)
    

    let auth0 = Auth0(
        client: app.http.client.shared,
        issuer: auth0Issuer,
        audience: auth0Audience,
        signer: .rs256(key: key)
    )
    
    return auth0
}
