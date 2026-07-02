import SwiftUI

struct SectionHeader: View {
    let title: String

    var body: some View {
        HStack {
            Text(title)
                .font(AppFonts.headline.weight(.bold))
                .foregroundStyle(AppColors.foreground)

            Spacer()
        }
        .padding(.horizontal, HomeLayout.horizontalPadding)
    }
}
