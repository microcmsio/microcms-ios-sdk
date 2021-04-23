import XCTest
@testable import MicrocmsSDK

final class MicrocmsSDKTests: XCTestCase {
    func testBaseUrl() {
        let client = MicrocmsClient(
            serviceDomain: "test-service",
            apiKey: "test-api-key")
        XCTAssertEqual(client.baseUrl, "https://test-service.microcms.io/api/v1")
    }
    
    func testMakeRequest_list() {
        let client = MicrocmsClient(
            serviceDomain: "test-service",
            apiKey: "test-api-key")
        let request = client.makeRequest(endpoint: "endpoint",
                                         contentId: nil,
                                         params: nil)
        
        XCTAssertEqual(request?.url?.absoluteString,
                       "https://test-service.microcms.io/api/v1/endpoint")
    }
    
    func testMakeRequest_detail() {
        let client = MicrocmsClient(
            serviceDomain: "test-service",
            apiKey: "test-api-key")
        let request = client.makeRequest(endpoint: "endpoint",
                                         contentId: "contentId",
                                         params: nil)
        
        XCTAssertEqual(request?.url?.absoluteString,
                       "https://test-service.microcms.io/api/v1/endpoint/contentId")
    }
    
    func testMakeRequest_params() {
        let client = MicrocmsClient(
            serviceDomain: "test-service",
            apiKey: "test-api-key")
        
        let params: [MicrocmsParameter] = [
            .fields(["id", "publishedAt"]),
            .depth(2),
            .limit(2),
            .offset(1),
            .orders(["-updatedAt"]),
            .q("test"),
            .ids(["first_id", "second_id"]),
            .filters("createdAt[greater_than]2019-11"),
        ]
        let request = client.makeRequest(endpoint: "endpoint",
                                         contentId: nil,
                                         params: params)
        XCTAssertTrue(request?.url?.query?.contains("fields=id,publishedAt") == true)
        XCTAssertTrue(request?.url?.query?.contains("depth=2") == true)
        XCTAssertTrue(request?.url?.query?.contains("limit=2") == true)
        XCTAssertTrue(request?.url?.query?.contains("offset=1") == true)
        XCTAssertTrue(request?.url?.query?.contains("orders=-updatedAt") == true)
        XCTAssertTrue(request?.url?.query?.contains("orders=-updatedAt") == true)
        XCTAssertTrue(request?.url?.query?.contains("q=test") == true)
        XCTAssertTrue(request?.url?.query?.contains("ids=first_id,second_id") == true)
        XCTAssertTrue(request?.url?.query?.contains("filters=createdAt%5Bgreater_than%5D2019-11") == true)
    }
    
    func testMakeRequest_headers() {
        XCTContext.runActivity(named: "normal") { _ in
            let client = MicrocmsClient(
                serviceDomain: "test-service",
                apiKey: "test-api-key")
            
            let request = client.makeRequest(endpoint: "endpoint",
                                             contentId: nil,
                                             params: nil)
            
            XCTAssertEqual(request?.allHTTPHeaderFields, ["X-API-KEY": "test-api-key"])
        }
        
        XCTContext.runActivity(named: "with_draft") { _ in
            let client = MicrocmsClient(
                serviceDomain: "test-service",
                apiKey: "test-api-key",
                globalDraftKey: "test-global-draft-key")
            
            let request = client.makeRequest(endpoint: "endpoint",
                                             contentId: nil,
                                             params: nil)
            
            XCTAssertEqual(request?.allHTTPHeaderFields,
                           ["X-API-KEY": "test-api-key",
                            "X-GLOBAL-DRAFT-KEY": "test-global-draft-key"])
        }   
    }
    
    func testGet() {
        let client = MicrocmsClient(
            serviceDomain: "test-service",
            apiKey: "test-api-key")
        let task = client.get(endpoint: "test-endpoint",
                              contentId: nil,
                              params: nil) { _ in }
        XCTAssertNotNil(task)
    }

    static var allTests = [
        ("testExample", testBaseUrl),
    ]
}
