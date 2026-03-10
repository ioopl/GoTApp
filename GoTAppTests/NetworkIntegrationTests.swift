import XCTest

@testable import GoTApp

final class NetworkIntegrationTests: XCTestCase {
    var sut: NetworkManager!
    
    override func setUp() {
        super.setUp()
        sut = NetworkManager.shared
        // Use the default shared session to hit the real network
        sut.session = .shared
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    /**
     This test will hit the real API endpoint and print the JSON to the console.
     */
    func testFetchRealCharacters() async throws {
        // We will use an EmptyResponse for now since we haven't built the model yet.
        
        do {
            // The endpoint according to AppConfig is "" (the baseURL itself) or "/"
            let _: [EmptyCharacter] = try await sut.request(endpoint: AppConfig.shared.charactersEndpoint, requiresAuth: true)
            
            // If successful the raw JSON will be printed in the console because of our print statement in NetworkManager.
        } catch {
            XCTFail("Failed to fetch real data: \(error)")
        }
    }
}

/** Temporary empty model to allow decoding anything as a list or a single object. Since we don't know the structure, we use an empty struct. Note: If the API returns a list, we need to decode it as [T].
 */
struct EmptyCharacter: Decodable {}
