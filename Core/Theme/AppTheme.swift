import SwiftUI

struct AppTheme {
    let colors: AppColorPalette
    let fonts: AppFontSet

    static let standard = AppTheme(
        colors: .standard,
        fonts: .standard
    )
}

struct AppColorPalette {
    let background: Color
    let foreground: Color
    let secondaryText: Color
    let accent: Color

    static let standard = AppColorPalette(
        background: AppColors.background,
        foreground: AppColors.foreground,
        secondaryText: AppColors.secondaryText,
        accent: AppColors.accent
    )
}

struct AppFontSet {
    let title: Font
    let headline: Font
    let body: Font
    let caption: Font

    static let standard = AppFontSet(
        title: AppFonts.title,
        headline: AppFonts.headline,
        body: AppFonts.body,
        caption: AppFonts.caption
    )
}
