import SwiftUI

struct CharacterListView: View {
    @StateObject private var viewModel = CharacterListViewModel()
    @EnvironmentObject var coordinator: AppCoordinator

    var body: some View {
        Group {
            if viewModel.isLoading && viewModel.characters.isEmpty {
                ProgressView("Loading Characters...")
            } else if let error = viewModel.errorMessage {
                VStack(spacing: 16) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.largeTitle)
                        .foregroundColor(.red)
                    Text(error)
                        .multilineTextAlignment(.center)
                    Button("Retry") {
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
                        CharacterRow(character: character)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                coordinator.showDetail(for: character)
                            }
                    }
                }
                .listStyle(.plain)
                .searchable(text: $viewModel.searchText, prompt: "Search names or cultures")
                .refreshable {
                    await viewModel.fetchCharacters()
                }
            }
        }
        .navigationTitle("GoT Characters")
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
