@testable import App
import XCTVapor

final class UserTests: XCTestCase {
    var app: Application!
    private let testNick1 = "임시_테스터001"
    private let testNick2 = "임시_테스터002"
    private let accessToken = "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6InZycFo3Z0I3VWlqQVpCVTVQUVl2byJ9.eyJpc3MiOiJodHRwczovL2Rldi0wZXkyemttZTJ6ZjZsY3p1LnVzLmF1dGgwLmNvbS8iLCJzdWIiOiI2aXhZTW56UXdDSGd6dXdxWEVLdmZNVHhHYVpmSHR5WEBjbGllbnRzIiwiYXVkIjoiaHR0cHM6Ly9kZXYtMGV5MnprbWUyemY2bGN6dS51cy5hdXRoMC5jb20vYXBpL3YyLyIsImlhdCI6MTcyODIyNzY4MCwiZXhwIjoxNzI4MzE0MDgwLCJndHkiOiJjbGllbnQtY3JlZGVudGlhbHMiLCJhenAiOiI2aXhZTW56UXdDSGd6dXdxWEVLdmZNVHhHYVpmSHR5WCJ9.MWi96z0yObGAaf44pkMVXgNwyWrivBEmQiceTyn8ZWhV9764TmwWNhPMf60z02SRNUZWhYiOYyLiBKAfDpThFtT-gCImfohDsPAt7WHeEKCZfu_JCP0_oqGyZOV0T2BMYYl2tskGmT9QjtdTdUoXCGvnxh8IevpYlQMVC4qMmllojct9szB3Cv9QNyXk_ZfNuRMXH9bPa3dX-3ulXNboBgVTvHHW6pKxGqKor-1nt2lehIs16VrEPEx567FhC7I62gBDNfz66gBleALmka-Fg6FDEnemHAJS0cCWReUpP_UDkgb_Y5htN0BXSk2BCo3zwykAuRVFeMRfpGT8AhNlJw"
    // sub: 6ixYMnzQwCHgzuwqXEKvfMTxGaZfHtyX@clients
    
    override func setUp() async throws {
        self.app = try await Application.make(.testing)
        self.app.logger.logLevel = .debug
        try await configure(app)
    }
    
    override func tearDown() async throws { 
        try await self.app.asyncShutdown()
        self.app = nil
    }
    
    func testSequence() async throws {
        // 기존 테스트 유저 데이터 제거용
//        try await deleteUser()
        
        try await createUser()
        let _ = try await showUser()
        let _ = try await updateNick(nick: testNick2)
        let _ = try await showUserByNick(nick: testNick2)
        try await deleteUser()
    }
}

// MARK: Test Methods
extension UserTests {
    func createUser() async throws {
        try await self.app.test(.POST, "users", beforeRequest: { req in
            req.headers.add(name: "authorization", value: "Bearer \(accessToken)")
            try req.content.encode(["nick_name": testNick1])
        }, afterResponse: { res async throws in
            XCTAssertContent(ServerResponse<User>.self, res) { body in
                self.app.logger.debug("\(body)")
                XCTAssertTrue(body.result)
                XCTAssertEqual(body.data?.name, testNick1)
            }
        })
    }
    
    func showUser() async throws -> User? {
        var result: User? = nil
        try await self.app.test(.GET, "users", beforeRequest: { req in
            req.headers.add(name: "authorization", value: "Bearer \(accessToken)")
        }, afterResponse: { res async throws in
            XCTAssertContent(ServerResponse<User>.self, res) { body in
                self.app.logger.debug("\(body)")
                XCTAssertTrue(body.result)
                XCTAssertEqual(body.data?.name, testNick1)
                result = body.data
            }
        })
        
        return result
    }
    
    func showUserByNick(nick: String) async throws -> User? {
        var result: User? = nil
        try await self.app.test(.GET, "users/search", beforeRequest: { req in
            try req.query.encode(["nick_name": nick])
        }, afterResponse: { res async throws in
            XCTAssertContent(ServerResponse<User>.self, res) { body in
                self.app.logger.debug("\(body)")
                XCTAssertTrue(body.result)
                XCTAssertEqual(body.data?.name, nick)
                result = body.data
            }
        })
        
        return result
    }
    
    func updateNick(nick: String) async throws -> User? {
        var result: User? = nil
        try await self.app.test(.PUT, "users", beforeRequest: { req in
            req.headers.add(name: "authorization", value: "Bearer \(accessToken)")
            try req.content.encode(["nick_name": nick])
        }, afterResponse: { res async throws in
            XCTAssertContent(ServerResponse<User>.self, res) { body in
                self.app.logger.debug("\(body)")
                XCTAssertTrue(body.result)
                XCTAssertEqual(body.data?.name, nick)
                result = body.data
            }
        })
        
        return result
    }
    
    func deleteUser() async throws {
        try await self.app.test(.DELETE, "users", beforeRequest: { req in
            req.headers.add(name: "authorization", value: "Bearer \(accessToken)")
        }, afterResponse: { res async throws in
            XCTAssertContent(ServerResponse<User>.self, res) { body in
                self.app.logger.debug("\(body)")
                XCTAssertTrue(body.result)
            }
        })
    }
}
