import SwiftUI

struct OnboardingView: View {
    @Binding var showOnboarding: Bool
    @State private var currentPage = 0

    private let pages: [OnboardingPage] = [
        OnboardingPage(
            icon: "wand.and.stars",
            title: "AI-Powered Enhancement",
            description: "Transform your photos with professional-grade AI enhancement. Upscale, denoise, and enhance with a single tap."
        ),
        OnboardingPage(
            icon: "person.crop.rectangle",
            title: "Smart Portraits",
            description: "Advanced face enhancement technology brings out the best in every portrait with natural-looking results."
        ),
        OnboardingPage(
            icon: "moon.stars",
            title: "Night & Low Light",
            description: "Specialized algorithms reduce noise and bring out details in challenging lighting conditions."
        ),
        OnboardingPage(
            icon: "lock.shield.fill",
            title: "100% Private",
            description: "All processing happens on your device. Your photos never leave your iPhone."
        )
    ]

    var body: some View {
        ZStack {
            backgroundLayer

            VStack {
                TabView(selection: $currentPage) {
                    ForEach(pages.indices, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .indexViewStyle(.page(backgroundDisplayMode: .always))

                VStack(spacing: 16) {
                    if currentPage == pages.count - 1 {
                        Button(action: { showOnboarding = false }) {
                            Text("Get Started")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 54)
                                .background(
                                    LinearGradient(
                                        colors: [.accentColor, .accentColor.opacity(0.8)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .shadow(color: .accentColor.opacity(0.3), radius: 12, y: 6)
                        }
                        .transition(.scale.combined(with: .opacity))
                    } else {
                        Button(action: { showOnboarding = false }) {
                            Text("Skip")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 48)
            }
        }
    }

    private var backgroundLayer: some View {
        LinearGradient(
            colors: [
                Color(.systemBackground),
                Color.accentColor.opacity(0.08),
                Color(.systemBackground)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }
}

struct OnboardingPage: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let description: String
}

struct OnboardingPageView: View {
    let page: OnboardingPage

    @State private var isAnimating = false

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.accentColor.opacity(0.15), .accentColor.opacity(0.05)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 160, height: 160)

                Image(systemName: page.icon)
                    .font(.system(size: 64))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.accentColor, .accentColor.opacity(0.6)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            .scaleEffect(isAnimating ? 1.0 : 0.6)
            .opacity(isAnimating ? 1.0 : 0.0)

            VStack(spacing: 12) {
                Text(page.title)
                    .font(.title)
                    .fontWeight(.bold)

                Text(page.description)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.horizontal, 32)
            .offset(y: isAnimating ? 0 : 20)
            .opacity(isAnimating ? 1.0 : 0.0)

            Spacer()
            Spacer()
        }
        .onAppear {
            withAnimation(.spring(response: 0.7, dampingFraction: 0.8)) {
                isAnimating = true
            }
        }
        .onDisappear {
            isAnimating = false
        }
    }
}

#Preview {
    OnboardingView(showOnboarding: .constant(true))
}
