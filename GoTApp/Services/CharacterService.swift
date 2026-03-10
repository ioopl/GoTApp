import Foundation

class CharacterService: CharacterServiceProtocol {
    private let api: NetworkManager

    init(api: NetworkManager = .shared) {
        self.api = api
    }

    // MARK: - API Methods

    func getCharacters() async throws -> [Character] {
        return try await api.request(endpoint: AppConfig.shared.charactersEndpoint)
    }

    func getCharacter(id: String) async throws -> Character {
        let characters: [Character] = try await getCharacters()
        guard let character = characters.first(where: { $0.id == id }) else {
            throw APIError.serverError("Character not found")
        }
        return character
    }
}
