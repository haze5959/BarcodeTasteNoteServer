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
    guard let auth0Audience = Environment.get("AUTH0_AUDIENCE"),
          let auth0Issuer = Environment.get("AUTH0_ISSUER"),
          let certPath = Environment.get("AUTH0_CERT_PATH") else {
        throw Abort(.custom(code: 9999, reasonPhrase: ".env Variables ERROR!!"))
    }
    
    let certificate = try String(contentsOfFile: certPath)
    let key = try RSAKey.certificate(pem: certificate)

    let auth0 = Auth0(
        client: app.http.client.shared,
        issuer: auth0Issuer,
        audience: auth0Audience,
        signer: .rs256(key: key)
    )
    
    return auth0
}
