import Foundation

// MARK: - Sub-types

struct CameraSpec: Hashable {
    let label: String
    let value: String
}

struct CameraQuickRef: Hashable {
    let title: String
    let detail: String
    let icon: String
}

struct CameraModeEntry: Hashable {
    let mode: String
    let description: String
}

// MARK: - Model

struct CameraModel: Identifiable, Equatable {
    let id: String           // e.g. "stylus-1s"
    let displayName: String  // e.g. "Stylus 1s"
    let supportSlug: String  // used in Olympus support URL
    let specs: [CameraSpec]
    let quickRefs: [CameraQuickRef]
    let modeGuide: [CameraModeEntry]

    var supportURL: URL {
        URL(string: "https://learnandsupport.getolympus.com/support/\(supportSlug)")!
    }

    static func == (lhs: CameraModel, rhs: CameraModel) -> Bool { lhs.id == rhs.id }
}

// MARK: - Registry

extension CameraModel {

    // MARK: Full-PASM models

    static let stylus1s = CameraModel(
        id: "stylus-1s",
        displayName: "Stylus 1s",
        supportSlug: "stylus-1s",
        specs: [
            .init(label: "SENSOR",  value: "1/1.7\" BSI CMOS, 12 MP"),
            .init(label: "LENS",    value: "10.7× f/2.8–6.5, 28–300mm eq."),
            .init(label: "ISO",     value: "100–6400 (ext. 12800)"),
            .init(label: "SHUTTER", value: "1/2000s – 60s + Bulb"),
            .init(label: "STAB.",   value: "Optical IS (3–4 stop)"),
            .init(label: "AF",      value: "Phase/Contrast detect, 11 pts"),
            .init(label: "VIDEO",   value: "1080p 60fps"),
            .init(label: "BATTERY", value: "BLS-5, ~280 shots"),
            .init(label: "WEIGHT",  value: "402g incl. battery & card")
        ],
        quickRefs: [
            .init(title: "Change ISO",        detail: "Press Fn1 → rear dial, or OK → Super Control Panel → ISO",  icon: "speedometer"),
            .init(title: "Change Aperture",   detail: "Switch to A mode, then rear dial",                           icon: "camera.aperture"),
            .init(title: "Change Shutter",    detail: "Switch to S or M mode, then rear dial",                      icon: "timer"),
            .init(title: "Set White Balance", detail: "Menu → Shooting 1 → WB, or Super Control Panel",             icon: "thermometer.medium"),
            .init(title: "Manual Focus",      detail: "Toggle MF on lens ring; zoom in with OK for MF Assist",      icon: "viewfinder"),
            .init(title: "Exposure Comp",     detail: "+/- button then rear dial (P, A, S modes)",                  icon: "plusminus"),
            .init(title: "Enable Face AF",    detail: "AF target selector → Face Priority (FP)",                    icon: "face.dashed"),
            .init(title: "Bracket Exposure",  detail: "Drive mode dial → BKT, then set ±EV in menu",               icon: "square.stack")
        ],
        modeGuide: [
            .init(mode: "P",   description: "Program — camera picks aperture + shutter. Great starting point."),
            .init(mode: "A",   description: "Aperture Priority — you set aperture, camera picks shutter. Best for depth-of-field control."),
            .init(mode: "S",   description: "Shutter Priority — you set shutter speed, camera picks aperture. Best for motion control."),
            .init(mode: "M",   description: "Manual — full control. Required for long exposures and night work."),
            .init(mode: "ART", description: "Art Filters — creative in-camera effects (Pop Art, Grainy Film, etc.)"),
            .init(mode: "SCN", description: "Scene Mode — pre-set combinations for common situations.")
        ]
    )

