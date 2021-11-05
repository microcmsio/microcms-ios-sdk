import XCTest
@testable import MicrocmsSDK

final class MicrocmsSDKTests: XCTestCase {
    func testExample() {
        XCTAssertEqual("microcms", "microcms")
    }
    
    func testBaseUrl() {
        let client = MicrocmsClient(
            serviceDomain: "test-service",
            apiKey: "test-api-key")
        XCTAssertEqual(client.baseUrl, "https://test-service.microcms.io/api/v1")
    }
    
    func testMakeGetRequest_list() {
        let client = MicrocmsClient(
            serviceDomain: "test-service",
            apiKey: "test-api-key")
        let request = client.makeRequest(endpoint: "endpoint",
                                         contentId: nil,
                                         params: nil)
        
        XCTAssertEqual(request?.url?.absoluteString,
                       "https://test-service.microcms.io/api/v1/endpoint")
    }
    
    func testMakeGetRequest_detail() {
        let client = MicrocmsClient(
            serviceDomain: "test-service",
            apiKey: "test-api-key")
        let request = client.makeRequest(endpoint: "endpoint",
                                         contentId: "contentId",
                                         params: nil)
        
        XCTAssertEqual(request?.url?.absoluteString,
                       "https://test-service.microcms.io/api/v1/endpoint/contentId")
    }
    
    func testMakeGetRequest_params() {
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
    
    func testMakeGetRequest_headers() {
        let client = MicrocmsClient(
            serviceDomain: "test-service",
            apiKey: "test-api-key")
        
        let request = client.makeRequest(endpoint: "endpoint",
                                         contentId: nil,
                                         params: nil)
        
        XCTAssertEqual(request?.allHTTPHeaderFields, ["X-MICROCMS-API-KEY": "test-api-key"])
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
    
    func testMakeWriteRequest_post() {
        let client = MicrocmsClient(
            serviceDomain: "test-service",
            apiKey: "test-api-key")
        let params = ["title": "test-title"]
        let request = client.makeWriteRequest(method: .POST,
                                              endpoint: "test-endpoint",
                                              contentId: nil,
                                              params: params)
        XCTAssertEqual(request?.url?.absoluteString, "https://test-service.microcms.io/api/v1/test-endpoint")
        XCTAssertEqual(request?.httpMethod, "POST")
        XCTAssertEqual(request?.allHTTPHeaderFields, ["X-MICROCMS-API-KEY": "test-api-key",
                                                      "Content-Type": "application/json"])
        
        let expectedData = try! JSONSerialization.data(
            withJSONObject: params,
            options: .prettyPrinted)
        XCTAssertEqual(request?.httpBody, expectedData)
    }
    
    func testMakeWriteRequest_put() {
        let client = MicrocmsClient(
            serviceDomain: "test-service",
            apiKey: "test-api-key")
        let params = ["title": "test-title"]
        let request = client.makeWriteRequest(method: .PUT,
                                              endpoint: "test-endpoint",
                                              contentId: "test-contentId",
                                              params: params)
        XCTAssertEqual(request?.url?.absoluteString, "https://test-service.microcms.io/api/v1/test-endpoint/test-contentId")
        XCTAssertEqual(request?.httpMethod, "PUT")
        XCTAssertEqual(request?.allHTTPHeaderFields, ["X-MICROCMS-API-KEY": "test-api-key",
                                                      "Content-Type": "application/json"])
        
        let expectedData = try! JSONSerialization.data(
            withJSONObject: params,
            options: .prettyPrinted)
        XCTAssertEqual(request?.httpBody, expectedData)
    }
    
    func testMakeWriteRequest_patch() {
        let client = MicrocmsClient(
            serviceDomain: "test-service",
            apiKey: "test-api-key")
        let params = ["title": "test-title"]
        let request = client.makeWriteRequest(method: .PATCH,
                                              endpoint: "test-endpoint",
                                              contentId: "test-contentId",
                                              params: params)
        XCTAssertEqual(request?.url?.absoluteString, "https://test-service.microcms.io/api/v1/test-endpoint/test-contentId")
        XCTAssertEqual(request?.httpMethod, "PATCH")
        XCTAssertEqual(request?.allHTTPHeaderFields, ["X-MICROCMS-API-KEY": "test-api-key",
                                                      "Content-Type": "application/json"])
        
        let expectedData = try! JSONSerialization.data(
            withJSONObject: params,
            options: .prettyPrinted)
        XCTAssertEqual(request?.httpBody, expectedData)
    }
    
    func testMakeWriteRequest_delete() {
        let client = MicrocmsClient(
            serviceDomain: "test-service",
            apiKey: "test-api-key")
        let request = client.makeWriteRequest(method: .DELETE,
                                              endpoint: "test-endpoint",
                                              contentId: "test-contentId",
                                              params: nil)
        XCTAssertEqual(request?.url?.absoluteString, "https://test-service.microcms.io/api/v1/test-endpoint/test-contentId")
        XCTAssertEqual(request?.httpMethod, "DELETE")
        XCTAssertEqual(request?.allHTTPHeaderFields, ["X-MICROCMS-API-KEY": "test-api-key",
                                                      "Content-Type": "application/json"])
    }

    static var allTests = [
        ("testExample",
         testBaseUrl,
         testMakeGetRequest_list,
         testMakeGetRequest_detail,
         testMakeGetRequest_params,
         testMakeGetRequest_headers,
         testGet,
         testMakeWriteRequest_post,
         testMakeWriteRequest_put,
         testMakeWriteRequest_patch,
         testMakeWriteRequest_delete),
    ]
}
