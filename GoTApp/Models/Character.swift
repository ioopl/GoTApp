import Foundation

struct Character: Codable, Identifiable {
    var id: String {
        // Synthetic ID, formed as name + extractedYear e.g., "Eddard Stark263"
        name + (born?.extractYear() ?? "")
    }
    let name: String
    let gender: String?
    let culture: String?
    let born: String?
    let died: String?
    let titles: [String]?
    let aliases: [String]?
    let tvSeries: [String]?
    let playedBy: [String]?

    // computed properties
    var birthYear: String? { born?.extractYear() }
    var deathYear: String? { died?.extractYear() }
}

extension String {
    /**
     Extracts the first sequence of digits from a string (e.g., "263" from "In 263 AC").
     */
    func extractYear() -> String? {
        let pattern = "\\d+"
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return nil }
        let nsString = self as NSString
        let results = regex.matches(in: self, range: NSRange(location: 0, length: nsString.length))
        return results.first.map { nsString.substring(with: $0.range) }
    }
}
