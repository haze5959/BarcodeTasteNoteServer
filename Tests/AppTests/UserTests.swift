@testable import App
import XCTVapor

final class UserTests: XCTestCase {
    var app: Application!
    
    override func setUp() async throws {
        self.app = try await Application.make(.testing)
        try await configure(app)
    }
    
    override func tearDown() async throws { 
        try await self.app.asyncShutdown()
        self.app = nil
    }
    
    func testShowUser() async throws {
        let nickName = "임시_테스터001"
        try await self.app.test(.GET, "users", beforeRequest: { req in
            try req.query.encode(["nick_name": nickName])
        }, afterResponse: { res async throws in
            XCTAssertContent(ServerResponse<User>.self, res) { body in
                XCTAssertEqual(body.result, true)
                XCTAssertEqual(body.data?.name, nickName)
            }
        })
    }
    
    func testCreateUser() async throws {
        let user = User(name: "임시_테스터001")
        try await self.app.test(.POST, "users", beforeRequest: { req in
            try req.content.encode(user)
        }, afterResponse: { res async throws in
            XCTAssertContent(ServerResponse<User>.self, res) { body in
                XCTAssertEqual(body.result, true)
                XCTAssertEqual(body.data?.name, user.name)
            }
        })
    }
}
