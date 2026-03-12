import SwiftUI
import UIKit

struct CharacterRow: View {
    let character: Character

    var body: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 16) {
                // Header: Name and Culture
                VStack(alignment: .leading, spacing: 8) {
                    Text(character.name)
                        .font(.custom(AppSettings.headerSerif, size: 20))
                        .foregroundColor(.primary)

                    if let culture = character.culture, !culture.isEmpty {
                        Text(culture)
                            .font(.caption.bold())
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(AppSettings.primaryGold.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(4)
                    }
                }

                // Status: Deceased info
                if let deathYear = character.deathYearRoman ?? character.deathYear {
                    HStack(spacing: 8) {
                        Text("💀")
                            .font(.caption)
                        Text("☨ \(deathYear)")
                            .font(.caption.bold())
                    }
                    .foregroundColor(.red.opacity(0.8))
                }

                // Seasons Section
                if !character.romanSeasons.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("appeared_in_label")
                            .font(.caption2)
                            .foregroundColor(AppSettings.primaryGold)
                            .textCase(.uppercase)

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

            Spacer()

            Image(systemName: "chevron.right")
                .font(.footnote.bold())
                .foregroundColor(AppSettings.primaryGold.opacity(0.5))
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(UIColor.secondarySystemBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.primary.opacity(0.05), lineWidth: 1)
        )
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
