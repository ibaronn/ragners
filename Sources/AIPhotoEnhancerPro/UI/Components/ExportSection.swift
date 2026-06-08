import SwiftUI
import UIKit
import Photos

struct ExportSection: View {
    let processedImage: Data
    let onReset: () -> Void

    @State private var showShareSheet = false
    @State private var exportFormat: ExportFormat = .jpeg
    @State private var showSuccessToast = false
    @State private var toastMessage = ""

    var body: some View {
        VStack(spacing: 16) {
            Text("Result")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)

            formatPicker

            HStack(spacing: 12) {
                exportButton(
                    title: "Share",
                    icon: "square.and.arrow.up",
                    action: { showShareSheet = true }
                )

                exportButton(
                    title: "Save to Photos",
                    icon: "photo.badge.plus",
                    action: saveToPhotos
                )
            }

            resetButton
        }
        .sheet(isPresented: $showShareSheet) {
            ShareSheet(items: [UIImage(data: processedImage) ?? UIImage()])
        }
        .overlay(alignment: .bottom) {
            toastOverlay
        }
    }

    private var formatPicker: some View {
        Picker("Format", selection: $exportFormat) {
            ForEach(ExportFormat.allCases) { format in
                Text(format.displayName).tag(format)
            }
        }
        .pickerStyle(.segmented)
    }

    private func exportButton(title: String, icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(.accent)
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .buttonStyle(.plain)
    }

    private var resetButton: some View {
        Button(action: onReset) {
            Text("Enhance Another Image")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    private var toastOverlay: some View {
        Group {
            if showSuccessToast {
                Text(toastMessage)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(.ultraThinMaterial, in: Capsule())
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .padding(.bottom, 32)
            }
        }
    }

    private func saveToPhotos() {
        PHPhotoLibrary.requestAuthorization { status in
            guard status == .authorized || status == .limited else {
                showToast("Photos access denied")
                return
            }

            PHPhotoLibrary.shared().performChanges {
                let creationRequest = PHAssetCreationRequest.forAsset()
                let options = PHAssetResourceCreationOptions()
                let data: Data
                let uiImage = UIImage(data: processedImage) ?? UIImage()

                switch exportFormat {
                case .png:
                    data = uiImage.pngData() ?? processedImage
                case .jpeg:
                    data = uiImage.jpegData(compressionQuality: 0.95) ?? processedImage
                case .heic:
                    data = uiImage.heicData(compressionQuality: 0.95) ?? processedImage
                }

                creationRequest.addResource(with: .photo, data: data, options: options)
            } completionHandler: { success, error in
                Task { @MainActor in
                    if success {
                        showToast("Saved to Photos")
                    } else {
                        showToast(error?.localizedDescription ?? "Failed to save")
                    }
                }
            }
        }
    }

    private func showToast(_ message: String) {
        withAnimation(.spring) {
            toastMessage = message
            showSuccessToast = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation(.spring) {
                showSuccessToast = false
            }
        }
    }
}

#Preview {
    ExportSection(processedImage: Data(), onReset: {})
        .padding()
}
