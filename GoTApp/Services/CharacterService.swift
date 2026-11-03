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
    // from DisneyCharatcers - simplified example just for illustration
    func getCharacters2() async throws -> [Character] {
        
        let url = URL(string:(AppConfig.shared.apiBaseUrl + AppConfig.shared.charactersEndpoint))!
         
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        request.setValue("Bearer \(AppConfig.shared.accessToken)", forHTTPHeaderField: "Authorization")

        //let (data, response) = try await URLSession.shared.data(from: url2)
        
        // ✅ Pass the request, not the URL
        let (data, response) = try await URLSession.shared.data(for: request)

        let characters = try JSONDecoder().decode([Character].self, from: data)

//        let characters = try JSONDecoder().decode(DisneyResponse.self, from: data)
        return characters
    }
    
    private struct DisneyResponse: Decodable {
        let data: [Character] } }
