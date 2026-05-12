import SwiftUI

/// Gear screen — Olympus Stylus 1s reference card with key specs.
struct GearView: View {
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                FieldFocusTheme.Color.background.ignoresSafeArea()

                VStack(spacing: 0) {
                    headerBar
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: FieldFocusTheme.Spacing.md) {
                            cameraCard
                            quickRefCard
                            modeGuideCard
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
                Text("Olympus Stylus 1s")
                    .font(FieldFocusTheme.Typography.headlineSM())
                    .foregroundColor(.white)
            }
            Spacer()
            Image(systemName: "camera.fill")
                .font(.system(size: 24))
                .foregroundColor(.white.opacity(0.85))
        }
        .padding(.horizontal, FieldFocusTheme.Spacing.pagePad)
        .padding(.vertical, FieldFocusTheme.Spacing.md)
        .background(FieldFocusTheme.Color.navyDark)
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
                    .background(Color.green.opacity(0.75))
                    .clipShape(Capsule())
            }

            ForEach(cameraSpecs, id: \.0) { spec in
                specRow(label: spec.0, value: spec.1)
                if spec.0 != cameraSpecs.last?.0 {
                    Divider().background(FieldFocusTheme.Color.outline)
                }
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

    private var cameraSpecs: [(String, String)] = [
        ("SENSOR",   "1/1.7\" BSI CMOS, 12 MP"),
        ("LENS",     "10.7× f/2.8–6.5, 28–300mm eq."),
        ("ISO",      "100–6400 (extendable to 12800)"),
        ("SHUTTER",  "1/2000s – 60s + Bulb"),
        ("STAB.",    "Optical IS (3–4 stop)"),
        ("AF",       "Phase / Contrast detect, 11 pts"),
        ("VIDEO",    "1080p 60fps"),
        ("BATTERY",  "BLS-5, ~280 shots"),
        ("WEIGHT",   "402g incl. battery & card")
    ]

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
            Text("QUICK REFERENCE — STYLUS 1S")
                .font(FieldFocusTheme.Typography.labelCaps())
                .foregroundColor(FieldFocusTheme.Color.textSecondary)
                .kerning(0.8)

            ForEach(quickRefs, id: \.0) { item in
                HStack(alignment: .top, spacing: FieldFocusTheme.Spacing.sm) {
                    Image(systemName: item.2)
                        .font(.system(size: 14))
                        .foregroundColor(FieldFocusTheme.Color.orange)
                        .frame(width: 20)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(item.0)
                            .font(FieldFocusTheme.Typography.bodySM().bold())
                            .foregroundColor(FieldFocusTheme.Color.textPrimary)
                        Text(item.1)
                            .font(FieldFocusTheme.Typography.bodySM())
                            .foregroundColor(FieldFocusTheme.Color.textSecondary)
                            .lineSpacing(3)
                    }
                }
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

    private var quickRefs: [(String, String, String)] = [
        ("Change ISO",         "Press Fn1 → rear dial, or OK → Super Control Panel → ISO",       "speedometer"),
        ("Change Aperture",    "Switch to A mode, then rear dial",                                  "camera.aperture"),
        ("Change Shutter",     "Switch to S or M mode, then rear dial",                             "timer"),
        ("Set White Balance",  "Menu → Shooting 1 → WB, or Super Control Panel",                   "thermometer.medium"),
        ("Manual Focus",       "Toggle MF on lens ring; zoom in with OK for MF Assist",             "viewfinder"),
        ("Exposure Comp",      "+/- button then rear dial (P, A, S modes)",                         "plusminus"),
        ("Enable Face AF",     "AF target selector → Face Priority (FP)",                           "face.dashed"),
        ("Bracket Exposure",   "Drive mode dial → BKT, then set ±EV in menu",                       "square.stack"),
    ]

    // MARK: - Mode guide card
    private var modeGuideCard: some View {
        VStack(alignment: .leading, spacing: FieldFocusTheme.Spacing.sm) {
            Text("MODE DIAL GUIDE")
                .font(FieldFocusTheme.Typography.labelCaps())
                .foregroundColor(FieldFocusTheme.Color.textSecondary)
                .kerning(0.8)

            ForEach(modeGuide, id: \.0) { mode in
                HStack(alignment: .top, spacing: FieldFocusTheme.Spacing.sm) {
                    Text(mode.0)
                        .font(FieldFocusTheme.Typography.dataMono())
                        .foregroundColor(FieldFocusTheme.Color.orange)
                        .frame(width: 36, alignment: .leading)
                    Text(mode.1)
                        .font(FieldFocusTheme.Typography.bodySM())
                        .foregroundColor(FieldFocusTheme.Color.textPrimary)
                        .lineSpacing(3)
                    Spacer()
                }
                .padding(.vertical, 4)
                if mode.0 != modeGuide.last?.0 {
                    Divider().background(FieldFocusTheme.Color.outline)
                }
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

    private var modeGuide: [(String, String)] = [
        ("P",    "Program — camera picks aperture + shutter. Great starting point."),
        ("A",    "Aperture Priority — you set aperture, camera picks shutter. Best for depth-of-field control."),
        ("S",    "Shutter Priority — you set shutter speed, camera picks aperture. Best for motion control."),
        ("M",    "Manual — full control. Required for long exposures and night work."),
        ("ART",  "Art Filters — creative in-camera effects (Pop Art, Grainy Film, etc.)"),
        ("SCN",  "Scene Mode — pre-set combinations for common situations."),
    ]
}

#Preview {
    GearView()
}
