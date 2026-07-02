import SwiftUI

struct SimilarMoviesSection: View {
    let movies: [StreamContent]

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeader(title: "Similar Movies")

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(alignment: .top, spacing: 14) {
                    ForEach(movies) { movie in
                        MovieCard(content: movie)
                    }
                }
                .padding(.horizontal, MovieDetailsLayout.horizontalPadding)
            }
        }
    }
}
