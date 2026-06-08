import SwiftUI
import PhotosUI
import UniformTypeIdentifiers

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var showCamera = false
    @State private var showPhotoPicker = false
    @State private var showFilePicker = false
    @State private var showImagePickerOptions = false
    @State private var photoPickerItem: PhotosPickerItem?
    @State private var dragOver = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    headerSection
                    uploadSection
                    modeSelectorSection
                    processingSection
                    recentImagesSection
                }
                .padding(.horizontal)
                .padding(.vertical, 16)
            }
            .background(backgroundGradient)
            .navigationTitle("AI Enhancer")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    settingsButton
                }
            }
            .confirmationDialog("Import Image", isPresented: $showImagePickerOptions) {
                Button("Photo Library") { showPhotoPicker = true }
                Button("Camera") { showCamera = true }
                Button("Files") { showFilePicker = true }
                Button("Cancel", role: .cancel) {}
            }
            .sheet(isPresented: $showCamera) {
                CameraView(imageData: $viewModel.state.selectedImage)
                    .ignoresSafeArea()
            }
            .sheet(isPresented: $showFilePicker) {
                DocumentPicker(imageData: $viewModel.state.selectedImage)
            }
            .photosPicker(
                isPresented: $showPhotoPicker,
                selection: $photoPickerItem,
                matching: .images
            )
            .onChange(of: photoPickerItem) { _, item in
                loadPhotoPickerItem(item)
            }
            .alert("Error", isPresented: $viewModel.state.showError) {
                Button("OK") { viewModel.dismissError() }
                if let recovery = viewModel.state.error?.recoveryMessage {
                    Button(recovery) { viewModel.dismissError() }
                }
            } message: {
                Text(viewModel.state.error?.localizedDescription ?? "")
            }
            .onDrop(of: [.image], isTargeted: $dragOver) { providers in
                handleDrop(providers)
                return true
            }
            .overlay {
                if dragOver {
                    dragOverlay
                }
            }
        }
    }

    private var headerSection: some View {
        VStack(spacing: 4) {
            Text("Transform Your Photos")
                .font(.title2)
                .fontWeight(.semibold)

            Text("AI-powered enhancement for stunning results")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 8)
    }

    private var uploadSection: some View {
        UploadCard(
            selectedImage: $viewModel.state.selectedImage,
            processedImage: $viewModel.state.processedImage,
            isProcessing: viewModel.state.isProcessing,
            processingProgress: viewModel.state.processingProgress,
            processingStage: viewModel.state.processingStage,
            onUpload: { showImagePickerOptions = true },
            onReset: { viewModel.resetImage() }
        )
    }

    private var modeSelectorSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Enhancement Mode")
                .font(.headline)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(EnhancementMode.allCases) { mode in
                        ModeCard(
                            mode: mode,
                            isSelected: viewModel.state.selectedMode == mode,
                            action: { viewModel.setMode(mode) }
                        )
                    }
                }
                .padding(.horizontal, 2)
            }
        }
    }

    @ViewBuilder
    private var processingSection: some View {
        if viewModel.state.selectedImage != nil && viewModel.state.processedImage == nil {
            ProcessButton(
                isProcessing: viewModel.state.isProcessing,
                action: {
                    Task {
                        if let data = viewModel.state.selectedImage {
                            await viewModel.processImageWithProgress(data)
                        }
                    }
                }
            )
        }

        if viewModel.state.isProcessing {
            ProcessingView(
                progress: viewModel.state.processingProgress,
                stage: viewModel.state.processingStage
            )
        }

        if let processed = viewModel.state.processedImage {
            ExportSection(
                processedImage: processed,
                onReset: { viewModel.resetImage() }
            )
        }
    }

    private var recentImagesSection: some View {
        Group {
            if !viewModel.state.recentImages.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Recent Enhancements")
                        .font(.headline)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(viewModel.state.recentImages) { image in
                                RecentImageCard(image: image)
                            }
                        }
                        .padding(.horizontal, 2)
                    }
                }
            }
        }
    }

    private var settingsButton: some View {
        Button {
            viewModel.toggleSettings()
        } label: {
            Image(systemName: "gearshape.fill")
                .font(.title3)
                .foregroundStyle(.primary)
        }
    }

    private var dragOverlay: some View {
        ZStack {
            Color.accentColor.opacity(0.1)
                .ignoresSafeArea()

            VStack(spacing: 16) {
                Image(systemName: "arrow.down.doc.fill")
                    .font(.system(size: 48))
                    .foregroundStyle(.accent)
                Text("Drop Image Here")
                    .font(.title2)
                    .fontWeight(.semibold)
            }
            .padding(40)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 24))
        }
    }

    private var backgroundGradient: some View {
        LinearGradient(
            colors: [
                Color(.systemBackground),
                Color.accentColor.opacity(0.03),
                Color(.systemBackground)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }

    private func loadPhotoPickerItem(_ item: PhotosPickerItem?) {
        guard let item else { return }
        Task {
            if let data = try? await item.loadTransferable(type: Data.self) {
                viewModel.selectImage(data)
            }
        }
    }

    private func handleDrop(_ providers: [NSItemProvider]) -> Bool {
        guard let provider = providers.first else { return false }
        provider.loadDataRepresentation(forTypeIdentifier: UTType.image.identifier) { data, error in
            if let data {
                Task { @MainActor in
                    viewModel.selectImage(data)
                }
            }
        }
        return true
    }
}

#Preview {
    HomeView()
}
