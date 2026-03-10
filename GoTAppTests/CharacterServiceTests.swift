import XCTest

@testable import GoTApp

final class CharacterServiceTests: XCTestCase {
    var sut: CharacterService!
    var session: URLSession!

    override func setUp() {
        super.setUp()
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        session = URLSession(configuration: configuration)

        let mockApi = NetworkManager()
        mockApi.session = session
        sut = CharacterService(api: mockApi)
    }

    override func tearDown() {
        sut = nil
        session = nil
        MockURLProtocol.stubResponseData = nil
        MockURLProtocol.stubError = nil
        MockURLProtocol.stubHTTPResponse = nil
        super.tearDown()
    }

    // Verify fetching all characters
    func testGetCharacters_Success() async throws {
        // Given
        guard
            let url = Bundle(for: type(of: self)).url(
                forResource: "characters", withExtension: "json", subdirectory: "MockData")
                ?? Bundle(for: type(of: self)).url(forResource: "characters", withExtension: "json")
        else {
            XCTFail("Missing characters.json")
            return
        }
        let data = try Data(contentsOf: url)

        MockURLProtocol.stubResponseData = data
        MockURLProtocol.stubHTTPResponse = HTTPURLResponse(
            url: URL(string: "https://www.test.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil)

        // When
        let characters = try await sut.getCharacters()

        // Then
        XCTAssertEqual(characters.count, 32)
        let eddard = characters.first
        XCTAssertEqual(eddard?.name, "Eddard Stark")
        XCTAssertEqual(eddard?.id, "Eddard Stark263")
        XCTAssertEqual(eddard?.birthYear, "263")
        XCTAssertEqual(eddard?.deathYear, "299")
        XCTAssertEqual(characters.last?.name, "Osha")
    }

    // Verify fetching a single character via synthetic ID name + born year
    func testGetCharacter_Success() async throws {
        // Given
        guard
            let url = Bundle(for: type(of: self)).url(
                forResource: "characters", withExtension: "json", subdirectory: "MockData")
                ?? Bundle(for: type(of: self)).url(forResource: "characters", withExtension: "json")
        else {
            XCTFail("Missing characters.json")
            return
        }
        let data = try Data(contentsOf: url)
        MockURLProtocol.stubResponseData = data
        MockURLProtocol.stubHTTPResponse = HTTPURLResponse(
            url: URL(string: "https://www.test.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil)

        // When
        let characterId = "Tyrion Lannister273"
        let character = try await sut.getCharacter(id: characterId)

        // Then
        XCTAssertEqual(character.name, "Tyrion Lannister")
        XCTAssertEqual(character.id, characterId)
        XCTAssertEqual(character.birthYear, "273")
    }

    // Verify that the ID is correctly formed using year extraction
    func testCharacterIdentity() {
        // Given
        let character = Character(
            name: "Test", gender: nil, culture: nil, born: "In 263 AC", died: nil, titles: nil,
            aliases: nil, tvSeries: nil, playedBy: nil)

        // Then
        XCTAssertEqual(character.id, "Test263")
    }

    func testGetCharacters_Failure() async {
        // Given
        MockURLProtocol.stubHTTPResponse = HTTPURLResponse(
            url: URL(string: "https://www.test.com")!,
            statusCode: 500,
            httpVersion: nil,
            headerFields: nil)

        // When/Then
        do {
            _ = try await sut.getCharacters()
            XCTFail("Expected error not thrown")
        } catch {
            // Success: Error was thrown
        }
    }
}
