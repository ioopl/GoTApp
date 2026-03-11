import SwiftUI

struct SeasonBadge: View {
    let season: String

    var body: some View {
        Text(season)
            .font(.caption2.bold())
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(
                Capsule()
                    .fill(Color.orange.opacity(0.15))
            )
            .foregroundColor(.orange)
            .overlay(
                Capsule()
                    .stroke(Color.orange.opacity(0.3), lineWidth: 1)
            )
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
