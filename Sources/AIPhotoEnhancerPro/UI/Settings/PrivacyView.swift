import SwiftUI

struct PrivacyView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                privacySection(
                    "Data Privacy",
                    "AI Photo Enhancer Pro processes all images entirely on your device. No image data is ever uploaded to any server or shared with third parties. Your photos remain completely private."
                )

                privacySection(
                    "Local Processing",
                    "All AI enhancement operations run locally using CoreML and Metal GPU acceleration. This ensures maximum privacy and allows the app to work offline."
                )

                privacySection(
                    "Data Collection",
                    "We do not collect any personal data, usage statistics, or analytics. The app does not include any tracking software or third-party analytics frameworks."
                )

                privacySection(
                    "Permissions",
                    "The app only requests necessary permissions:\n• Photo Library - to save enhanced images\n• Camera - to capture photos for enhancement\n• Files - to import images from files"
                )

                privacySection(
                    "Storage",
                    "Processed images are stored locally in the app's cache and can be cleared at any time from Settings. We do not have access to your stored images."
                )

                privacySection(
                    "Changes",
                    "This privacy policy may be updated. Changes will be reflected in the app's Settings page."
                )

                Text("Last updated: June 2026")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 16)
            }
            .padding()
        }
        .navigationTitle("Privacy Policy")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func privacySection(_ title: String, _ content: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)

            Text(content)
                .font(.body)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

#Preview {
    NavigationStack {
        PrivacyView()
    }
}
