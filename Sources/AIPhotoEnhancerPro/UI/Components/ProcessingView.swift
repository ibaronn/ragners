import SwiftUI

struct ProcessingView: View {
    let progress: Float
    let stage: HomeViewState.ProcessingStage

    @State private var isAnimating = false

    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .stroke(Color(.systemGray5), lineWidth: 6)
                    .frame(width: 80, height: 80)

                Circle()
                    .trim(from: 0, to: CGFloat(min(progress, 1.0)))
                    .stroke(
                        LinearGradient(
                            colors: [.accentColor, .accentColor.opacity(0.6)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: 6, lineCap: .round)
                    )
                    .frame(width: 80, height: 80)
                    .rotationEffect(.degrees(-90))
                    .animation(.spring(response: 0.4), value: progress)

                if progress < 1.0 {
                    ProgressView()
                        .scaleEffect(1.2)
                        .tint(.accentColor)
                } else {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title)
                        .foregroundStyle(.green)
                }
            }

            Text(stageText)
                .font(.subheadline)
                .fontWeight(.medium)

            Text("\(Int(progress * 100))%")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(24)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))
    }

    private var stageText: String {
        switch stage {
        case .idle: return "Ready"
        case .loading: return "Loading image..."
        case .denoising: return "Reducing noise..."
        case .upscaling: return "Upscaling image..."
        case .colorEnhancement: return "Enhancing colors..."
        case .faceEnhancement: return "Enhancing faces..."
        case .sharpening: return "Sharpening details..."
        case .saving: return "Saving result..."
        case .completed: return "Enhancement complete!"
        case .failed(let reason): return "Failed: \(reason)"
        }
    }
}

#Preview {
    ProcessingView(progress: 0.65, stage: .colorEnhancement)
        .padding()
}
