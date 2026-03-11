import SwiftUI

struct ContentView: View {
    @StateObject private var coordinator = AppCoordinator()

    var body: some View {
        Group {
            if coordinator.isAuthenticated {
                NavigationStack(path: $coordinator.path) {
                    CharacterListView()
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
