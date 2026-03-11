import Foundation

struct Character: Codable, Identifiable, Hashable {
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

    var romanSeasons: [String] {
        tvSeries?.compactMap { season in
            guard let numberStr = season.extractYear(), let number = Int(numberStr) else {
                return nil
            }
            return RomanNumeralConverter.toRoman(number)
        } ?? []
    }
}
