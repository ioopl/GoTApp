import SwiftUI

struct CharacterListView: View {
    @StateObject private var viewModel = CharacterListViewModel()
    @EnvironmentObject var coordinator: AppCoordinator

    var body: some View {
        Group {
            if viewModel.isLoading && viewModel.characters.isEmpty {
                ProgressView("loading_characters")
            } else if let error = viewModel.errorMessage {
                VStack(spacing: 16) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.largeTitle)
                        .foregroundColor(.red)
                    Text(error)
                        .multilineTextAlignment(.center)
                    Button("retry_button") {
                        Task {
                            await viewModel.fetchCharacters()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
            } else {
                List {
                    ForEach(viewModel.characters) { character in
                        NavigationLink(value: GoTDestination.detail(character)) {
                            CharacterRow(character: character)
                        }
                    }
                }
                .listStyle(.plain)
                .searchable(text: $viewModel.searchText, prompt: "search_placeholder")
                .refreshable {
                    await viewModel.fetchCharacters()
                }
            }
        }
        .navigationTitle("character_list_title")
        .task {
            if viewModel.characters.isEmpty {
                await viewModel.fetchCharacters()
            }
        }
    }
}

#Preview {
    CharacterListView()
}
