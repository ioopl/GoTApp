import Foundation

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
