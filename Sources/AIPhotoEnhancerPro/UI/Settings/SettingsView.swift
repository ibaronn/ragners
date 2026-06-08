import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var viewModel: SettingsViewModel
    @State private var showingClearCacheAlert = false
    @State private var showingResetAlert = false

    var body: some View {
        NavigationStack {
            List {
                appearanceSection
                aiSection
                exportSection
                storageSection
                aboutSection
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .alert("Clear Cache?", isPresented: $showingClearCacheAlert) {
                Button("Clear", role: .destructive) { viewModel.clearCache() }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This will remove all cached images. Cache size: \(viewModel.cacheSize)")
            }
            .alert("Reset Settings?", isPresented: $showingResetAlert) {
                Button("Reset", role: .destructive) { viewModel.resetAllSettings() }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("All settings will be restored to defaults.")
            }
        }
    }

    private var appearanceSection: some View {
        Section("Appearance") {
            Picker("Theme", selection: Binding(
                get: { viewModel.settings.theme },
                set: { viewModel.updateTheme($0) }
            )) {
                ForEach(ThemeMode.allCases) { mode in
                    HStack {
                        Image(systemName: mode == .system ? "circle.lefthalf.fill" : mode == .light ? "sun.max.fill" : "moon.fill")
                            .foregroundStyle(.accent)
                        Text(mode.displayName)
                    }
                    .tag(mode)
                }
            }

            Toggle(isOn: Binding(
                get: { viewModel.settings.hapticFeedbackEnabled },
                set: { _ in viewModel.toggleHaptics() }
            )) {
                Label("Haptic Feedback", systemImage: "hand.tap.fill")
            }
        }
    }

    private var aiSection: some View {
        Section("AI Processing") {
            Picker("Quality", selection: Binding(
                get: { viewModel.settings.aiQuality },
                set: { viewModel.updateAIQuality($0) }
            )) {
                ForEach(AIQuality.allCases) { quality in
                    VStack(alignment: .leading) {
                        Text(quality.displayName)
                        Text(quality.description)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .tag(quality)
                }
            }
        }
    }

    private var exportSection: some View {
        Section("Export") {
            Picker("Format", selection: Binding(
                get: { viewModel.settings.exportFormat },
                set: { viewModel.updateExportFormat($0) }
            )) {
                ForEach(ExportFormat.allCases) { format in
                    Text(format.displayName).tag(format)
                }
            }

            VStack(spacing: 8) {
                HStack {
                    Label("Quality", systemImage: "photo.badge.arrow.down")
                    Spacer()
                    Text("\(Int(viewModel.settings.exportQuality * 100))%")
                        .foregroundStyle(.secondary)
                }

                Slider(
                    value: Binding(
                        get: { viewModel.settings.exportQuality },
                        set: { viewModel.updateExportQuality($0) }
                    ),
                    in: 0.5...1.0,
                    step: 0.05
                )
                .tint(.accentColor)
            }

            Toggle(isOn: Binding(
                get: { viewModel.settings.autoSaveToPhotos },
                set: { _ in viewModel.toggleAutoSave() }
            )) {
                Label("Auto-save to Photos", systemImage: "photo.badge.plus")
            }
        }
    }

    private var storageSection: some View {
        Section("Storage") {
            HStack {
                Label("Cache Size", systemImage: "internaldrive")
                Spacer()
                Text(viewModel.cacheSize)
                    .foregroundStyle(.secondary)
            }

            Button(role: .destructive) {
                showingClearCacheAlert = true
            } label: {
                Label("Clear Cache", systemImage: "trash")
            }
        }
    }

    private var aboutSection: some View {
        Section("About") {
            HStack {
                Label("Version", systemImage: "info.circle")
                Spacer()
                Text(viewModel.appVersion)
                    .foregroundStyle(.secondary)
            }

            NavigationLink {
                AboutView()
            } label: {
                Label("About AI Photo Enhancer", systemImage: "wand.and.stars")
            }

            NavigationLink {
                PrivacyView()
            } label: {
                Label("Privacy Policy", systemImage: "hand.raised.fill")
            }

            Button(role: .destructive) {
                showingResetAlert = true
            } label: {
                Label("Reset All Settings", systemImage: "arrow.counterclockwise")
            }
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(SettingsViewModel())
}
