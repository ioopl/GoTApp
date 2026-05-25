import Foundation

// Custom Error to represent server errors
enum APIError: LocalizedError {
    case serverError(String)
    case unauthorized(String?)
    case unknown

    var errorDescription: String? {
        switch self {
        case .serverError(let message):
            return message
        case .unauthorized(let message):
            return message ?? "Unauthorized access. Please log in again."
        case .unknown:
            return "An unknown error occurred."
        }
    }
}

class NetworkManager {
    static let shared = NetworkManager()
    
    // session allows tests to mock the URLSession
    var session: URLSession = .shared
    
    // Base URL
    let baseURL = AppConfig.shared.apiBaseUrl
    
    private let tokenKey = AppConfig.shared.accessToken
    
    private let userKey = "currentUser"
        
    // MARK: - Request Logic
    
    func request<T: Decodable>(endpoint: String,
                               method: String = "GET",
                               body: Encodable? = nil,
                               requiresAuth: Bool = true) async throws -> T {
        let url: URL
        if endpoint.lowercased().hasPrefix("http") {
            guard let absoluteURL = URL(string: endpoint) else {
                throw URLError(.badURL)
            }
            url = absoluteURL
        } else {
            guard let constructedURL = URL(string: "\(baseURL)\(endpoint)") else {
                throw URLError(.badURL)
            }
            url = constructedURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if requiresAuth {
            request.setValue("Bearer \(tokenKey)", forHTTPHeaderField: "Authorization")
        }
        
        if let body = body {
            do {
                request.httpBody = try JSONEncoder().encode(body)
            } catch {
                throw URLError(.cannotDecodeContentData)  // Encoding error
            }
        }
        
        // Debugging
        print("Network Request: \(method) \(url.absoluteString)")
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        if !(200...299).contains(httpResponse.statusCode) {
            print("Network Error: \(httpResponse.statusCode) for \(url.absoluteString)")
            
            var serverMessage: String? = nil
            // Try to decode error message if possible
            if let errorJson = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let message = errorJson["error"] as? String ?? errorJson["message"] as? String
            {
                // Custom error handling could involve a specific Error struct
                print("Server Message: \(message)")
                serverMessage = message
            }
            
            if httpResponse.statusCode == 401 {
                throw APIError.unauthorized(serverMessage)
            }
            
            if let msg = serverMessage {
                throw APIError.serverError(msg)
            }
            
            throw URLError(.badServerResponse)
        }
        
        do {
            if let jsonString = String(data: data, encoding: .utf8) {
                // Log all responses so we can see what the API returns before casting
                print("Raw Response for \(endpoint): \(jsonString)")
            }
            let decoded = try JSONDecoder().decode(T.self, from: data)
            return decoded
        } catch {
            print("Decoding Error: \(error)")
            // Debugging: print(String(data: data, encoding: .utf8) ?? "")
            throw error
        }
    }
}
