import SwiftUI

struct CastSection: View {
    let cast: [CastMember]

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeader(title: "Cast")

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 14) {
                    ForEach(cast) { member in
                        CastMemberCard(member: member)
                    }
                }
                .padding(.horizontal, MovieDetailsLayout.horizontalPadding)
            }
        }
    }
}

private struct CastMemberCard: View {
    let member: CastMember

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack {
                LinearGradient(
                    colors: [
                        Color(hex: member.artworkStyle.primaryHexColor),
                        Color(hex: member.artworkStyle.secondaryHexColor)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )

                Image(systemName: member.artworkStyle.symbolName)
                    .font(.system(size: 34, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.82))
            }
            .frame(width: 112, height: 112)
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))

            Text(member.name)
                .font(AppFonts.caption.weight(.semibold))
                .foregroundStyle(AppColors.foreground)
                .lineLimit(1)

            Text(member.role)
                .font(.caption2)
                .foregroundStyle(AppColors.secondaryText)
                .lineLimit(1)
        }
        .frame(width: 112, alignment: .leading)
    }
}
