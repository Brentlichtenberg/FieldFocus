import SwiftUI

/// "Shooting Advice" screen — mirrors the Stitch "Shooting Advice" design.
struct ShootingAdviceView: View {
    @EnvironmentObject var weatherService: WeatherService
    @EnvironmentObject var advisorService: PhotographyAdvisorService

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                FieldFocusTheme.Color.background.ignoresSafeArea()

                VStack(spacing: 0) {
                    headerBar
                    if weatherService.isLoading {
                        Spacer()
                        ProgressView("Fetching conditions…")
                            .tint(FieldFocusTheme.Color.orange)
                        Spacer()
                    } else {
                        ScrollView(showsIndicators: false) {
                            VStack(spacing: FieldFocusTheme.Spacing.md) {
                                conditionHeader
                                lightWindowCard
                                cameraSettingsCard
                                technicalAnalysisCard
                                tipsRow
                            }
                            .padding(.horizontal, FieldFocusTheme.Spacing.pagePad)
                            .padding(.vertical, FieldFocusTheme.Spacing.md)
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }

    // MARK: - Header
    private var headerBar: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("SHOOTING ADVICE")
                    .font(FieldFocusTheme.Typography.labelCaps())
                    .foregroundColor(.white.opacity(0.7))
                    .kerning(1)
                Text("Olympus Stylus 1s")
                    .font(FieldFocusTheme.Typography.headlineSM())
                    .foregroundColor(.white)
            }
            Spacer()
            Image(systemName: weatherService.snapshot.condition.systemIcon)
                .font(.system(size: 28))
                .foregroundColor(FieldFocusTheme.Color.orange)
                .symbolRenderingMode(.hierarchical)
        }
        .padding(.horizontal, FieldFocusTheme.Spacing.pagePad)
        .padding(.vertical, FieldFocusTheme.Spacing.md)
        .background(FieldFocusTheme.Color.navyDark)
    }

    // MARK: - Condition header card
    private var conditionHeader: some View {
        VStack(alignment: .leading, spacing: FieldFocusTheme.Spacing.sm) {
            HStack {
                conditionBadge(weatherService.snapshot.condition)
                Spacer()
                VStack(alignment: .trailing, spacing: 2) {
                    Text("\(weatherService.snapshot.temperatureKelvin)K")
                        .font(FieldFocusTheme.Typography.dataMono())
                        .foregroundColor(FieldFocusTheme.Color.orange)
                    Text("Color Temp")
                        .font(FieldFocusTheme.Typography.bodySM())
                        .foregroundColor(FieldFocusTheme.Color.textSecondary)
                }
            }
            Text(advisorService.advice.lightQualityDescription)
                .font(FieldFocusTheme.Typography.bodySM())
                .foregroundColor(FieldFocusTheme.Color.textSecondary)
                .lineSpacing(4)
        }
        .padding(FieldFocusTheme.Spacing.md)
        .background(FieldFocusTheme.Color.surface)
        .cornerRadius(FieldFocusTheme.Radius.base)
        .overlay(
            RoundedRectangle(cornerRadius: FieldFocusTheme.Radius.base)
                .stroke(FieldFocusTheme.Color.outline, lineWidth: 1)
        )
    }

    private func conditionBadge(_ condition: LightCondition) -> some View {
        HStack(spacing: 6) {
            Image(systemName: condition.systemIcon)
                .font(.system(size: 14, weight: .semibold))
            Text(condition.rawValue.uppercased())
                .font(FieldFocusTheme.Typography.labelCaps())
                .kerning(0.8)
        }
        .foregroundColor(.white)
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(FieldFocusTheme.Color.navyDark)
        .clipShape(Capsule())
    }

    // MARK: - Light window countdown
    @ViewBuilder
    private var lightWindowCard: some View {
        if let seconds = advisorService.advice.lightWindowSeconds {
            VStack(alignment: .leading, spacing: FieldFocusTheme.Spacing.sm) {
                Text("LIGHT WINDOW REMAINING")
                    .font(FieldFocusTheme.Typography.labelCaps())
                    .foregroundColor(FieldFocusTheme.Color.textSecondary)
                    .kerning(0.8)
                Text(formatDuration(seconds))
                    .font(.system(size: 48, weight: .bold, design: .monospaced))
                    .foregroundColor(FieldFocusTheme.Color.orange)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(FieldFocusTheme.Spacing.md)
            .background(FieldFocusTheme.Color.navyMid)
            .cornerRadius(FieldFocusTheme.Radius.base)
        }
    }

    private func formatDuration(_ seconds: TimeInterval) -> String {
        let m = Int(seconds) / 60
        let s = Int(seconds) % 60
        return String(format: "%02d:%02d", m, s)
    }

    // MARK: - Camera settings card
    private var cameraSettingsCard: some View {
        VStack(alignment: .leading, spacing: FieldFocusTheme.Spacing.md) {
            HStack {
                Text("AI SETTINGS ADVICE")
                    .font(FieldFocusTheme.Typography.labelCaps())
                    .foregroundColor(FieldFocusTheme.Color.textSecondary)
                    .kerning(0.8)
                Spacer()
                Text("PRO EXPERT")
                    .font(FieldFocusTheme.Typography.labelCaps())
                    .foregroundColor(FieldFocusTheme.Color.orange)
                    .kerning(0.8)
            }

            VStack(spacing: 1) {
                settingRow(
                    label: "ISO",
                    value: advisorService.advice.settings.iso,
                    note: advisorService.advice.settings.isoNote
                )
                Divider().background(FieldFocusTheme.Color.outline)
                settingRow(
                    label: "APERTURE",
                    value: advisorService.advice.settings.aperture,
                    note: advisorService.advice.settings.apertureNote
                )
                Divider().background(FieldFocusTheme.Color.outline)
                settingRow(
                    label: "SHUTTER",
                    value: advisorService.advice.settings.shutterSpeed,
                    note: advisorService.advice.settings.shutterNote
                )
                Divider().background(FieldFocusTheme.Color.outline)
                settingRow(
                    label: "WHITE BAL",
                    value: advisorService.advice.settings.whiteBalance,
                    note: nil
                )
                Divider().background(FieldFocusTheme.Color.outline)
                settingRow(
                    label: "EXP COMP",
                    value: advisorService.advice.settings.exposureCompensation,
                    note: nil
                )
                Divider().background(FieldFocusTheme.Color.outline)
                settingRow(
                    label: "MODE",
                    value: advisorService.advice.settings.shootingMode,
                    note: nil
                )
                Divider().background(FieldFocusTheme.Color.outline)
                settingRow(
                    label: "FOCUS",
                    value: advisorService.advice.settings.focusMode,
                    note: nil
                )
            }
        }
        .padding(FieldFocusTheme.Spacing.md)
        .background(FieldFocusTheme.Color.surface)
        .cornerRadius(FieldFocusTheme.Radius.base)
        .overlay(
            RoundedRectangle(cornerRadius: FieldFocusTheme.Radius.base)
                .stroke(FieldFocusTheme.Color.outline, lineWidth: 1)
        )
    }

    private func settingRow(label: String, value: String, note: String?) -> some View {
        HStack {
            Text(label)
                .font(FieldFocusTheme.Typography.labelCaps())
                .foregroundColor(FieldFocusTheme.Color.textSecondary)
                .kerning(0.8)
                .frame(width: 80, alignment: .leading)
            Text(value)
                .font(FieldFocusTheme.Typography.dataMono())
                .foregroundColor(FieldFocusTheme.Color.textPrimary)
            Spacer()
            if let note {
                Text(note)
                    .font(FieldFocusTheme.Typography.bodySM())
                    .foregroundColor(FieldFocusTheme.Color.textSecondary)
            }
        }
        .padding(.vertical, FieldFocusTheme.Spacing.sm)
    }

    // MARK: - Technical analysis
    private var technicalAnalysisCard: some View {
        VStack(alignment: .leading, spacing: FieldFocusTheme.Spacing.sm) {
            Text("TECHNICAL ANALYSIS")
                .font(FieldFocusTheme.Typography.labelCaps())
                .foregroundColor(FieldFocusTheme.Color.textSecondary)
                .kerning(0.8)
            Text(advisorService.advice.technicalAnalysis)
                .font(FieldFocusTheme.Typography.bodyMD())
                .foregroundColor(FieldFocusTheme.Color.textPrimary)
                .lineSpacing(5)
        }
        .padding(FieldFocusTheme.Spacing.md)
        .background(FieldFocusTheme.Color.surface)
        .cornerRadius(FieldFocusTheme.Radius.base)
        .overlay(
            RoundedRectangle(cornerRadius: FieldFocusTheme.Radius.base)
                .stroke(FieldFocusTheme.Color.outline, lineWidth: 1)
        )
    }

    // MARK: - Tips row (composition + equipment)
    private var tipsRow: some View {
        HStack(alignment: .top, spacing: FieldFocusTheme.Spacing.sm) {
            tipCard(icon: "square.grid.3x3.fill", label: "COMPOSITION", text: advisorService.advice.compositionTip)
            tipCard(icon: "camera.filters", label: "EQUIPMENT", text: advisorService.advice.equipmentTip)
        }
    }

    private func tipCard(icon: String, label: String, text: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(FieldFocusTheme.Color.orange)
                Text(label)
                    .font(FieldFocusTheme.Typography.labelCaps())
                    .foregroundColor(FieldFocusTheme.Color.textSecondary)
                    .kerning(0.8)
            }
            Text(text)
                .font(FieldFocusTheme.Typography.bodySM())
                .foregroundColor(FieldFocusTheme.Color.textPrimary)
                .lineSpacing(3)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
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
    ShootingAdviceView()
        .environmentObject(WeatherService())
        .environmentObject(PhotographyAdvisorService())
}
