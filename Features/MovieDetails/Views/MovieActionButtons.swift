import SwiftUI

struct MovieActionButtons: View {
    let isInWatchlist: Bool
    let onPlay: () -> Void
    let onWatchlist: () -> Void
    let onShare: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Button(action: onPlay) {
                Label("Play", systemImage: "play.fill")
                    .frame(minWidth: 108)
            }
            .buttonStyle(.borderedProminent)

            Button(action: onWatchlist) {
                Label(isInWatchlist ? "Saved" : "Watchlist", systemImage: isInWatchlist ? "checkmark" : "plus")
                    .frame(minWidth: 126)
            }
            .buttonStyle(.bordered)

            Button(action: onShare) {
                Label("Share", systemImage: "square.and.arrow.up")
                    .labelStyle(.iconOnly)
                    .frame(width: 44, height: 44)
            }
            .buttonStyle(.bordered)
            .accessibilityLabel("Share")
        }
        .font(.headline)
        .animation(.smooth(duration: 0.2), value: isInWatchlist)
    }
}
