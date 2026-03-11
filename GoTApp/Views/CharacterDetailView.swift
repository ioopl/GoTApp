import SwiftUI

struct CharacterDetailView: View {
    let character: Character

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(character.name)
                        .font(.system(size: 34, weight: .bold, design: .serif))
                        .foregroundColor(.primary)

                    if let culture = character.culture, !culture.isEmpty {
                        Text(culture)
                            .font(.title3)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.top)

                Divider()

                VStack(alignment: .leading, spacing: 16) {
                    detailRow(title: "Born", value: character.born)
                    detailRow(title: "Died", value: character.died)

                    if let titles = character.titles, !titles.isEmpty {
                        detailSection(title: "Titles", items: titles)
                    }

                    if let aliases = character.aliases, !aliases.isEmpty {
                        detailSection(title: "Aliases", items: aliases)
                    }

                    if let playedBy = character.playedBy, !playedBy.isEmpty {
                        detailSection(title: "Played By", items: playedBy)
                    }

                    if !character.romanSeasons.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Seasons")
                                .font(.headline)
                                .foregroundColor(.secondary)

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    ForEach(character.romanSeasons, id: \.self) { season in
                                        SeasonBadge(season: season)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle(character.name)
        .navigationBarTitleDisplayMode(.inline)
    }

    @ViewBuilder
    private func detailRow(title: String, value: String?) -> some View {
        if let value = value, !value.isEmpty {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
                    .textCase(.uppercase)
                Text(value)
                    .font(.body)
            }
        }
    }

    @ViewBuilder
    private func detailSection(title: String, items: [String]) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.secondary)
                .textCase(.uppercase)

            VStack(alignment: .leading, spacing: 4) {
                ForEach(items, id: \.self) { item in
                    Text("\(item)")
                        .font(.body)
                }
            }
        }
    }
}

#Preview {
    NavigationView {
        CharacterDetailView(character:
                                Character(name: "Eddard Stark",
                                          gender: "Male",
                                          culture: "Northmen",
                                          born: "263 AC",
                                          died: "299 AC",
                                          titles: ["Lord of Winterfell", "Hand of the King"],
                                          aliases: ["Ned"],
                                          tvSeries: ["Season 1", "Season 6"],
                                          playedBy: ["Sean Bean"]))
    }
}
