import SwiftUI

struct MovieMetadataView: View {
    let movie: StreamContent

    var body: some View {
        HStack(spacing: 10) {
            Text(String(movie.year))
            Text(movie.rating)
            Text(movie.runtime)
            Text(movie.genres.joined(separator: " / "))
        }
        .font(AppFonts.caption.weight(.semibold))
        .foregroundStyle(AppColors.secondaryText)
        .lineLimit(2)
    }
}
