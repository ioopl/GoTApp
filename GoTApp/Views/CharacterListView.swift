import SwiftUI
import UIKit

struct CharacterListView: View {
    @StateObject private var viewModel = CharacterListViewModel()
    @EnvironmentObject var coordinator: AppCoordinator

    var body: some View {
        ZStack {
            Color(UIColor.systemBackground).ignoresSafeArea()

            VStack(spacing: 0) {
                // Motiff Header
                VStack(spacing: 4) {
                    Text("character_list_title")
                        .font(.custom(AppSettings.headerSerif, size: 28))
                        .foregroundColor(AppSettings.primaryGold)
                        .tracking(2)

                    Text("character_directory_subtitle")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .tracking(1)

                    Rectangle()
                        .fill(AppSettings.primaryGold.opacity(0.3))
                        .frame(height: 1)
                        .padding(.top, 8)
                }
                .padding(.top, 20)
                .padding(.bottom, 10)
                .background(Color(UIColor.systemBackground))

                if viewModel.isLoading && viewModel.characters.isEmpty {
                    Spacer()
                    ProgressView("loading_characters")
                        .tint(AppSettings.primaryGold)
                    Spacer()
                } else if let error = viewModel.errorMessage {
                    Spacer()
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.largeTitle)
                            .foregroundColor(.red)
                        Text(error)
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.center)
                        Button("retry_button") {
                            Task {
                                await viewModel.fetchCharacters()
                            }
                        }
                        .buttonStyle(.bordered)
                        .tint(AppSettings.primaryGold)
                    }
                    .padding()
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.characters) { character in
                                NavigationLink(value: GoTDestination.detail(character)) {
                                    CharacterRow(character: character)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding()
                    }
                    .refreshable {
                        await viewModel.fetchCharacters()
                    }
                    .searchable(text: $viewModel.searchText, prompt: "search_placeholder") // SwiftUI binds the search field to this property in the ViewModel, And every time searchText changes, its didSet runs automatically
                }
            }
        }
        //.toolbar(.hidden, for: .navigationBar)
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
