import XCTest
@testable import GoTApp

// Mock Model
struct MockCharacter: Codable {
    let id: Int
    let name: String
}

// NetworkManagerTests using URLProtocol mocking.
final class NetworkManagerTests: XCTestCase {
    var sut: NetworkManager!
    var session: URLSession!

    override func setUp() {
        super.setUp()
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        session = URLSession(configuration: configuration)
        sut = NetworkManager.shared
        sut.session = session
    }

    override func tearDown() {
        sut = nil
        session = nil
        MockURLProtocol.stubResponseData = nil
        MockURLProtocol.stubError = nil
        MockURLProtocol.stubHTTPResponse = nil
        super.tearDown()
    }

    // Test Successful JSON decoding. It does not hit the real endpoint.
    func testRequest_Success() async throws {
        // Given
        let expectedData = "{\"id\": 1, \"name\": \"Jon Snow\"}".data(using: .utf8)!
        
        MockURLProtocol.stubResponseData = expectedData
        MockURLProtocol.stubHTTPResponse = HTTPURLResponse(url: URL(string: "https://www.test.com")!,
                                                           statusCode: 200,
                                                           httpVersion: nil,
                                                           headerFields: nil)
        
        // When
        let character: MockCharacter = try await sut.request(endpoint: "/1")
        
        // Then
        XCTAssertEqual(character.name, "Jon Snow")
    }

    // Test Correct handling of 401 Unauthorized errors
    func testRequest_Unauthorized() async {
        // Given
        MockURLProtocol.stubHTTPResponse = HTTPURLResponse(url: URL(string: "https://www.test.com")!,
                                                           statusCode: 401,
                                                           httpVersion: nil,
                                                           headerFields: nil)
        
        // When/Then
        do {
            let _ : MockCharacter = try await sut.request(endpoint: "/1")
            XCTFail("Expected error not thrown")
        } catch let error as APIError {
            if case .unauthorized = error {
                // Success
            } else {
                XCTFail("Unexpected error type: \(error)")
            }
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }

    // Test Correct handling of decoding errors.
    func testRequest_DecodingError() async {
        // Given
        let invalidData = "invalid json".data(using: .utf8)!
        
        MockURLProtocol.stubResponseData = invalidData
        
        MockURLProtocol.stubHTTPResponse = HTTPURLResponse(url: URL(string: "https://www.test.com")!,
                                                           statusCode: 200,
                                                           httpVersion: nil,
                                                           headerFields: nil)
        
        // When/Then
        do {
            let _: MockCharacter = try await sut.request(endpoint: "/1")
            XCTFail("Expected decoding error not thrown")
        } catch is DecodingError {
            // Success
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
}
