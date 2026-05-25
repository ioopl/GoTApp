import Foundation

@MainActor
class CharacterListViewModel: ObservableObject {
    
    @Published var characters: [Character] = []
    @Published private(set) var avatarCacheBuster: String?
    @Published var searchText: String = "" {
        didSet {
            // Trigger search with debounce when text changes
            Task {
                await debounceSearch(query: searchText)
            }
        }
    }
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let service: CharacterServiceProtocol
    private let bustAvatarCacheOnRefresh: Bool
    private var allCharacters: [Character] = []
    private var searchTask: Task<Void, Never>?

    // The view model accepts an injected CharacterServiceProtocol
    init(
        service: CharacterServiceProtocol = CharacterService(),
        bustAvatarCacheOnRefresh: Bool = true
    ) {
        self.service = service
        self.bustAvatarCacheOnRefresh = bustAvatarCacheOnRefresh
    }

    func fetchCharacters(refreshAvatars: Bool = false) async {
        isLoading = true
        errorMessage = nil

        if refreshAvatars && bustAvatarCacheOnRefresh {
            avatarCacheBuster = UUID().uuidString
        }

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