    static let stylus1 = CameraModel(
        id: "stylus-1",
        displayName: "Stylus 1",
        supportSlug: "stylus-1",
        specs: [
            .init(label: "SENSOR",  value: "1/1.7\" BSI CMOS, 12 MP"),
            .init(label: "LENS",    value: "10.7× f/2.8–6.5, 28–300mm eq."),
            .init(label: "ISO",     value: "100–6400"),
            .init(label: "SHUTTER", value: "1/2000s – 60s + Bulb"),
            .init(label: "STAB.",   value: "Optical IS (3 stop)"),
            .init(label: "AF",      value: "iESP + Contrast detect"),
            .init(label: "VIDEO",   value: "1080p 30fps"),
            .init(label: "BATTERY", value: "BLS-5, ~270 shots"),
            .init(label: "WEIGHT",  value: "400g incl. battery & card")
        ],
        quickRefs: [
            .init(title: "Change ISO",        detail: "OK → Super Control Panel → ISO",                         icon: "speedometer"),
            .init(title: "Change Aperture",   detail: "Switch to A mode, then rear dial",                        icon: "camera.aperture"),
            .init(title: "Change Shutter",    detail: "Switch to S or M mode, then rear dial",                   icon: "timer"),
            .init(title: "Set White Balance", detail: "Menu → Shooting 1 → White Balance",                       icon: "thermometer.medium"),
            .init(title: "Manual Focus",      detail: "Toggle MF on lens ring; zoom in for MF Assist",           icon: "viewfinder"),
            .init(title: "Exposure Comp",     detail: "+/- button then rear dial (P, A, S modes)",               icon: "plusminus"),
            .init(title: "Enable Face AF",    detail: "AF target selector → Face Priority (FP)",                 icon: "face.dashed"),
            .init(title: "Bracket Exposure",  detail: "Drive mode dial → BKT, then set ±EV in menu",            icon: "square.stack")
        ],
        modeGuide: [
            .init(mode: "P",   description: "Program — camera picks aperture + shutter. Great starting point."),
            .init(mode: "A",   description: "Aperture Priority — you set aperture, camera picks shutter. Best for depth-of-field control."),
            .init(mode: "S",   description: "Shutter Priority — you set shutter speed, camera picks aperture. Best for motion control."),
            .init(mode: "M",   description: "Manual — full control. Required for long exposures and night work."),
            .init(mode: "ART", description: "Art Filters — creative in-camera effects (Pop Art, Grainy Film, etc.)"),
            .init(mode: "SCN", description: "Scene Mode — pre-set combinations for common situations.")
        ]
    )

    // MARK: SP Superzoom models

    static let sp560uz = CameraModel(
        id: "sp-560-uz",
        displayName: "SP-560 UZ",
        supportSlug: "sp-560-uz",
        specs: [
            .init(label: "SENSOR",  value: "1/2.5\" CCD, 8 MP"),
            .init(label: "LENS",    value: "18× f/2.8–4.5, 27–486mm eq."),
            .init(label: "ISO",     value: "64–1600"),
            .init(label: "SHUTTER", value: "1/2000s – 8s"),
            .init(label: "STAB.",   value: "Optical IS (Dual IS)"),
            .init(label: "AF",      value: "iESP TTL"),
            .init(label: "VIDEO",   value: "640×480 30fps"),
            .init(label: "BATTERY", value: "2× AA alkaline/NiMH"),
            .init(label: "WEIGHT",  value: "395g incl. battery & card")
        ],
        quickRefs: _superzoomQuickRefs,
        modeGuide: _pasmModeGuide
    )

    static let sp565uz = CameraModel(
        id: "sp-565-uz",
        displayName: "SP-565 UZ",
        supportSlug: "sp-565-uz",
        specs: [
            .init(label: "SENSOR",  value: "1/2.3\" CCD, 10 MP"),
            .init(label: "LENS",    value: "26× f/2.8–4.6, 26–676mm eq."),
            .init(label: "ISO",     value: "64–1600"),
            .init(label: "SHUTTER", value: "1/2000s – 4s"),
            .init(label: "STAB.",   value: "Dual IS 2"),
            .init(label: "AF",      value: "iESP TTL"),
            .init(label: "VIDEO",   value: "720p 30fps"),
            .init(label: "BATTERY", value: "2× AA alkaline/NiMH"),
            .init(label: "WEIGHT",  value: "396g incl. battery & card")
        ],
        quickRefs: _superzoomQuickRefs,
        modeGuide: _pasmModeGuide
    )

