import SwiftUI

struct SearchKeywordChip: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(AppFonts.caption.weight(.semibold))
                .foregroundStyle(AppColors.foreground)
                .padding(.horizontal, 14)
                .frame(height: 36)
                .background(AppColors.foreground.opacity(0.1))
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}
