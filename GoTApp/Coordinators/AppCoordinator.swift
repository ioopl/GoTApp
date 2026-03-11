import SwiftUI

enum GoTDestination: Hashable {
    case detail(Character)
}

@MainActor
class AppCoordinator: ObservableObject {
    @Published var path = NavigationPath()
    @Published var isAuthenticated: Bool = true
    @Published var errorMessage: String?

    func start() {
        // Here we could validate the API key. For simplicity, we'll assume token exists and is valid unless a service tells us otherwise later.
        if !isAuthenticated {
            showError(message: "Invalid API Access Token")
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
