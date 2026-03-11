import SwiftUI

struct ContentView: View {
    @StateObject private var coordinator = AppCoordinator()

    var body: some View {
        Group {
            if coordinator.isAuthenticated {
                NavigationStack(path: $coordinator.path) {
                    CharacterListView()
                        .navigationDestination(for: GoTDestination.self) { destination in
                            switch destination {
                            case .detail(let character):
                                CharacterDetailView(character: character)
                            }
                        }
                }
            } else {
                ErrorView(
                    message: coordinator.errorMessage ?? "Unknown Error",
                    onRetry: {
                        coordinator.retry()
                    })
            }
        }
        .environmentObject(coordinator)
        .task {
            coordinator.start()
        }
    }
}

#Preview {
    ContentView()
}
