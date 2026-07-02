import SwiftUI

struct SearchKeywordSection: View {
    let title: String
    let keywords: [String]
    var showsClearButton = false
    var onClear: (() -> Void)?
    let onSelect: (String) -> Void

    var body: some View {
        if !keywords.isEmpty {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(title)
                        .font(AppFonts.headline.weight(.bold))
                        .foregroundStyle(AppColors.foreground)

                    Spacer()

                    if showsClearButton, let onClear {
                        Button("Clear", action: onClear)
                            .font(AppFonts.caption.weight(.semibold))
                    }
                }
                .padding(.horizontal, SearchLayout.horizontalPadding)

                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 10) {
                        ForEach(keywords, id: \.self) { keyword in
                            SearchKeywordChip(title: keyword) {
                                onSelect(keyword)
                            }
                        }
                    }
                    .padding(.horizontal, SearchLayout.horizontalPadding)
                }
            }
        }
    }
}
