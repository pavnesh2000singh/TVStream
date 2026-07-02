import SwiftUI

struct MovieDetailsLoadingView: View {
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(alignment: .leading, spacing: 28) {
                ZStack(alignment: .bottomLeading) {
                    Rectangle()
                        .fill(AppColors.foreground.opacity(0.08))
                        .frame(height: MovieDetailsLayout.backdropMinHeight)

                    HStack(alignment: .bottom, spacing: 22) {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(AppColors.foreground.opacity(0.12))
                            .frame(width: MovieDetailsLayout.posterWidth, height: MovieDetailsLayout.posterHeight)

                        VStack(alignment: .leading, spacing: 14) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(AppColors.foreground.opacity(0.12))
                                .frame(width: 280, height: 34)

                            RoundedRectangle(cornerRadius: 4)
                                .fill(AppColors.foreground.opacity(0.08))
                                .frame(width: 360, height: 18)

                            HStack(spacing: 12) {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(AppColors.foreground.opacity(0.14))
                                    .frame(width: 108, height: 44)
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(AppColors.foreground.opacity(0.1))
                                    .frame(width: 126, height: 44)
                            }
                        }
                    }
                    .padding(.horizontal, MovieDetailsLayout.horizontalPadding)
                    .padding(.bottom, 26)
                }

                ForEach(0..<3, id: \.self) { _ in
                    RoundedRectangle(cornerRadius: 6)
                        .fill(AppColors.foreground.opacity(0.08))
                        .frame(height: 22)
                        .padding(.horizontal, MovieDetailsLayout.horizontalPadding)
                }

                LazyHStack(spacing: 14) {
                    ForEach(0..<5, id: \.self) { _ in
                        RoundedRectangle(cornerRadius: 8)
                            .fill(AppColors.foreground.opacity(0.08))
                            .frame(width: HomeLayout.cardWidth, height: HomeLayout.cardHeight)
                    }
                }
                .padding(.horizontal, MovieDetailsLayout.horizontalPadding)
            }
            .redacted(reason: .placeholder)
        }
    }
}

struct MovieDetailsErrorView: View {
    let message: String
    let retry: () -> Void

    var body: some View {
        ContentUnavailableView {
            Label("Unable to load details", systemImage: "film.stack")
        } description: {
            Text(message)
        } actions: {
            Button("Retry", action: retry)
                .buttonStyle(.borderedProminent)
        }
        .foregroundStyle(AppColors.foreground)
    }
}
