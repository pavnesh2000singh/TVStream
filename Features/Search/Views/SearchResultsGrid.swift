import SwiftUI

struct SearchResultsGrid: View {
    let results: [StreamContent]

    private var columns: [GridItem] {
        [
            GridItem(
                .adaptive(minimum: SearchLayout.resultMinWidth, maximum: HomeLayout.cardWidth),
                spacing: SearchLayout.gridSpacing,
                alignment: .top
            )
        ]
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeader(title: "Results")

            LazyVGrid(columns: columns, alignment: .leading, spacing: 20) {
                ForEach(results) { result in
                    MovieCard(content: result)
                }
            }
            .padding(.horizontal, SearchLayout.horizontalPadding)
            .transition(.opacity.combined(with: .move(edge: .bottom)))
        }
        .animation(.smooth(duration: 0.24), value: results)
    }
}
