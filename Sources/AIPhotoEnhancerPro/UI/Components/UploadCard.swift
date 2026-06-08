import SwiftUI
import UIKit

struct UploadCard: View {
    @Binding var selectedImage: Data?
    @Binding var processedImage: Data?
    let isProcessing: Bool
    let processingProgress: Float
    let processingStage: HomeViewState.ProcessingStage
    let onUpload: () -> Void
    let onReset: () -> Void

    @State private var isAnimating = false

    var body: some View {
        ZStack {
            if let imageData = processedImage ?? selectedImage {
                processedContentView(imageData)
            } else {
                uploadPromptView
            }
        }
        .frame(height: 320)
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 24))
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .strokeBorder(
                    LinearGradient(
                        colors: [.accentColor.opacity(0.3), .accentColor.opacity(0.1)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .shadow(color: .black.opacity(0.05), radius: 20, y: 8)
    }

    private var uploadPromptView: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.accentColor.opacity(0.15), .accentColor.opacity(0.05)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 88, height: 88)

                Image(systemName: "plus.viewfinder")
                    .font(.system(size: 36, weight: .medium))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.accentColor, .accentColor.opacity(0.6)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .scaleEffect(isAnimating ? 1.1 : 1.0)
                    .animation(
                        .easeInOut(duration: 1.5).repeatForever(autoreverses: true),
                        value: isAnimating
                    )
            }

            VStack(spacing: 6) {
                Text("Tap to Upload")
                    .font(.title3)
                    .fontWeight(.semibold)

                Text("Choose from library, camera, or files")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            HStack(spacing: 24) {
                uploadMethodIcon("photo.on.rectangle", "Library")
                uploadMethodIcon("camera.fill", "Camera")
                uploadMethodIcon("folder.fill", "Files")
            }
        }
        .padding()
        .onAppear { isAnimating = true }
        .onTapGesture(perform: onUpload)
    }

    private func uploadMethodIcon(_ icon: String, _ label: String) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(.secondary)
            Text(label)
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
    }

    private func processedContentView(_ imageData: Data) -> some View {
        ZStack(alignment: .topTrailing) {
            if let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 24))
            }

            if !isProcessing {
                Button(action: onReset) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundStyle(.white, .black.opacity(0.4))
                        .shadow(radius: 4)
                        .padding(12)
                }
            }
        }
    }
}

#Preview {
    UploadCard(
        selectedImage: .constant(nil),
        processedImage: .constant(nil),
        isProcessing: false,
        processingProgress: 0,
        processingStage: .idle,
        onUpload: {},
        onReset: {}
    )
    .padding()
}
