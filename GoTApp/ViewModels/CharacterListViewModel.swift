import Foundation

@MainActor
class CharacterListViewModel: ObservableObject {
    
    @Published var characters: [Character] = []
    @Published var searchText: String = "" {
        didSet {
            // Trigger search with debounce when text changes
            Task {
                await debounceSearch()
            }
        }
    }
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let service: CharacterServiceProtocol
    private var allCharacters: [Character] = []
    private var searchTask: Task<Void, Never>?

    init(service: CharacterServiceProtocol = CharacterService()) {
        self.service = service
    }

    func fetchCharacters() async {
        isLoading = true
        errorMessage = nil
        do {
            allCharacters = try await service.getCharacters()
            filterCharacters()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    private func debounceSearch() async {
        searchTask?.cancel()
        searchTask = Task {
            try? await Task.sleep(nanoseconds: 300_000_000)  // 300ms debounce
            guard !Task.isCancelled else { return }
            filterCharacters()
        }
    }

    private func filterCharacters() {
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
