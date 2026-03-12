import SwiftUI

struct SeasonBadge: View {
    let season: String

    var body: some View {
        Text(season)
            .font(.caption2.bold())
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .fill(AppSettings.backgroundColorScheme)
            )
            .foregroundColor(AppSettings.textColorScheme)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(AppSettings.primaryGold.opacity(0.3), lineWidth: 0.5)
            )
            .accessibilityLabel(
                String(localized: "accessibility_season_format", defaultValue: "Season \(season)"))
    }
}

#Preview {
    HStack {
        SeasonBadge(season: "I")
        SeasonBadge(season: "IV")
        SeasonBadge(season: "X")
    }
    .padding()
}