    static let sp570uz = CameraModel(
        id: "sp-570-uz",
        displayName: "SP-570 UZ",
        supportSlug: "sp-570-uz",
        specs: [
            .init(label: "SENSOR",  value: "1/2.33\" CCD, 10 MP"),
            .init(label: "LENS",    value: "20× f/2.8–5.0, 26–520mm eq."),
            .init(label: "ISO",     value: "64–1600"),
            .init(label: "SHUTTER", value: "1/2000s – 8s"),
            .init(label: "STAB.",   value: "Optical IS (Dual IS)"),
            .init(label: "AF",      value: "iESP TTL"),
            .init(label: "VIDEO",   value: "640×480 30fps"),
            .init(label: "BATTERY", value: "2× AA alkaline/NiMH"),
            .init(label: "WEIGHT",  value: "396g incl. battery & card")
        ],
        quickRefs: _superzoomQuickRefs,
        modeGuide: _pasmModeGuide
    )

    // MARK: Stylus 5010 — compact with Dual IS

    static let stylus5010 = CameraModel(
        id: "stylus-5010",
        displayName: "Stylus 5010",
        supportSlug: "stylus-5010",
        specs: [
            .init(label: "SENSOR",  value: "1/2.3\" CCD, 14 MP"),
            .init(label: "LENS",    value: "7× f/3.0–6.6, 28–196mm eq."),
            .init(label: "ISO",     value: "64–3200"),
            .init(label: "SHUTTER", value: "1/2000s – 4s"),
            .init(label: "STAB.",   value: "Dual IS (optical + digital)"),
            .init(label: "AF",      value: "iESP TTL"),
            .init(label: "VIDEO",   value: "720p 30fps"),
            .init(label: "BATTERY", value: "LI-50B, ~300 shots"),
            .init(label: "WEIGHT",  value: "112g")
        ],
        quickRefs: _compactQuickRefs,
        modeGuide: _compactModeGuide
    )

    // MARK: Stylus 9000 series

    static let stylus9000 = CameraModel(
        id: "stylus-9000",
        displayName: "Stylus-9000",
        supportSlug: "stylus-9000",
        specs: [
            .init(label: "SENSOR",  value: "1/2.3\" CCD, 12 MP"),
            .init(label: "LENS",    value: "10× f/3.5–5.6, 28–280mm eq."),
            .init(label: "ISO",     value: "64–3200"),
            .init(label: "SHUTTER", value: "1/2000s – 4s"),
            .init(label: "STAB.",   value: "Optical IS"),
            .init(label: "AF",      value: "iESP TTL"),
            .init(label: "VIDEO",   value: "720p 30fps"),
            .init(label: "BATTERY", value: "LI-50B, ~280 shots"),
            .init(label: "WEIGHT",  value: "136g")
        ],
        quickRefs: _compactQuickRefs,
        modeGuide: _compactModeGuide
    )

    // MARK: Stylus 7000 series

    static let stylus7040 = CameraModel(
        id: "stylus-7040",
        displayName: "Stylus-7040",
        supportSlug: "stylus-7040",
        specs: [
            .init(label: "SENSOR",  value: "1/2.3\" CCD, 14 MP"),
            .init(label: "LENS",    value: "7× f/3.5–5.6, 28–196mm eq."),
            .init(label: "ISO",     value: "64–3200"),
            .init(label: "SHUTTER", value: "1/2000s – 4s"),
            .init(label: "STAB.",   value: "Dual IS"),
            .init(label: "AF",      value: "iESP TTL"),
            .init(label: "VIDEO",   value: "720p 30fps"),
            .init(label: "BATTERY", value: "LI-50B, ~300 shots"),
            .init(label: "WEIGHT",  value: "135g")
        ],
        quickRefs: _compactQuickRefs,
        modeGuide: _compactModeGuide
    )

    static let stylus7030 = CameraModel(
        id: "stylus-7030",
        displayName: "Stylus-7030",
        supportSlug: "stylus-7030",
        specs: [
            .init(label: "SENSOR",  value: "1/2.3\" CCD, 14 MP"),
            .init(label: "LENS",    value: "7× f/3.5–5.6, 28–196mm eq."),
            .init(label: "ISO",     value: "64–3200"),
            .init(label: "SHUTTER", value: "1/2000s – 4s"),
            .init(label: "STAB.",   value: "Dual IS"),
            .init(label: "AF",      value: "iESP TTL"),
            .init(label: "VIDEO",   value: "720p 30fps"),
            .init(label: "BATTERY", value: "LI-50B, ~300 shots"),
            .init(label: "WEIGHT",  value: "132g")
        ],
        quickRefs: _compactQuickRefs,
        modeGuide: _compactModeGuide
    )

