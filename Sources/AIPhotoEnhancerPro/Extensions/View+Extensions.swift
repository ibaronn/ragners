import SwiftUI
import UIKit

public extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }

    func glassBackground() -> some View {
        self.background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }

    func gradientForeground(_ colors: [Color]) -> some View {
        self.foregroundStyle(
            LinearGradient(
                colors: colors,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }

    func glow(_ color: Color = .accentColor, radius: CGFloat = 8) -> some View {
        self.shadow(color: color.opacity(0.3), radius: radius)
    }
}

public struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    public func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

public extension Color {
    static var accent: Color {
        Color.accentColor
    }
}
