import SwiftUI

enum AppTheme {
    // MARK: - Colors
    static let background = Color(hex: 0x0B0B12)
    static let surface = Color(hex: 0x16161F)
    static let accent = Color(hex: 0x39FF88)
    static let accentSecondary = Color(hex: 0x9D6BFF)
    static let accentTertiary = Color(hex: 0xFFD24A)
    static let textPrimary = Color.white
    static let textSecondary = Color(hex: 0xB5B5C8)

    // MARK: - Typography
    static func headline(_ size: CGFloat = 28) -> Font {
        .system(size: size, weight: .bold, design: .rounded)
    }

    static func title(_ size: CGFloat = 20) -> Font {
        .system(size: size, weight: .semibold, design: .rounded)
    }

    static func body(_ size: CGFloat = 16) -> Font {
        .system(size: size, weight: .regular, design: .rounded)
    }

    static func caption(_ size: CGFloat = 13) -> Font {
        .system(size: size, weight: .medium, design: .rounded)
    }

    // MARK: - Layout
    static let cornerRadius: CGFloat = 16
    static let glowRadius: CGFloat = 12
}

extension Color {
    init(hex: UInt, opacity: Double = 1.0) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: opacity
        )
    }
}
