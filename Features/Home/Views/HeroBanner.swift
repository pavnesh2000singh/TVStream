import SwiftUI

struct HeroBanner: View {
    let content: StreamContent

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            PosterArtwork(content: content, aspectRatio: HomeLayout.heroAspectRatio)
                .frame(maxWidth: .infinity)
                .frame(minHeight: 360)
                .overlay(alignment: .bottom) {
                    LinearGradient(
                        colors: [
                            .clear,
                            AppColors.background.opacity(0.82),
                            AppColors.background
                        ],
                        startPoint: .center,
                        endPoint: .bottom
                    )
                    .frame(height: 180)
                }

            VStack(alignment: .leading, spacing: 10) {
                Text(content.title)
                    .font(.system(size: 42, weight: .bold, design: .default))
                    .foregroundStyle(AppColors.foreground)
                    .lineLimit(2)

                Text(content.subtitle)
                    .font(AppFonts.headline)
                    .foregroundStyle(AppColors.foreground.opacity(0.88))
                    .lineLimit(2)
                    .frame(maxWidth: 620, alignment: .leading)

                HStack(spacing: 10) {
                    Text(String(content.year))
                    Text(content.rating)
                    Text(content.genres.prefix(2).joined(separator: " / "))
                }
                .font(AppFonts.caption.weight(.semibold))
                .foregroundStyle(AppColors.secondaryText)
            }
            .padding(.horizontal, HomeLayout.horizontalPadding)
            .padding(.bottom, 30)
        }
        .accessibilityElement(children: .combine)
    }
}
