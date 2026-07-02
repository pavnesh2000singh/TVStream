import SwiftUI

struct MovieCard: View {
    @Environment(AppRouter.self) private var router
    let content: StreamContent

    var body: some View {
        Button {
            router.navigate(to: .movieDetails(id: content.id))
        } label: {
            VStack(alignment: .leading, spacing: 8) {
                PosterArtwork(content: content, aspectRatio: HomeLayout.cardAspectRatio)
                    .frame(width: HomeLayout.cardWidth, height: HomeLayout.cardHeight)
                    .clipShape(RoundedRectangle(cornerRadius: HomeLayout.cardCornerRadius, style: .continuous))
                    .overlay(alignment: .bottom) {
                        if let progress = content.progress {
                            ProgressView(value: progress)
                                .tint(.red)
                                .progressViewStyle(.linear)
                                .padding(.horizontal, 8)
                                .padding(.bottom, 8)
                        }
                    }

                Text(content.title)
                    .font(AppFonts.caption.weight(.semibold))
                    .foregroundStyle(AppColors.foreground)
                    .lineLimit(2)
                    .frame(width: HomeLayout.cardWidth, alignment: .leading)

                Text(content.genres.first ?? content.rating)
                    .font(.caption2)
                    .foregroundStyle(AppColors.secondaryText)
                    .lineLimit(1)
                    .frame(width: HomeLayout.cardWidth, alignment: .leading)
            }
            .scaleEffect(1)
            .animation(.smooth(duration: 0.2), value: content.id)
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(content.title), \(content.rating)")
    }
}
