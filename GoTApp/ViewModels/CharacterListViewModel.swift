import Foundation

@MainActor
class CharacterListViewModel: ObservableObject {
    
    @Published var characters: [Character] = []
    @Published var searchText: String = "" {
        didSet {
            let query = searchText

            // Trigger search with debounce when text changes
            Task {
                await debounceSearch(query: searchText)
            }
        }
    }
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let service: CharacterServiceProtocol
    private var allCharacters: [Character] = []
    private var searchTask: Task<Void, Never>?

    // The view model accepts an injected CharacterServiceProtocol
    init(service: CharacterServiceProtocol = CharacterService()) {
        self.service = service
    }

    func fetchCharacters() async {
        isLoading = true
        errorMessage = nil
        do {
            allCharacters = try await service.getCharacters()
            filterCharacters(using: searchText)
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    /**
     Delay the execution of a search/filter operation
    */
    private func debounceSearch(query: String) async {
        searchTask?.cancel() // cancels the previous pending debounce TASK
        searchTask = Task { // Create a new async TASK
            try? await Task.sleep(nanoseconds: 300_000_000)  // 300ms / 0.3 seconds debounce
            guard !Task.isCancelled else { return } // Check if TASK was cancelled then exit immediately
            filterCharacters(using: query)
        }
    }

    private func filterCharacters(using searchText: String) {
        if searchText.isEmpty {
            characters = allCharacters
        } else {
            characters = allCharacters.filter { character in
                character.name.localizedCaseInsensitiveContains(searchText)
                    || (character.culture?.localizedCaseInsensitiveContains(searchText) ?? false)
            }
        }
    }
}
