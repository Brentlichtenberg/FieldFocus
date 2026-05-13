import SwiftUI

/// Gear screen — camera reference card driven by the user-selected Stylus Series model.
struct GearView: View {
    @AppStorage("FieldFocus.selectedCameraID") private var selectedCameraID: String = CameraModel.stylus1s.id

    private var selectedModel: CameraModel {
        CameraModel.stylusSeries.first { $0.id == selectedCameraID } ?? .stylus1s
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                FieldFocusTheme.Color.background.ignoresSafeArea()

                VStack(spacing: 0) {
                    headerBar
                    ScrollView(showsIndicators: false) {
                        Group {
                            if #available(iOS 26, *) {
                                GlassEffectContainer(spacing: 16) {
                                    gearCardsContent
                                }
                            } else {
                                gearCardsContent
                            }
                        }
                        .padding(.horizontal, FieldFocusTheme.Spacing.pagePad)
                        .padding(.vertical, FieldFocusTheme.Spacing.md)
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
                Text("GEAR")
                    .font(FieldFocusTheme.Typography.labelCaps())
                    .foregroundColor(.white.opacity(0.7))
                    .kerning(1)
                // Dropdown — tapping shows the Stylus Series picker
                Menu {
                    ForEach(CameraModel.stylusSeries) { model in
                        Button {
                            selectedCameraID = model.id
                        } label: {
                            if model.id == selectedCameraID {
                                Label(model.displayName, systemImage: "checkmark")
                            } else {
                                Text(model.displayName)
                            }
                        }
                    }
                } label: {
                    HStack(spacing: 5) {
                        Text("Olympus \(selectedModel.displayName)")
                            .font(FieldFocusTheme.Typography.headlineSM())
                            .foregroundColor(.white)
                        Image(systemName: "chevron.down")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(.white.opacity(0.65))
                    }
                }
            }
            Spacer()
            // Get Manual — opens Olympus support page in Safari
            Link(destination: selectedModel.supportURL) {
                HStack(spacing: 4) {
                    Image(systemName: "doc.text")
                        .font(.system(size: 13))
                    Text("MANUAL")
                        .font(FieldFocusTheme.Typography.labelCaps())
                        .kerning(0.6)
                }
                .foregroundColor(.white.opacity(0.85))
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(.white.opacity(0.12), in: RoundedRectangle(cornerRadius: 8))
            }
        }
        .padding(.horizontal, FieldFocusTheme.Spacing.pagePad)
        .padding(.vertical, FieldFocusTheme.Spacing.md)
        .background(FieldFocusTheme.Color.navyDark)
    }

    private var gearCardsContent: some View {
        VStack(spacing: FieldFocusTheme.Spacing.md) {
            cameraCard
            quickRefCard
            modeGuideCard
        }
    }

    // MARK: - Camera spec card
    private var cameraCard: some View {
        VStack(alignment: .leading, spacing: FieldFocusTheme.Spacing.md) {
            HStack {
                Text("CAMERA SPECS")
                    .font(FieldFocusTheme.Typography.labelCaps())
                    .foregroundColor(FieldFocusTheme.Color.textSecondary)
                    .kerning(0.8)
                Spacer()
                Text("READY")
                    .font(FieldFocusTheme.Typography.labelCaps())
                    .foregroundColor(.white)
                    .kerning(0.8)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .glassChip(tint: .green, foreground: .white)
            }

            ForEach(selectedModel.specs, id: \.self) { spec in
                specRow(label: spec.label, value: spec.value)
                if spec != selectedModel.specs.last {
                    Divider().background(FieldFocusTheme.Color.outline)
                }
            }
        }
        .padding(FieldFocusTheme.Spacing.md)
        .glassCard()
    }

    private func specRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(FieldFocusTheme.Typography.labelCaps())
                .foregroundColor(FieldFocusTheme.Color.textSecondary)
                .kerning(0.8)
                .frame(width: 80, alignment: .leading)
            Text(value)
                .font(FieldFocusTheme.Typography.dataMono())
                .foregroundColor(FieldFocusTheme.Color.textPrimary)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
            Spacer()
        }
        .padding(.vertical, 6)
    }

    // MARK: - Quick reference card
    private var quickRefCard: some View {
        VStack(alignment: .leading, spacing: FieldFocusTheme.Spacing.sm) {
            Text("QUICK REFERENCE — \(selectedModel.displayName.uppercased())")
                .font(FieldFocusTheme.Typography.labelCaps())
                .foregroundColor(FieldFocusTheme.Color.textSecondary)
                .kerning(0.8)

            ForEach(selectedModel.quickRefs, id: \.self) { item in
                HStack(alignment: .top, spacing: FieldFocusTheme.Spacing.sm) {
                    Image(systemName: item.icon)
                        .font(.system(size: 14))
                        .foregroundColor(FieldFocusTheme.Color.orange)
                        .frame(width: 20)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(item.title)
                            .font(FieldFocusTheme.Typography.bodySM().bold())
                            .foregroundColor(FieldFocusTheme.Color.textPrimary)
                        Text(item.detail)
                            .font(FieldFocusTheme.Typography.bodySM())
                            .foregroundColor(FieldFocusTheme.Color.textSecondary)
                            .lineSpacing(3)
                    }
                }
            }
        }
        .padding(FieldFocusTheme.Spacing.md)
        .glassCard()
    }

    // MARK: - Mode guide card
    private var modeGuideCard: some View {
        VStack(alignment: .leading, spacing: FieldFocusTheme.Spacing.sm) {
            Text("MODE GUIDE")
                .font(FieldFocusTheme.Typography.labelCaps())
                .foregroundColor(FieldFocusTheme.Color.textSecondary)
                .kerning(0.8)

            ForEach(selectedModel.modeGuide, id: \.self) { entry in
                HStack(alignment: .top, spacing: FieldFocusTheme.Spacing.sm) {
                    Text(entry.mode)
                        .font(FieldFocusTheme.Typography.dataMono())
                        .foregroundColor(FieldFocusTheme.Color.orange)
                        .frame(width: 36, alignment: .leading)
                    Text(entry.description)
                        .font(FieldFocusTheme.Typography.bodySM())
                        .foregroundColor(FieldFocusTheme.Color.textPrimary)
                        .lineSpacing(3)
                    Spacer()
                }
                .padding(.vertical, 4)
                if entry != selectedModel.modeGuide.last {
                    Divider().background(FieldFocusTheme.Color.outline)
                }
            }
        }
        .padding(FieldFocusTheme.Spacing.md)
        .glassCard()
    }
}

#Preview {
    GearView()
}
