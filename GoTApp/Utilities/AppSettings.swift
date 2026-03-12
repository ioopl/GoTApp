import SwiftUI

class AppSettings {
    // Colors
    static let primaryGold = Color(red: 0.639, green: 0.549, blue: 0.380)  // #A38C61
    static let accentRed = Color.red
    static let secondaryLabel = Color.secondary

    // Light and Dark modes
    static let textColorScheme = Color("TextColorScheme")
    static let backgroundColorScheme = Color("BackgroundColorScheme")

    // Fonts
    static let headerSerifFontSize = 11.5
    static let headerSerif = "Georgia-Bold"

    // User Interface
    static var device: UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }

    static func isPhone() -> Bool {
        return self.device == .phone
    }
    static func isPad() -> Bool {
        return self.device == .pad
    }
}
