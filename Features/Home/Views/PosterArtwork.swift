import SwiftUI

struct PosterArtwork: View {
    let content: StreamContent
    let aspectRatio: CGFloat

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(hex: content.artworkStyle.primaryHexColor),
                    Color(hex: content.artworkStyle.secondaryHexColor)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            Image(systemName: content.artworkStyle.symbolName)
                .font(.system(size: 58, weight: .semibold))
                .foregroundStyle(.white.opacity(0.78))
                .shadow(radius: 16)

            VStack {
                Spacer()

                LinearGradient(
                    colors: [.clear, .black.opacity(0.68)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 120)
            }
        }
        .aspectRatio(aspectRatio, contentMode: .fill)
        .clipped()
    }
}
