import SwiftUI

struct MovieBackdropHeader: View {
    let movie: StreamContent
    let isInWatchlist: Bool
    let onPlay: () -> Void
    let onWatchlist: () -> Void
    let onShare: () -> Void

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            PosterArtwork(content: movie, aspectRatio: MovieDetailsLayout.backdropAspectRatio)
                .frame(maxWidth: .infinity)
                .frame(minHeight: MovieDetailsLayout.backdropMinHeight)
                .overlay(alignment: .bottom) {
                    LinearGradient(
                        colors: [.clear, AppColors.background.opacity(0.82), AppColors.background],
                        startPoint: .center,
                        endPoint: .bottom
                    )
                    .frame(height: 220)
                }

            HStack(alignment: .bottom, spacing: 22) {
                PosterArtwork(content: movie, aspectRatio: MovieDetailsLayout.posterAspectRatio)
                    .frame(width: MovieDetailsLayout.posterWidth, height: MovieDetailsLayout.posterHeight)
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                    .shadow(color: .black.opacity(0.35), radius: 18, y: 10)

                VStack(alignment: .leading, spacing: 13) {
                    Text(movie.title)
                        .font(.system(size: 38, weight: .bold))
                        .foregroundStyle(AppColors.foreground)
                        .lineLimit(2)

                    MovieMetadataView(movie: movie)

                    MovieActionButtons(
                        isInWatchlist: isInWatchlist,
                        onPlay: onPlay,
                        onWatchlist: onWatchlist,
                        onShare: onShare
                    )
                }
                .frame(maxWidth: 720, alignment: .leading)
            }
            .padding(.horizontal, MovieDetailsLayout.horizontalPadding)
            .padding(.bottom, 26)
        }
        .accessibilityElement(children: .combine)
    }
}
