import SwiftUI

struct MovieDescriptionSection: View {
    let movie: StreamContent

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(movie.description)
                .font(AppFonts.body)
                .foregroundStyle(AppColors.foreground.opacity(0.9))
                .lineSpacing(3)
                .frame(maxWidth: 760, alignment: .leading)

            if !movie.cast.isEmpty {
                Text("Cast: \(movie.cast.joined(separator: ", "))")
                    .font(AppFonts.caption)
                    .foregroundStyle(AppColors.secondaryText)
                    .lineLimit(2)
            }
        }
        .padding(.horizontal, MovieDetailsLayout.horizontalPadding)
    }
}