    static let stylus7010 = CameraModel(
        id: "stylus-7010",
        displayName: "Stylus-7010",
        supportSlug: "stylus-7010",
        specs: [
            .init(label: "SENSOR",  value: "1/2.3\" CCD, 12 MP"),
            .init(label: "LENS",    value: "7× f/3.5–5.6, 28–196mm eq."),
            .init(label: "ISO",     value: "64–3200"),
            .init(label: "SHUTTER", value: "1/2000s – 4s"),
            .init(label: "STAB.",   value: "Dual IS"),
            .init(label: "AF",      value: "iESP TTL"),
            .init(label: "VIDEO",   value: "720p 30fps"),
            .init(label: "BATTERY", value: "LI-50B, ~270 shots"),
            .init(label: "WEIGHT",  value: "130g")
        ],
        quickRefs: _compactQuickRefs,
        modeGuide: _compactModeGuide
    )

    static let stylus7000 = CameraModel(
        id: "stylus-7000",
        displayName: "Stylus-7000",
        supportSlug: "stylus-7000",
        specs: [
            .init(label: "SENSOR",  value: "1/2.3\" CCD, 12 MP"),
            .init(label: "LENS",    value: "7× f/3.5–5.6, 28–196mm eq."),
            .init(label: "ISO",     value: "64–3200"),
            .init(label: "SHUTTER", value: "1/2000s – 4s"),
            .init(label: "STAB.",   value: "Dual IS"),
            .init(label: "AF",      value: "iESP TTL"),
            .init(label: "VIDEO",   value: "720p 30fps"),
            .init(label: "BATTERY", value: "LI-50B, ~270 shots"),
            .init(label: "WEIGHT",  value: "128g")
        ],
        quickRefs: _compactQuickRefs,
        modeGuide: _compactModeGuide
    )

    // MARK: Stylus 1000 series

    static let stylus1200 = CameraModel(
        id: "stylus-1200",
        displayName: "Stylus 1200",
        supportSlug: "stylus-1200",
        specs: [
            .init(label: "SENSOR",  value: "1/2.3\" CCD, 12 MP"),
            .init(label: "LENS",    value: "5× f/3.2–5.8, 38–190mm eq."),
            .init(label: "ISO",     value: "64–1600"),
            .init(label: "SHUTTER", value: "1/2000s – 4s"),
            .init(label: "STAB.",   value: "Optical IS"),
            .init(label: "AF",      value: "iESP TTL"),
            .init(label: "VIDEO",   value: "640×480 30fps"),
            .init(label: "BATTERY", value: "LI-50B, ~250 shots"),
            .init(label: "WEIGHT",  value: "120g")
        ],
        quickRefs: _compactQuickRefs,
        modeGuide: _compactModeGuide
    )

    static let stylus1040 = CameraModel(
        id: "stylus-1040",
        displayName: "Stylus 1040",
        supportSlug: "stylus-1040",
        specs: [
            .init(label: "SENSOR",  value: "1/2.33\" CCD, 10 MP"),
            .init(label: "LENS",    value: "7× f/3.5–5.6, 28–196mm eq."),
            .init(label: "ISO",     value: "64–3200"),
            .init(label: "SHUTTER", value: "1/2000s – 4s"),
            .init(label: "STAB.",   value: "Dual IS"),
            .init(label: "AF",      value: "iESP TTL"),
            .init(label: "VIDEO",   value: "640×480 30fps"),
            .init(label: "BATTERY", value: "LI-50B, ~260 shots"),
            .init(label: "WEIGHT",  value: "118g")
        ],
        quickRefs: _compactQuickRefs,
        modeGuide: _compactModeGuide
    )

    static let stylus1020 = CameraModel(
        id: "stylus-1020",
        displayName: "Stylus 1020",
        supportSlug: "stylus-1020",
        specs: [
            .init(label: "SENSOR",  value: "1/2.33\" CCD, 10 MP"),
            .init(label: "LENS",    value: "7× f/3.5–5.6, 28–196mm eq."),
            .init(label: "ISO",     value: "64–3200"),
            .init(label: "SHUTTER", value: "1/2000s – 4s"),
            .init(label: "STAB.",   value: "Optical IS"),
            .init(label: "AF",      value: "iESP TTL"),
            .init(label: "VIDEO",   value: "640×480 30fps"),
            .init(label: "BATTERY", value: "LI-50B, ~255 shots"),
            .init(label: "WEIGHT",  value: "118g")
        ],
        quickRefs: _compactQuickRefs,
        modeGuide: _compactModeGuide
    )

