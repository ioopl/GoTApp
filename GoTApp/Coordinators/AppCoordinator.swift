import SwiftUI

enum GoTDestination: Hashable {
    case detail(Character)
}

@MainActor
@Observable
class AppCoordinator {
    var path = NavigationPath()
    var isAuthenticated: Bool = true
    var errorMessage: String?

    func start() {
        // Here we could validate the API key. For simplicity, we'll assume token exists and is valid unless a service tells us otherwise later.
        if !isAuthenticated {
            showError(message: String(localized: "error_invalid_token"))
        }
    }

    func showDetail(for character: Character) {
        path.append(GoTDestination.detail(character))
    }

    func showError(message: String) {
        isAuthenticated = false
        errorMessage = message
    }

    func retry() {
        isAuthenticated = true
        errorMessage = nil
        start()
    }

    func goBack() {
        if !path.isEmpty {
            path.removeLast()
        }
    }

    func goToRoot() {
        path = NavigationPath()
    }
}
