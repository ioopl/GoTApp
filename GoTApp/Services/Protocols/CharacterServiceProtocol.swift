import Foundation

protocol CharacterServiceProtocol {
    func getCharacters() async throws -> [Character]
    func getCharacter(id: String) async throws -> Character
}