    static let stylus1010 = CameraModel(
        id: "stylus-1010",
        displayName: "Stylus 1010",
        supportSlug: "stylus-1010",
        specs: [
            .init(label: "SENSOR",  value: "1/2.33\" CCD, 10 MP"),
            .init(label: "LENS",    value: "7× f/3.5–5.6, 28–196mm eq."),
            .init(label: "ISO",     value: "64–3200"),
            .init(label: "SHUTTER", value: "1/2000s – 4s"),
            .init(label: "STAB.",   value: "Optical IS"),
            .init(label: "AF",      value: "iESP TTL"),
            .init(label: "VIDEO",   value: "640×480 30fps"),
            .init(label: "BATTERY", value: "LI-50B, ~250 shots"),
            .init(label: "WEIGHT",  value: "120g")
        ],
        quickRefs: _compactQuickRefs,
        modeGuide: _compactModeGuide
    )

    static let stylus1000 = CameraModel(
        id: "stylus-1000",
        displayName: "Stylus 1000",
        supportSlug: "stylus-1000",
        specs: [
            .init(label: "SENSOR",  value: "1/2.3\" CCD, 10 MP"),
            .init(label: "LENS",    value: "7× f/3.5–5.6, 28–196mm eq."),
            .init(label: "ISO",     value: "64–1600"),
            .init(label: "SHUTTER", value: "1/2000s – 4s"),
            .init(label: "STAB.",   value: "Optical IS"),
            .init(label: "AF",      value: "iESP TTL"),
            .init(label: "VIDEO",   value: "640×480 30fps"),
            .init(label: "BATTERY", value: "LI-50B, ~240 shots"),
            .init(label: "WEIGHT",  value: "120g")
        ],
        quickRefs: _compactQuickRefs,
        modeGuide: _compactModeGuide
    )

    // MARK: Stylus 800 series

    static let stylus840 = CameraModel(
        id: "stylus-840",
        displayName: "Stylus 840",
        supportSlug: "stylus-840",
        specs: [
            .init(label: "SENSOR",  value: "1/2.3\" CCD, 8 MP"),
            .init(label: "LENS",    value: "5× f/2.8–6.7, 28–140mm eq."),
            .init(label: "ISO",     value: "64–1600"),
            .init(label: "SHUTTER", value: "1/2000s – 4s"),
            .init(label: "STAB.",   value: "Optical IS"),
            .init(label: "AF",      value: "iESP TTL"),
            .init(label: "VIDEO",   value: "640×480 30fps"),
            .init(label: "BATTERY", value: "LI-40B, ~220 shots"),
            .init(label: "WEIGHT",  value: "126g")
        ],
        quickRefs: _compactQuickRefs,
        modeGuide: _compactModeGuide
    )

    static let stylus830 = CameraModel(
        id: "stylus-830",
        displayName: "Stylus 830",
        supportSlug: "stylus-830",
        specs: [
            .init(label: "SENSOR",  value: "1/2.5\" CCD, 8 MP"),
            .init(label: "LENS",    value: "3.8× f/3.5–5.6, 35–133mm eq."),
            .init(label: "ISO",     value: "64–1600"),
            .init(label: "SHUTTER", value: "1/2000s – 4s"),
            .init(label: "STAB.",   value: "Optical IS"),
            .init(label: "AF",      value: "iESP TTL"),
            .init(label: "VIDEO",   value: "640×480 30fps"),
            .init(label: "BATTERY", value: "LI-40B, ~210 shots"),
            .init(label: "WEIGHT",  value: "125g")
        ],
        quickRefs: _compactQuickRefs,
        modeGuide: _compactModeGuide
    )

