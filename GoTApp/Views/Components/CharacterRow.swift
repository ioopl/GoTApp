import SwiftUI

struct CharacterRow: View {
    let character: Character

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(character.name)
                        .font(.headline)
                        .foregroundColor(.primary)

                    if let culture = character.culture, !culture.isEmpty {
                        Text(culture)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }

                Spacer()

                if let deathYear = character.deathYearRoman ?? character.deathYear {
                    HStack(spacing: 4) {
                        Image(systemName: "flag.pattern.checkered.2.crossed")
                            .font(.caption2)
                        Text(deathYear)
                            .font(.caption.bold())
                    }
                    .foregroundColor(.gray)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(6)
                }
            }

            if !character.romanSeasons.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        ForEach(character.romanSeasons, id: \.self) { season in
                            SeasonBadge(season: season)
                        }
                    }
                }
            }
        }
        .padding(.vertical, 8)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityHint("accessibility_character_row_hint")
    }

    private var accessibilityLabel: String {
        var components = [character.name]

        if let culture = character.culture, !culture.isEmpty {
            components.append(
                String(
                    localized: "accessibility_culture_format", defaultValue: "Culture: \(culture)"))
        }

        if let deathYear = character.deathYearRoman ?? character.deathYear {
            components.append(
                String(localized: "accessibility_died_format", defaultValue: "Died in \(deathYear)")
            )
        }

        if !character.romanSeasons.isEmpty {
            let seasonsStr = character.romanSeasons.joined(separator: ", ")
            components.append(
                String(localized: "detail_seasons", defaultValue: "Seasons") + ": " + seasonsStr)
        }

        return components.joined(separator: ", ")
    }
}

#Preview {
    Group {
        CharacterRow(
            character: Character(
                name: "Eddard Stark",
                gender: "Male",
                culture: "Northmen",
                born: "263 AC",
                died: "299 AC",
                titles: nil,
                aliases: nil,
                tvSeries: ["Season 1", "Season 6"],
                playedBy: nil
            ))

        CharacterRow(
            character: Character(
                name: "Jon Snow",
                gender: "Male",
                culture: "Northmen",
                born: "283 AC",
                died: nil,
                titles: nil,
                aliases: nil,
                tvSeries: ["Season 1", "Season 2", "Season 3"],
                playedBy: nil
            ))
    }
    .padding()
}
