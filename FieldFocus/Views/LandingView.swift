import SwiftUI

struct LandingView: View {
    @Binding var hasCompletedOnboarding: Bool
    let onComplete: () -> Void

    @State private var navigateToLocation = false

    var body: some View {
        NavigationStack {
            ZStack {
                FieldFocusTheme.Color.navyDark.ignoresSafeArea()
                VStack(spacing: 0) {
                    heroSection
                    contentSection
                }
            }
            .navigationBarHidden(true)
            .navigationDestination(isPresented: $navigateToLocation) {
                OnboardingLocationView(
                    hasCompletedOnboarding: $hasCompletedOnboarding,
                    onComplete: onComplete
                )
            }
        }
    }

    // MARK: - Hero

    private var heroSection: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "#1F4070"), FieldFocusTheme.Color.navyDark],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea(edges: .top)

            // Decorative rings
            Circle()
                .strokeBorder(Color.white.opacity(0.04), lineWidth: 1)
                .frame(width: 300, height: 300)
                .offset(x: 80, y: -20)
            Circle()
                .strokeBorder(FieldFocusTheme.Color.orange.opacity(0.15), lineWidth: 1)
                .frame(width: 200, height: 200)
                .offset(x: 80, y: -20)

            // Ghost aperture
            Image(systemName: "camera.aperture")
                .font(.system(size: 160, weight: .thin))
                .foregroundColor(.white.opacity(0.06))
                .offset(x: 70)

            // Accent aperture
            Image(systemName: "camera.aperture")
                .font(.system(size: 72, weight: .light))
                .foregroundStyle(
                    LinearGradient(
                        colors: [FieldFocusTheme.Color.orange, FieldFocusTheme.Color.orange.opacity(0.5)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .offset(x: 70)

            // Wordmark at bottom-left
            VStack {
                Spacer()
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("PROFESSIONAL FIELD ASSISTANT")
                            .font(FieldFocusTheme.Typography.labelCaps())
                            .foregroundColor(FieldFocusTheme.Color.orange)
                            .kerning(1)
                        Text("FieldFocus")
                            .font(FieldFocusTheme.Typography.headlineLG())
                            .foregroundColor(.white)
                    }
                    Spacer()
                }
                .padding(.horizontal, FieldFocusTheme.Spacing.pagePad)
                .padding(.bottom, FieldFocusTheme.Spacing.lg)
            }

            // Bottom fade into content area
            LinearGradient(
                colors: [.clear, FieldFocusTheme.Color.navyDark.opacity(0.9)],
                startPoint: .center,
                endPoint: .bottom
            )
        }
        .frame(height: 320)
    }

    // MARK: - Content

    private var contentSection: some View {
        VStack(alignment: .leading, spacing: FieldFocusTheme.Spacing.lg) {
            Text("The ultimate tactical toolkit for photographers who live for the golden hour and operate in the wild.")
                .font(FieldFocusTheme.Typography.bodyMD())
                .foregroundColor(.white.opacity(0.65))
                .lineSpacing(4)

            // Preview stat cards (static design values, replaced by live data after onboarding)
            LazyVGrid(
                columns: [GridItem(.flexible()), GridItem(.flexible())],
                spacing: FieldFocusTheme.Spacing.sm
            ) {
                statCard(icon: "sun.horizon.fill",     label: "GOLDEN HOUR", value: "18:42–19:15", tint: FieldFocusTheme.Color.orange)
                statCard(icon: "cloud.fill",            label: "CONDITIONS",  value: "OVERCAST",    tint: .white.opacity(0.5))
                statCard(icon: "mappin.fill",           label: "TOP SPOT",    value: "SET LOCATION", tint: .white.opacity(0.4))
                statCard(icon: "checkmark.shield.fill", label: "GEAR READY",  value: "100% CHECK",  tint: FieldFocusTheme.Color.orange)
            }

            Spacer()

            Button {
                navigateToLocation = true
            } label: {
                HStack(spacing: FieldFocusTheme.Spacing.sm) {
                    Spacer()
                    Text("Get Started")
                        .font(FieldFocusTheme.Typography.headlineSM())
                        .foregroundColor(.white)
                    Image(systemName: "arrow.right")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding(.vertical, FieldFocusTheme.Spacing.md)
                .background(FieldFocusTheme.Color.orange)
                .cornerRadius(FieldFocusTheme.Radius.lg)
            }
            .padding(.bottom, FieldFocusTheme.Spacing.xl)
        }
        .padding(.horizontal, FieldFocusTheme.Spacing.pagePad)
        .padding(.top, FieldFocusTheme.Spacing.lg)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(FieldFocusTheme.Color.navyDark)
    }

    private func statCard(icon: String, label: String, value: String, tint: Color) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundColor(tint)
                .frame(width: 20)
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(FieldFocusTheme.Typography.labelCaps())
                    .foregroundColor(.white.opacity(0.4))
                    .kerning(0.5)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                Text(value)
                    .font(FieldFocusTheme.Typography.dataMono())
                    .foregroundColor(.white.opacity(0.9))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(FieldFocusTheme.Spacing.sm)
        .background(.white.opacity(0.05))
        .cornerRadius(FieldFocusTheme.Radius.base)
    }
}

#Preview {
    LandingView(hasCompletedOnboarding: .constant(false), onComplete: {})
        .environmentObject(LocationService())
}