    static let stylus820 = CameraModel(
        id: "stylus-820",
        displayName: "Stylus 820",
        supportSlug: "stylus-820",
        specs: [
            .init(label: "SENSOR",  value: "1/2.5\" CCD, 8 MP"),
            .init(label: "LENS",    value: "3× f/3.5–5.6, 35–105mm eq."),
            .init(label: "ISO",     value: "64–1600"),
            .init(label: "SHUTTER", value: "1/2000s – 4s"),
            .init(label: "STAB.",   value: "Optical IS"),
            .init(label: "AF",      value: "iESP TTL"),
            .init(label: "VIDEO",   value: "640×480 30fps"),
            .init(label: "BATTERY", value: "LI-40B, ~200 shots"),
            .init(label: "WEIGHT",  value: "120g")
        ],
        quickRefs: _compactQuickRefs,
        modeGuide: _compactModeGuide
    )

    static let stylus810 = CameraModel(
        id: "stylus-810",
        displayName: "Stylus 810",
        supportSlug: "stylus-810",
        specs: [
            .init(label: "SENSOR",  value: "1/2.5\" CCD, 8 MP"),
            .init(label: "LENS",    value: "3× f/3.2–5.7, 35–105mm eq."),
            .init(label: "ISO",     value: "64–1600"),
            .init(label: "SHUTTER", value: "1/2000s – 4s"),
            .init(label: "STAB.",   value: "Optical IS"),
            .init(label: "AF",      value: "iESP TTL"),
            .init(label: "VIDEO",   value: "640×480 30fps"),
            .init(label: "BATTERY", value: "LI-40B, ~200 shots"),
            .init(label: "WEIGHT",  value: "120g")
        ],
        quickRefs: _compactQuickRefs,
        modeGuide: _compactModeGuide
    )

    // MARK: Stylus 700 series

    static let stylus780 = CameraModel(
        id: "stylus-780",
        displayName: "Stylus 780",
        supportSlug: "stylus-780",
        specs: [
            .init(label: "SENSOR",  value: "1/2.5\" CCD, 7.2 MP"),
            .init(label: "LENS",    value: "3× f/3.5–5.8, 37–111mm eq."),
            .init(label: "ISO",     value: "64–1600"),
            .init(label: "SHUTTER", value: "1/2000s – 4s"),
            .init(label: "STAB.",   value: "Optical IS"),
            .init(label: "AF",      value: "iESP TTL"),
            .init(label: "VIDEO",   value: "640×480 30fps"),
            .init(label: "BATTERY", value: "LI-40B, ~190 shots"),
            .init(label: "WEIGHT",  value: "116g")
        ],
        quickRefs: _compactQuickRefs,
        modeGuide: _compactModeGuide
    )

    static let stylus760 = CameraModel(
        id: "stylus-760",
        displayName: "Stylus 760",
        supportSlug: "stylus-760",
        specs: [
            .init(label: "SENSOR",  value: "1/2.5\" CCD, 7.1 MP"),
            .init(label: "LENS",    value: "3× f/3.2–5.7, 37–111mm eq."),
            .init(label: "ISO",     value: "64–1600"),
            .init(label: "SHUTTER", value: "1/2000s – 4s"),
            .init(label: "STAB.",   value: "Optical IS"),
            .init(label: "AF",      value: "iESP TTL"),
            .init(label: "VIDEO",   value: "640×480 30fps"),
            .init(label: "BATTERY", value: "LI-40B, ~190 shots"),
            .init(label: "WEIGHT",  value: "116g")
        ],
        quickRefs: _compactQuickRefs,
        modeGuide: _compactModeGuide
    )

    static let stylus750 = CameraModel(
        id: "stylus-750",
        displayName: "Stylus 750",
        supportSlug: "stylus-750",
        specs: [
            .init(label: "SENSOR",  value: "1/2.5\" CCD, 7.1 MP"),
            .init(label: "LENS",    value: "3× f/3.5–5.6, 37–111mm eq."),
            .init(label: "ISO",     value: "64–800"),
            .init(label: "SHUTTER", value: "1/1000s – 4s"),
            .init(label: "STAB.",   value: "Optical IS"),
            .init(label: "AF",      value: "iESP TTL"),
            .init(label: "VIDEO",   value: "640×480 30fps"),
            .init(label: "BATTERY", value: "LI-40B, ~190 shots"),
            .init(label: "WEIGHT",  value: "115g")
        ],
        quickRefs: _compactQuickRefs,
        modeGuide: _compactModeGuide
    )

