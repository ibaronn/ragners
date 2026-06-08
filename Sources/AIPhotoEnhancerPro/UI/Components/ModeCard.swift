import SwiftUI

struct ModeCard: View {
    let mode: EnhancementMode
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(isSelected ? Color.accentColor : Color(.systemGray6))
                        .frame(width: 44, height: 44)

                    Image(systemName: mode.iconName)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(isSelected ? .white : .primary)
                }

                Text(mode.displayName)
                    .font(.caption2)
                    .fontWeight(isSelected ? .semibold : .regular)
                    .lineLimit(1)

                Text(mode.description)
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
                    .lineLimit(1)
            }
            .frame(width: 88)
            .padding(.vertical, 12)
            .padding(.horizontal, 8)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? Color.accentColor.opacity(0.1) : Color(.systemGray6).opacity(0.5))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(isSelected ? Color.accentColor : Color.clear, lineWidth: 1.5)
                    )
            )
        }
        .buttonStyle(.plain)
        .scaleEffect(isSelected ? 1.02 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

#Preview {
    HStack {
        ModeCard(mode: .standard, isSelected: true, action: {})
        ModeCard(mode: .ultraHD, isSelected: false, action: {})
        ModeCard(mode: .portrait, isSelected: false, action: {})
    }
    .padding()
}
