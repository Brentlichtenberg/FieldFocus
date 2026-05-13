import SwiftUI

/// FieldFocus design system — matches the Stitch design (Navy + Orange, Metropolis-style).
enum FieldFocusTheme {

    // MARK: - Colors
    enum Color {
        /// Primary navy used for headers, navigation, structural elements.
        static let navyDark    = SwiftUI.Color(hex: "#1A3A5E")
        static let navyMid     = SwiftUI.Color(hex: "#1D3D62")
        static let navyText    = SwiftUI.Color(hex: "#181C1E")

        /// Orange — the "action" color, CTAs, interactive elements.
        static let orange      = SwiftUI.Color(hex: "#FF6B00")
        static let orangeDim   = SwiftUI.Color(hex: "#A04100")

        /// Neutral surfaces.
        static let background  = SwiftUI.Color(hex: "#F7FAFD")
        static let surface     = SwiftUI.Color(hex: "#FFFFFF")
        static let surfaceLow  = SwiftUI.Color(hex: "#F1F4F7")
        static let surfaceMid  = SwiftUI.Color(hex: "#EBEEF1")
        static let outline     = SwiftUI.Color(hex: "#C5C6CD")

        /// Text variants.
        static let textPrimary   = SwiftUI.Color(hex: "#181C1E")
        static let textSecondary = SwiftUI.Color(hex: "#44474D")
        static let textOnDark    = SwiftUI.Color.white
    }

    // MARK: - Typography (geometric, Metropolis-inspired via rounded system font)
    enum Typography {
        static func headlineLG() -> SwiftUI.Font { .system(size: 32, weight: .bold, design: .rounded) }
        static func headlineMD() -> SwiftUI.Font { .system(size: 24, weight: .semibold, design: .rounded) }
        static func headlineSM() -> SwiftUI.Font { .system(size: 20, weight: .semibold, design: .rounded) }
        static func bodyLG()     -> SwiftUI.Font { .system(size: 18, weight: .regular) }
        static func bodyMD()     -> SwiftUI.Font { .system(size: 16, weight: .regular) }
        static func bodySM()     -> SwiftUI.Font { .system(size: 14, weight: .regular) }
        /// Monospaced for camera data values (ISO, aperture, shutter).
        static func dataMono()   -> SwiftUI.Font { .system(size: 14, weight: .medium, design: .monospaced) }
        /// Uppercase caps label.
        static func labelCaps()  -> SwiftUI.Font { .system(size: 12, weight: .bold, design: .rounded) }
    }

    // MARK: - Corner Radii (4px base, matches ROUND_FOUR in Stitch)
    enum Radius {
        static let sm:   CGFloat = 2
        static let base: CGFloat = 4
        static let md:   CGFloat = 6
        static let lg:   CGFloat = 8
        static let xl:   CGFloat = 12
        static let full: CGFloat = 9999
    }

    // MARK: - Spacing (8px grid)
    enum Spacing {
        static let unit: CGFloat  = 8
        static let sm:   CGFloat  = 8
        static let md:   CGFloat  = 16
        static let lg:   CGFloat  = 24
        static let xl:   CGFloat  = 32
        static let pagePad: CGFloat = 16
    }
}

// MARK: - Liquid Glass view modifier helpers (iOS 26+)
extension View {
    /// Replaces the standard `.background(surface) + .cornerRadius + .overlay(stroke)` card pattern.
    /// On iOS 26+ renders a native Liquid Glass surface; falls back to the existing card style below.
    @ViewBuilder
    func glassCard(cornerRadius: CGFloat = FieldFocusTheme.Radius.base) -> some View {
        if #available(iOS 26, *) {
            self.glassEffect(.regular, in: .rect(cornerRadius: cornerRadius))
        } else {
            self
                .background(FieldFocusTheme.Color.surface)
                .cornerRadius(cornerRadius)
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(FieldFocusTheme.Color.outline, lineWidth: 1)
                )
        }
    }

    /// Replaces tinted capsule chips/badges. On iOS 26+ renders an interactive glass capsule
    /// tinted with the given colour; falls back to a filled capsule.
    @ViewBuilder
    func glassChip(tint: SwiftUI.Color = FieldFocusTheme.Color.orange,
                   foreground: SwiftUI.Color = FieldFocusTheme.Color.navyDark) -> some View {
        if #available(iOS 26, *) {
            self
                .foregroundColor(foreground)
                .glassEffect(.regular.tint(tint).interactive(), in: .capsule)
        } else {
            self
                .foregroundColor(foreground)
                .background(tint)
                .clipShape(Capsule())
        }
    }
}

// MARK: - Color hex initializer
extension SwiftUI.Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:(a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB, red: Double(r)/255, green: Double(g)/255, blue: Double(b)/255, opacity: Double(a)/255)
    }
}