    static let stylus740 = CameraModel(
        id: "stylus-740",
        displayName: "Stylus 740",
        supportSlug: "stylus-740",
        specs: [
            .init(label: "SENSOR",  value: "1/2.5\" CCD, 7.1 MP"),
            .init(label: "LENS",    value: "3× f/3.5–5.6, 37–111mm eq."),
            .init(label: "ISO",     value: "64–800"),
            .init(label: "SHUTTER", value: "1/1000s – 4s"),
            .init(label: "STAB.",   value: "None"),
            .init(label: "AF",      value: "iESP TTL"),
            .init(label: "VIDEO",   value: "640×480 30fps"),
            .init(label: "BATTERY", value: "LI-40B, ~180 shots"),
            .init(label: "WEIGHT",  value: "110g")
        ],
        quickRefs: _compactQuickRefs,
        modeGuide: _compactModeGuide
    )

    static let stylus730 = CameraModel(
        id: "stylus-730",
        displayName: "Stylus 730",
        supportSlug: "stylus-730",
        specs: [
            .init(label: "SENSOR",  value: "1/2.5\" CCD, 7.1 MP"),
            .init(label: "LENS",    value: "3× f/3.5–5.6, 37–111mm eq."),
            .init(label: "ISO",     value: "50–400"),
            .init(label: "SHUTTER", value: "1/2000s – 4s"),
            .init(label: "STAB.",   value: "None"),
            .init(label: "AF",      value: "iESP TTL"),
            .init(label: "VIDEO",   value: "320×240 30fps"),
            .init(label: "BATTERY", value: "LI-40B, ~170 shots"),
            .init(label: "WEIGHT",  value: "110g")
        ],
        quickRefs: _compactQuickRefs,
        modeGuide: _compactModeGuide
    )

    static let stylus710 = CameraModel(
        id: "stylus-710",
        displayName: "Stylus 710",
        supportSlug: "stylus-710",
        specs: [
            .init(label: "SENSOR",  value: "1/2.5\" CCD, 7.1 MP"),
            .init(label: "LENS",    value: "3× f/3.2–5.7, 37–111mm eq."),
            .init(label: "ISO",     value: "64–1600"),
            .init(label: "SHUTTER", value: "1/2000s – 4s"),
            .init(label: "STAB.",   value: "None"),
            .init(label: "AF",      value: "iESP TTL"),
            .init(label: "VIDEO",   value: "320×240 15fps"),
            .init(label: "BATTERY", value: "LI-40B, ~175 shots"),
            .init(label: "WEIGHT",  value: "110g")
        ],
        quickRefs: _compactQuickRefs,
        modeGuide: _compactModeGuide
    )

    static let stylus700 = CameraModel(
        id: "stylus-700",
        displayName: "Stylus 700",
        supportSlug: "stylus-700",
        specs: [
            .init(label: "SENSOR",  value: "1/2.5\" CCD, 7 MP"),
            .init(label: "LENS",    value: "3× f/2.8–5.6, 37–111mm eq."),
            .init(label: "ISO",     value: "50–800"),
            .init(label: "SHUTTER", value: "1/2000s – 4s"),
            .init(label: "STAB.",   value: "None"),
            .init(label: "AF",      value: "iESP TTL"),
            .init(label: "VIDEO",   value: "320×240 15fps"),
            .init(label: "BATTERY", value: "LI-40B, ~170 shots"),
            .init(label: "WEIGHT",  value: "110g")
        ],
        quickRefs: _compactQuickRefs,
        modeGuide: _compactModeGuide
    )

    // MARK: Waterproof

    static let stylus550wp = CameraModel(
        id: "stylus-550wp",
        displayName: "Stylus-550WP",
        supportSlug: "stylus-550wp",
        specs: [
            .init(label: "SENSOR",  value: "1/2.5\" CCD, 6 MP"),
            .init(label: "LENS",    value: "3× f/2.8–4.8, 37–111mm eq."),
            .init(label: "ISO",     value: "64–800"),
            .init(label: "SHUTTER", value: "1/2000s – 4s"),
            .init(label: "STAB.",   value: "None"),
            .init(label: "AF",      value: "iESP TTL"),
            .init(label: "VIDEO",   value: "320×240 15fps"),
            .init(label: "WATER",   value: "Waterproof to 3m"),
            .init(label: "BATTERY", value: "LI-40B, ~200 shots")
        ],
        quickRefs: _compactQuickRefs,
        modeGuide: _compactModeGuide
    )

