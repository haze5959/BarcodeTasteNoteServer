import Vapor
import Fluent
import FluentPostgresDriver

// configures your application
public func configure(_ app: Application) async throws {
    // .env 파일 경로 설정
    let envPath = "/Users/ogyukwon/Documents/Projects/BarcodeTasteNoteServer/.env"
    if let envVars = try? String(contentsOfFile: envPath) {
        envVars.split(separator: "\n").forEach { line in
            let keyValue = line.split(separator: "=", maxSplits: 1)
            guard keyValue.count == 2 else { return }
            let key = String(keyValue[0]).trimmingCharacters(in: .whitespaces)
            let value = String(keyValue[1]).trimmingCharacters(in: .whitespaces)
            setenv(key, value, 1)  // 환경 변수 설정
        }
    }
    
    guard let host = Environment.get("POSTGRES_HOST"),
          let user = Environment.get("POSTGRES_USER"),
          let pw = Environment.get("POSTGRES_PW"),
          let db = Environment.get("POSTGRES_DB") else {
        throw Abort(.custom(code: 9999, reasonPhrase: ".env Variables ERROR!!"))
    }
    
    try routes(app)
    app.databases.use(
        .postgres(
            configuration: .init(
                hostname: host,
                username: user,
                password: pw,
                database: db,
                tls: .disable
            )
        ),
        as: .psql
    )
}
