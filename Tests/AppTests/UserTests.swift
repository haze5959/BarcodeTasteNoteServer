@testable import App
import XCTVapor

final class UserTests: XCTestCase {
    var app: Application!
    private let testNick1 = "임시_테스터001"
    private let testNick2 = "임시_테스터002"
    
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
//        try await deleteUser(id: .init(uuidString: "4F7D9D34-37BD-4C1B-8DE8-6B19B2DCF506")!)
        
        try await createUser()
        let user = try await showUser()
        let updatedUser = try await updateNick(id: user.id!)
        try await deleteUser(id: updatedUser.id!)
    }
}

// MARK: Test Methods
extension UserTests {
    func createUser() async throws {
        let user = User(name: testNick1)
        try await self.app.test(.POST, "users", beforeRequest: { req in
            try req.content.encode(user)
        }, afterResponse: { res async throws in
            XCTAssertContent(ServerResponse<User>.self, res) { body in
                self.app.logger.debug("\(body)")
                XCTAssertTrue(body.result)
                XCTAssertEqual(body.data?.name, user.name)
            }
        })
    }
    
    func showUser() async throws -> User {
        var result: User? = nil
        try await self.app.test(.GET, "users", beforeRequest: { req in
            try req.query.encode(["nick_name": testNick1])
        }, afterResponse: { res async throws in
            XCTAssertContent(ServerResponse<User>.self, res) { body in
                self.app.logger.debug("\(body)")
                XCTAssertTrue(body.result)
                XCTAssertEqual(body.data?.name, testNick1)
                result = body.data
            }
        })
        
        return result!
    }
    
    func updateNick(id: UUID) async throws -> User {
        var result: User? = nil
        try await self.app.test(.PUT, "users/\(id)", beforeRequest: { req in
            try req.content.encode(["nick_name": testNick2])
        }, afterResponse: { res async throws in
            XCTAssertContent(ServerResponse<User>.self, res) { body in
                self.app.logger.debug("\(body)")
                XCTAssertTrue(body.result)
                XCTAssertEqual(body.data?.name, testNick2)
                result = body.data
            }
        })
        
        return result!
    }
    
    func deleteUser(id: UUID) async throws {
        try await self.app.test(.DELETE, "users/\(id)", beforeRequest: { req in
            try req.query.encode(["nick_name": testNick2])
        }, afterResponse: { res async throws in
            XCTAssertContent(ServerResponse<User>.self, res) { body in
                self.app.logger.debug("\(body)")
                XCTAssertTrue(body.result)
            }
        })
    }
}
