import SwiftUI

struct ContentRail: View {
    let section: ContentSection

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeader(title: section.title)

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(alignment: .top, spacing: 14) {
                    ForEach(section.items) { item in
                        MovieCard(content: item)
                    }
                }
                .padding(.horizontal, HomeLayout.horizontalPadding)
            }
        }
    }
}
