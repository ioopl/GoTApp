import Foundation

enum AvatarURLBuilder {
    private static let seedAllowedCharacters = CharacterSet.urlPathAllowed.subtracting(
        CharacterSet(charactersIn: "/")
    )

    static func url(for seed: String, cacheBuster: String? = nil) -> URL? {
        guard
            let encodedSeed = seed.addingPercentEncoding(withAllowedCharacters: seedAllowedCharacters),
            var components = URLComponents(string: "https://robohash.org/\(encodedSeed).png")
        else {
            return nil
        }

        var queryItems = [
            URLQueryItem(name: "set", value: "set4"),
            URLQueryItem(name: "bgset", value: "bg1"),
            URLQueryItem(name: "size", value: "96x96"),
        ]

        if let cacheBuster, !cacheBuster.isEmpty {
            queryItems.append(URLQueryItem(name: "refresh", value: cacheBuster))
        }

        components.queryItems = queryItems
        return components.url
    }
}
