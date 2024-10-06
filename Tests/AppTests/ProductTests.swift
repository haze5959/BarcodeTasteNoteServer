@testable import App
import XCTVapor

final class ProductTests: XCTestCase {
    var app: Application!
    private let testBarcodeId1 = "test_barcode_001"
    private let testBarcodeId2 = "test_barcode_002"
    
    override func setUp() async throws {
        self.app = try await Application.make(.testing)
        try await configure(app)
    }
    
    override func tearDown() async throws { 
        try await self.app.asyncShutdown()
        self.app = nil
    }
    
//    func testSequence() async throws {
//        // 기존 테스트 데이터 제거용
////        try await deleteUser(id: .init(uuidString: "4F7D9D34-37BD-4C1B-8DE8-6B19B2DCF506")!)
//        
//        try await createUser()
//        let user = try await showUser()
//        let updatedUser = try await updateNick(id: user.id!)
//        try await deleteUser(id: updatedUser.id!)
//    }
    
    func testShowProduct() async throws {
        try await self.app.test(.GET, "products?id=1234", afterResponse: { res async in
            XCTAssertEqual(res.status, .ok)
            XCTAssertEqual(res.body.string, "Hello, world!")
        })
    }
}

// MARK: Test Methods
//extension ProductTests {
//    func createUser() async throws {
//        let user = User(name: testNick1)
//        try await self.app.test(.POST, "users", beforeRequest: { req in
//            try req.content.encode(user)
//        }, afterResponse: { res async throws in
//            XCTAssertContent(ServerResponse<User>.self, res) { body in
//                self.app.logger.debug("\(body)")
//                XCTAssertTrue(body.result)
//                XCTAssertEqual(body.data?.name, user.name)
//            }
//        })
//    }
//    
//    func showUser() async throws -> User {
//        var result: User? = nil
//        try await self.app.test(.GET, "users", beforeRequest: { req in
//            try req.query.encode(["nick_name": testNick1])
//        }, afterResponse: { res async throws in
//            XCTAssertContent(ServerResponse<User>.self, res) { body in
//                self.app.logger.debug("\(body)")
//                XCTAssertTrue(body.result)
//                XCTAssertEqual(body.data?.name, testNick1)
//                result = body.data
//            }
//        })
//        
//        return result!
//    }
//    
//    func updateNick(id: UUID) async throws -> User {
//        var result: User? = nil
//        try await self.app.test(.PUT, "users/\(id)", beforeRequest: { req in
//            try req.content.encode(["nick_name": testNick2])
//        }, afterResponse: { res async throws in
//            XCTAssertContent(ServerResponse<User>.self, res) { body in
//                self.app.logger.debug("\(body)")
//                XCTAssertTrue(body.result)
//                XCTAssertEqual(body.data?.name, testNick2)
//                result = body.data
//            }
//        })
//        
//        return result!
//    }
//    
//    func deleteUser(id: UUID) async throws {
//        try await self.app.test(.DELETE, "users/\(id)", beforeRequest: { req in
//            try req.query.encode(["nick_name": testNick2])
//        }, afterResponse: { res async throws in
//            XCTAssertContent(ServerResponse<User>.self, res) { body in
//                self.app.logger.debug("\(body)")
//                XCTAssertTrue(body.result)
//            }
//        })
//    }
//}