    // MARK: Ordered series list (newest/most capable first)
    static let stylusSeries: [CameraModel] = [
        stylus1s, stylus1,
        sp570uz, sp565uz, sp560uz,
        stylus5010,
        stylus9000,
        stylus7040, stylus7030, stylus7010, stylus7000,
        stylus1200, stylus1040, stylus1020, stylus1010, stylus1000,
        stylus840, stylus830, stylus820, stylus810,
        stylus780, stylus760, stylus750, stylus740, stylus730, stylus710, stylus700,
        stylus550wp
    ]
}

// MARK: - Shared quick-ref / mode-guide templates

private let _superzoomQuickRefs: [CameraQuickRef] = [
    .init(title: "Change ISO",        detail: "Menu → Shooting → ISO Sensitivity",                   icon: "speedometer"),
    .init(title: "Change Aperture",   detail: "Mode dial to A, then use up/down arrows",              icon: "camera.aperture"),
    .init(title: "Change Shutter",    detail: "Mode dial to S, then use up/down arrows",              icon: "timer"),
    .init(title: "Set White Balance", detail: "Menu → Shooting → White Balance",                      icon: "thermometer.medium"),
    .init(title: "Manual Focus",      detail: "Menu → Shooting → AF Mode → MF, then arrow keys",      icon: "viewfinder"),
    .init(title: "Exposure Comp",     detail: "+/- button in P, A, S modes",                          icon: "plusminus"),
    .init(title: "Scene Mode",        detail: "Mode dial to SCN, then choose from menu",               icon: "theatermasks"),
    .init(title: "Bracket Exposure",  detail: "Menu → Shooting → Bracket (if available)",             icon: "square.stack")
]

private let _pasmModeGuide: [CameraModeEntry] = [
    .init(mode: "P",    description: "Program — camera picks aperture + shutter. Adjust with +/- for exposure comp."),
    .init(mode: "A",    description: "Aperture Priority — set f/stop with arrows, camera picks shutter speed."),
    .init(mode: "S",    description: "Shutter Priority — set shutter with arrows, camera picks aperture."),
    .init(mode: "M",    description: "Manual — full control. Use arrows to set both aperture and shutter."),
    .init(mode: "SCN",  description: "Scene Mode — preset combinations for sports, portrait, night, etc."),
    .init(mode: "AUTO", description: "Full automatic — ideal for quick snapshots in familiar conditions.")
]

private let _compactQuickRefs: [CameraQuickRef] = [
    .init(title: "Change ISO",        detail: "Menu → Shooting 1 → ISO Sensitivity",                  icon: "speedometer"),
    .init(title: "Exposure Comp",     detail: "+/- button, then OK or arrow keys to adjust",           icon: "plusminus"),
    .init(title: "Set White Balance", detail: "Menu → Shooting 1 → White Balance",                     icon: "thermometer.medium"),
    .init(title: "Scene Mode",        detail: "Press MODE button → SCN, select scene type",             icon: "theatermasks"),
    .init(title: "Face Detection",    detail: "Menu → Camera → Face Detection → On",                   icon: "face.dashed"),
    .init(title: "Self-Timer",        detail: "Drive mode button → 2s or 12s self-timer",              icon: "timer"),
    .init(title: "Macro Mode",        detail: "Press macro button (flower icon) for close-ups",        icon: "viewfinder"),
    .init(title: "Flash Control",     detail: "Press flash button to cycle Auto/On/Off/Red-eye",       icon: "bolt")
]

private let _compactModeGuide: [CameraModeEntry] = [
    .init(mode: "AUTO",  description: "Full automatic — camera handles all exposure decisions."),
    .init(mode: "P",     description: "Program AE — camera selects exposure; you control ISO, WB, and flash."),
    .init(mode: "SCN",   description: "Scene Mode — optimised presets for portrait, sport, night, beach, etc."),
    .init(mode: "MOVIE", description: "Video recording mode — press shutter to start/stop."),
    .init(mode: "MAGIC", description: "Magic Filter — in-camera creative effects (Pin Hole, Drawing, etc.)"),
    .init(mode: "BEAUTY", description: "Smart Portrait — face-detection with skin-tone enhancement.")
]
