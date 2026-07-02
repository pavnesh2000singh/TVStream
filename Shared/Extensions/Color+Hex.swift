import SwiftUI

extension Color {
    init(hex: String) {
        let trimmedHex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var value: UInt64 = 0
        Scanner(string: trimmedHex).scanHexInt64(&value)

        let red: Double
        let green: Double
        let blue: Double
        let alpha: Double

        switch trimmedHex.count {
        case 6:
            red = Double((value & 0xFF0000) >> 16) / 255
            green = Double((value & 0x00FF00) >> 8) / 255
            blue = Double(value & 0x0000FF) / 255
            alpha = 1
        case 8:
            alpha = Double((value & 0xFF000000) >> 24) / 255
            red = Double((value & 0x00FF0000) >> 16) / 255
            green = Double((value & 0x0000FF00) >> 8) / 255
            blue = Double(value & 0x000000FF) / 255
        default:
            red = 0
            green = 0
            blue = 0
            alpha = 1
        }

        self.init(.sRGB, red: red, green: green, blue: blue, opacity: alpha)
    }
}
