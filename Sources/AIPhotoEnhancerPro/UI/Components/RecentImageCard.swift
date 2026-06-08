import SwiftUI

struct RecentImageCard: View {
    let image: ProcessedImage

    @State private var thumbnailImage: UIImage?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Group {
                if let uiImage = thumbnailImage {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } else {
                    Color(.systemGray6)
                        .overlay {
                            Image(systemName: "photo")
                                .font(.title2)
                                .foregroundStyle(.tertiary)
                        }
                }
            }
            .frame(width: 140, height: 140)
            .clipShape(RoundedRectangle(cornerRadius: 16))

            VStack(alignment: .leading, spacing: 2) {
                Text(image.mode.displayName)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .lineLimit(1)

                Text(image.createdAt, style: .date)
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
            .padding(.horizontal, 4)
        }
        .frame(width: 140)
        .task {
            await loadThumbnail()
        }
    }

    private func loadThumbnail() async {
        guard thumbnailImage == nil else { return }
        if let data = try? Data(contentsOf: image.thumbnailURL) {
            thumbnailImage = UIImage(data: data)
        }
    }
}

#Preview {
    RecentImageCard(
        image: ProcessedImage(
            originalURL: URL(string: "file:///test")!,
            processedURL: URL(string: "file:///test")!,
            thumbnailURL: URL(string: "file:///test")!,
            mode: .standard
        )
    )
    .padding()
}
