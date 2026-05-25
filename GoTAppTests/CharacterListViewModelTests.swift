import XCTest

@testable import GoTApp

final class CharacterListViewModelTests: XCTestCase {
    var sut: CharacterListViewModel!
    var mockService: MockCharacterService!

    @MainActor
    override func setUp() {
        super.setUp()
        mockService = MockCharacterService()
        sut = CharacterListViewModel(service: mockService)
    }

    override func tearDown() {
        sut = nil
        mockService = nil
        super.tearDown()
    }

    @MainActor
    func testFetchCharacters_Success() async {
        // Given
        let expectedCharacters = [
            Character(name: "Jon Snow",
                      gender: nil,
                      culture: "North",
                      born: "283 AC",
                      died: nil,
                      titles: nil,
                      aliases: nil,
                      tvSeries: ["Season 1"],
                      playedBy: nil),
            
            Character(name: "Ned Stark",
                      gender: nil,
                      culture: "North",
                      born: "263 AC",
                      died: "299 AC",
                      titles: nil,
                      aliases: nil,
                      tvSeries: ["Season 1"],
                      playedBy: nil),
        ]
        mockService.stubCharacters = expectedCharacters

        // When
        await sut.fetchCharacters()

        // Then
        XCTAssertEqual(sut.characters.count, 2)
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.errorMessage)
    }

    @MainActor
    func testSearchFiltering() async {
        // Given
        mockService.stubCharacters = [
            Character(name: "Jon Snow",
                      gender: nil,
                      culture: "North",
                      born: "283 AC",
                      died: nil,
                      titles: nil,
                      aliases: nil,
                      tvSeries: nil,
                      playedBy: nil),
            Character(name: "Tyrion Lannister",
                      gender: nil,
                      culture: "Westeros",
                      born: "273 AC",
                      died: nil,
                      titles: nil,
                      aliases: nil,
                      tvSeries: nil,
                      playedBy: nil),
        ]
        await sut.fetchCharacters()

        // When
        sut.searchText = "Tyrion"

        // Then - Wait for debounce (300ms)
        try? await Task.sleep(nanoseconds: 500_000_000)

        XCTAssertEqual(sut.characters.count, 1)
        XCTAssertEqual(sut.characters.first?.name, "Tyrion Lannister")
    }

    @MainActor
    func testFetchCharacters_RefreshAvatarsUpdatesCacheBuster() async {
        mockService.stubCharacters = [
            Character(
                name: "Arya Stark",
                gender: nil,
                culture: nil,
                born: "289 AC",
                died: nil,
                titles: nil,
                aliases: nil,
                tvSeries: nil,
                playedBy: nil
            )
        ]

        XCTAssertNil(sut.avatarCacheBuster)

        await sut.fetchCharacters(refreshAvatars: true)
        let firstCacheBuster = sut.avatarCacheBuster

        await sut.fetchCharacters(refreshAvatars: true)

        XCTAssertNotNil(firstCacheBuster)
        XCTAssertNotNil(sut.avatarCacheBuster)
        XCTAssertNotEqual(firstCacheBuster, sut.avatarCacheBuster)
    }

    @MainActor
    func testFetchCharacters_DefaultLoadDoesNotUpdateAvatarCacheBuster() async {
        mockService.stubCharacters = [
            Character(
                name: "Arya Stark",
                gender: nil,
                culture: nil,
                born: "289 AC",
                died: nil,
                titles: nil,
                aliases: nil,
                tvSeries: nil,
                playedBy: nil
            )
        ]

        await sut.fetchCharacters()

        XCTAssertNil(sut.avatarCacheBuster)
    }
}

class MockCharacterService: CharacterServiceProtocol {
    var stubCharacters: [Character] = []
    var stubError: Error?

    func getCharacters() async throws -> [Character] {
        if let error = stubError { throw error }
        return stubCharacters
    }

    func getCharacter(id: String) async throws -> Character {
        if let error = stubError { throw error }
        return stubCharacters.first!
    }
}
