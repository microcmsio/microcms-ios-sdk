import XCTest
@testable import MicrocmsSDK

final class MicrocmsSDKTests: XCTestCase {
    func testBaseUrl() {
        let client = MicrocmsClient(
            serviceDomain: "test-service",
            apiKey: "test-api-key")
        XCTAssertEqual(client.baseUrl, "https://test-service.microcms.io/api/v1")
    }

    static var allTests = [
        ("testExample", testBaseUrl),
    ]
}
