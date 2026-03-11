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
                    detailRow(
                        title: "detail_born", value: character.born,
                        romanValue: character.birthYearRoman)
                    detailRow(
                        title: "detail_died", value: character.died,
                        romanValue: character.deathYearRoman)

                    if let titles = character.titles, !titles.isEmpty {
                        detailSection(title: "detail_titles", items: titles)
                    }

                    if let aliases = character.aliases, !aliases.isEmpty {
                        detailSection(title: "detail_aliases", items: aliases)
                    }

                    if let playedBy = character.playedBy, !playedBy.isEmpty {
                        detailSection(title: "detail_played_by", items: playedBy)
                    }

                    if !character.romanSeasons.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("detail_seasons")
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
    private func detailRow(title: String, value: String?, romanValue: String? = nil) -> some View {
        if let value = value, !value.isEmpty {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
                    .textCase(.uppercase)

                HStack(spacing: 8) {
                    Text(value)
                        .font(.body)

                    if let roman = romanValue {
                        Text("(\(roman))")
                            .font(.body.italic())
                            .foregroundColor(.secondary)
                    }
                }
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
        CharacterDetailView(
            character:
                Character(
                    name: "Eddard Stark",
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
