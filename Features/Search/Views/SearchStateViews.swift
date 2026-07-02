import SwiftUI

struct SearchLoadingGrid: View {
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
        LazyVGrid(columns: columns, alignment: .leading, spacing: 20) {
            ForEach(0..<8, id: \.self) { _ in
                VStack(alignment: .leading, spacing: 8) {
                    RoundedRectangle(cornerRadius: HomeLayout.cardCornerRadius)
                        .fill(AppColors.foreground.opacity(0.08))
                        .frame(width: HomeLayout.cardWidth, height: HomeLayout.cardHeight)

                    RoundedRectangle(cornerRadius: 4)
                        .fill(AppColors.foreground.opacity(0.1))
                        .frame(width: 120, height: 14)

                    RoundedRectangle(cornerRadius: 4)
                        .fill(AppColors.foreground.opacity(0.08))
                        .frame(width: 80, height: 12)
                }
            }
        }
        .padding(.horizontal, SearchLayout.horizontalPadding)
        .redacted(reason: .placeholder)
    }
}

struct SearchEmptyView: View {
    let query: String

    var body: some View {
        ContentUnavailableView(
            "No results",
            systemImage: "magnifyingglass",
            description: Text("No matches found for \"\(query)\".")
        )
        .foregroundStyle(AppColors.foreground)
        .frame(maxWidth: .infinity)
        .padding(.top, 48)
    }
}

struct SearchErrorView: View {
    let message: String

    var body: some View {
        ContentUnavailableView(
            "Search unavailable",
            systemImage: "wifi.exclamationmark",
            description: Text(message)
        )
        .foregroundStyle(AppColors.foreground)
        .frame(maxWidth: .infinity)
        .padding(.top, 48)
    }
}
