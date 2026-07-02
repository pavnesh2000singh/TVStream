import SwiftUI

struct HomeLoadingView: View {
    var body: some View {
        LazyVStack(alignment: .leading, spacing: 34) {
            RoundedRectangle(cornerRadius: 0)
                .fill(AppColors.foreground.opacity(0.08))
                .frame(height: 420)
                .overlay {
                    ProgressView()
                        .tint(AppColors.foreground)
                }

            ForEach(0..<4, id: \.self) { _ in
                VStack(alignment: .leading, spacing: 14) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(AppColors.foreground.opacity(0.12))
                        .frame(width: 160, height: 22)
                        .padding(.horizontal, HomeLayout.horizontalPadding)

                    LazyHStack(spacing: 14) {
                        ForEach(0..<5, id: \.self) { _ in
                            RoundedRectangle(cornerRadius: HomeLayout.cardCornerRadius)
                                .fill(AppColors.foreground.opacity(0.08))
                                .frame(width: HomeLayout.cardWidth, height: HomeLayout.cardHeight)
                        }
                    }
                    .padding(.horizontal, HomeLayout.horizontalPadding)
                }
            }
        }
    }
}

struct HomeEmptyView: View {
    var body: some View {
        ContentUnavailableView(
            "No titles available",
            systemImage: "play.slash",
            description: Text("New movies and shows will appear here when they are available.")
        )
        .foregroundStyle(AppColors.foreground)
    }
}

struct HomeErrorView: View {
    let message: String
    let retry: () -> Void

    var body: some View {
        ContentUnavailableView {
            Label("Unable to load Home", systemImage: "wifi.exclamationmark")
        } description: {
            Text(message)
        } actions: {
            Button("Retry", action: retry)
                .buttonStyle(.borderedProminent)
        }
        .foregroundStyle(AppColors.foreground)
    }
}
