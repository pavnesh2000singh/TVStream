import CoreGraphics
import Foundation

enum AppConstants {
    enum App {
        static let name = "TVStream"
    }

    enum Layout {
        static let spacing: CGFloat = 16
        static let cornerRadius: CGFloat = 8
        static let contentMaxWidth: CGFloat = 1_200
    }

    enum Networking {
        static let requestTimeout: TimeInterval = 30
    }
}
