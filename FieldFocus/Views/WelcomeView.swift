import SwiftUI

/// Home / Guide screen — mirrors the "Welcome to FieldFocus" Stitch screen.
struct WelcomeView: View {
    @EnvironmentObject var locationService: LocationService
    @EnvironmentObject var weatherService: WeatherService
    @EnvironmentObject var advisorService: PhotographyAdvisorService

    @State private var showLocationSearch = false
    @AppStorage("FieldFocus.isIndoorMode") private var isIndoorMode = false
    @State private var now = Date()

    private let clockTimer = Timer.publish(every: 30, on: .main, in: .common).autoconnect()

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                FieldFocusTheme.Color.background.ignoresSafeArea()

                VStack(spacing: 0) {
                    headerBar
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: FieldFocusTheme.Spacing.md) {
                            heroCard
                            statusGrid
                            locationButton
                            indoorModeButton
                        }
                        .padding(.horizontal, FieldFocusTheme.Spacing.pagePad)
                        .padding(.vertical, FieldFocusTheme.Spacing.md)
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showLocationSearch) {
                LocationSearchView()
            }
            .onReceive(clockTimer) { _ in now = Date() }
        }
    }

    // MARK: - Header
    private var headerBar: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("FieldFocus")
                    .font(FieldFocusTheme.Typography.headlineMD())
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                Text("PROFESSIONAL FIELD ASSISTANT")
                    .font(FieldFocusTheme.Typography.labelCaps())
                    .foregroundColor(.white.opacity(0.7))
                    .kerning(1)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 2) {
                Text(formattedTime)
                    .font(.system(size: 28, weight: .bold, design: .monospaced))
                    .foregroundColor(.white)
                Text(weatherService.snapshot.dayPhase.rawValue.uppercased())
                    .font(FieldFocusTheme.Typography.labelCaps())
                    .foregroundColor(.white.opacity(0.65))
                    .kerning(0.8)
            }
        }
        .padding(.horizontal, FieldFocusTheme.Spacing.pagePad)
        .padding(.vertical, FieldFocusTheme.Spacing.md)
        .background(FieldFocusTheme.Color.navyDark)
    }

    private var formattedTime: String {
        let fmt = DateFormatter()
        fmt.dateFormat = "H:mm"
        return fmt.string(from: now)
    }

    // MARK: - Hero card
    private var heroCard: some View {
        ZStack(alignment: .bottomLeading) {
            RoundedRectangle(cornerRadius: FieldFocusTheme.Radius.lg)
                .fill(
                    LinearGradient(
                        colors: [FieldFocusTheme.Color.navyMid, FieldFocusTheme.Color.navyDark],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(height: 200)

            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 4) {
                    conditionChip
                    Text(weatherService.snapshot.locationName)
                        .font(FieldFocusTheme.Typography.headlineSM())
                        .foregroundColor(.white)
                        .lineLimit(2)
                }
                Spacer()
                Image(systemName: weatherService.snapshot.condition.systemIcon)
                    .font(.system(size: 56))
                    .foregroundColor(FieldFocusTheme.Color.orange)
                    .symbolRenderingMode(.hierarchical)
            }
            .padding(FieldFocusTheme.Spacing.md)
        }
    }

    private var conditionChip: some View {
        HStack(spacing: 4) {
            Image(systemName: weatherService.snapshot.condition.systemIcon)
                .font(.system(size: 12))
            Text(weatherService.snapshot.condition.rawValue.uppercased())
                .font(FieldFocusTheme.Typography.labelCaps())
        }
        .foregroundColor(FieldFocusTheme.Color.navyDark)
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(FieldFocusTheme.Color.orange)
        .clipShape(Capsule())
    }

    // MARK: - Status grid
    private var statusGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: FieldFocusTheme.Spacing.sm) {
            StatusCard(
                icon: "sun.horizon.fill",
                label: "GOLDEN HOUR",
                value: nextGoldenHourText,
                tint: FieldFocusTheme.Color.orange
            )
            StatusCard(
                icon: weatherService.snapshot.condition.systemIcon,
                label: "CONDITIONS",
                value: weatherService.snapshot.condition.rawValue.uppercased(),
                tint: FieldFocusTheme.Color.navyDark
            )
            StatusCard(
                icon: "thermometer.medium",
                label: "COLOR TEMP",
                value: "\(weatherService.snapshot.temperatureKelvin)K",
                tint: FieldFocusTheme.Color.navyDark
            )
            StatusCard(
                icon: "wind",
                label: "WIND",
                value: "\(Int(weatherService.snapshot.windSpeedMPH))mph \(weatherService.snapshot.windDirectionCardinal)",
                tint: FieldFocusTheme.Color.navyDark
            )
        }
    }

    private var nextGoldenHourText: String {
        let fmt = DateFormatter()
        fmt.dateFormat = "H:mm"
        let n = now
        // Morning golden hour — show if it hasn't ended yet
        if let start = weatherService.snapshot.morningGoldenHourStart,
           let end = weatherService.snapshot.morningGoldenHourEnd,
           n < end {
            if n >= start { return "NOW ☀" }
            return "\(fmt.string(from: start))–\(fmt.string(from: end))"
        }
        // Evening golden hour — show if it hasn't ended yet
        if let start = weatherService.snapshot.goldenHourStart,
           let end = weatherService.snapshot.goldenHourEnd,
           n < end {
            if n >= start { return "NOW ☀" }
            return "\(fmt.string(from: start))–\(fmt.string(from: end))"
        }
        return "Tomorrow"
    }

    // MARK: - Location button
    private var locationButton: some View {
        Button {
            showLocationSearch = true
        } label: {
            HStack {
                Image(systemName: "mappin.and.ellipse")
                Text("Change Shooting Location")
                    .font(FieldFocusTheme.Typography.bodyMD())
                Spacer()
                Image(systemName: "chevron.right")
            }
            .foregroundColor(FieldFocusTheme.Color.orange)
            .padding(FieldFocusTheme.Spacing.md)
            .background(FieldFocusTheme.Color.surface)
            .cornerRadius(FieldFocusTheme.Radius.base)
            .overlay(
                RoundedRectangle(cornerRadius: FieldFocusTheme.Radius.base)
                    .stroke(FieldFocusTheme.Color.outline, lineWidth: 1)
            )
        }
    }

    // MARK: - Indoor mode toggle
    private var indoorModeButton: some View {
        Button {
            isIndoorMode.toggle()
        } label: {
            HStack {
                Image(systemName: isIndoorMode ? "house.fill" : "house")
                    .foregroundColor(isIndoorMode ? .white : FieldFocusTheme.Color.textSecondary)
                Text(isIndoorMode ? "Indoor Mode: ON" : "Indoor Mode")
                    .font(FieldFocusTheme.Typography.bodyMD())
                    .foregroundColor(isIndoorMode ? .white : FieldFocusTheme.Color.textSecondary)
                Spacer()
                Text(isIndoorMode ? "Ignoring weather & golden hour" : "Tap to activate")
                    .font(FieldFocusTheme.Typography.bodySM())
                    .foregroundColor(isIndoorMode ? .white.opacity(0.8) : FieldFocusTheme.Color.textSecondary)
            }
            .padding(FieldFocusTheme.Spacing.md)
            .background(isIndoorMode ? FieldFocusTheme.Color.navyDark : FieldFocusTheme.Color.surface)
            .cornerRadius(FieldFocusTheme.Radius.base)
            .overlay(
                RoundedRectangle(cornerRadius: FieldFocusTheme.Radius.base)
                    .stroke(isIndoorMode ? FieldFocusTheme.Color.navyMid : FieldFocusTheme.Color.outline, lineWidth: 1)
            )
        }
    }
}

// MARK: - Status Card component
private struct StatusCard: View {
    let icon: String
    let label: String
    let value: String
    let tint: Color

    var body: some View {
        VStack(alignment: .leading, spacing: FieldFocusTheme.Spacing.sm) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(tint)
                    .font(.system(size: 16, weight: .semibold))
                Spacer()
            }
            Text(label)
                .font(FieldFocusTheme.Typography.labelCaps())
                .foregroundColor(FieldFocusTheme.Color.textSecondary)
                .kerning(0.8)
            Text(value)
                .font(FieldFocusTheme.Typography.dataMono())
                .foregroundColor(FieldFocusTheme.Color.textPrimary)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .padding(FieldFocusTheme.Spacing.md)
        .background(FieldFocusTheme.Color.surface)
        .cornerRadius(FieldFocusTheme.Radius.base)
        .overlay(
            RoundedRectangle(cornerRadius: FieldFocusTheme.Radius.base)
                .stroke(FieldFocusTheme.Color.outline, lineWidth: 1)
        )
    }
}

#Preview {
    WelcomeView()
        .environmentObject(LocationService())
        .environmentObject(WeatherService())
        .environmentObject(PhotographyAdvisorService())
}
