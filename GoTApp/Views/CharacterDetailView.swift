import SwiftUI
import UIKit

struct CharacterDetailView: View {
    let character: Character

    var body: some View {
        ZStack {
            Color(UIColor.systemBackground).ignoresSafeArea()

            ScrollView {
                VStack(spacing: 30) {
                    // Motiff Detail Header
                    VStack(spacing: 20) {
                        Rectangle()
                            .fill(AppSettings.primaryGold)
                            .frame(width: 80, height: 2)

                        Text(character.name)
                            .font(.custom(AppSettings.headerSerif, size: 32))
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)

                        Rectangle()
                            .fill(AppSettings.primaryGold)
                            .frame(width: 80, height: 2)

                        if let culture = character.culture, !culture.isEmpty {
                            Text(culture)
                                .font(.caption.bold())
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(Color(UIColor.systemGray2).opacity(0.3))
                                .foregroundColor(.primary)
                                .cornerRadius(8)
                        }
                    }
                    .padding(.top, 40)
                    .padding(.bottom, 20)

                    // Detail Cards
                    VStack(spacing: 16) {
                        if let born = character.born, !born.isEmpty {
                            detailCard(
                                title: "detail_born", value: born,
                                romanValue: character.birthYearRoman)
                        }

                        if let died = character.died, !died.isEmpty {
                            detailCard(
                                title: "detail_died", value: died,
                                romanValue: character.deathYearRoman)
                        }

                        if let titles = character.titles, !titles.isEmpty {
                            listCard(title: "detail_titles", items: titles)
                        }

                        if let aliases = character.aliases, !aliases.isEmpty {
                            listCard(title: "detail_aliases", items: aliases)
                        }

                        if let playedBy = character.playedBy, !playedBy.isEmpty {
                            listCard(title: "detail_played_by", items: playedBy)
                        }

                        if !character.romanSeasons.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("detail_seasons")
                                    .font(.caption.bold())
                                    .foregroundColor(.secondary)
                                    .textCase(.uppercase)
                                    .padding(.horizontal, 4)

                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 12) {
                                        ForEach(character.romanSeasons, id: \.self) { season in
                                            SeasonBadge(season: season)
                                                .scaleEffect(1.2)
                                                .padding(.vertical, 4)
                                        }
                                    }
                                    .padding(.horizontal, 4)
                                }
                            }
                            .padding(20)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(UIColor.secondarySystemBackground))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.primary.opacity(0.05), lineWidth: 1)
                            )
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 40)
                }
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }

    @ViewBuilder
    private func detailCard(title: String, value: String, romanValue: String? = nil) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(LocalizedStringKey(title))
                .font(.caption.bold())
                .foregroundColor(.secondary)
                .textCase(.uppercase)

            VStack(alignment: .leading, spacing: 4) {
                Text(value)
                    .font(.title3.bold())
                    .foregroundColor(.primary)

                if let roman = romanValue {
                    Text(roman)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
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
        .accessibilityLabel(
            "\(String(localized: String.LocalizationValue(title))): \(value)\(romanValue != nil ? ", \(romanValue!)" : "")"
        )
    }

    @ViewBuilder
    private func listCard(title: String, items: [String]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(LocalizedStringKey(title))
                .font(.caption.bold())
                .foregroundColor(.secondary)
                .textCase(.uppercase)

            VStack(alignment: .leading, spacing: 8) {
                ForEach(items, id: \.self) { item in
                    HStack(alignment: .top, spacing: 8) {
                        Text("•")
                            .foregroundColor(AppSettings.primaryGold)
                        Text(item)
                            .font(.body)
                            .foregroundColor(.primary)
                    }
                }
            }
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
