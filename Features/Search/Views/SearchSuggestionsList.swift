import SwiftUI

struct SearchSuggestionsList: View {
    let suggestions: [String]
    let onSelect: (String) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Suggestions")
                .font(AppFonts.headline.weight(.bold))
                .foregroundStyle(AppColors.foreground)
                .padding(.horizontal, SearchLayout.horizontalPadding)

            LazyVStack(alignment: .leading, spacing: 0) {
                ForEach(suggestions, id: \.self) { suggestion in
                    Button {
                        onSelect(suggestion)
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: "magnifyingglass")
                                .foregroundStyle(AppColors.secondaryText)
                                .frame(width: 22)

                            Text(suggestion)
                                .font(AppFonts.body)
                                .foregroundStyle(AppColors.foreground)

                            Spacer()
                        }
                        .padding(.horizontal, SearchLayout.horizontalPadding)
                        .frame(height: 44)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}
