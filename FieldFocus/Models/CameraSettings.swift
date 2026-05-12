import Foundation

/// Olympus Stylus 1s camera settings recommendations.
struct CameraSettings {
    var iso: String
    var aperture: String
    var shutterSpeed: String
    var whiteBalance: String
    var exposureCompensation: String
    var focusMode: String
    var shootingMode: String
    var isoNote: String
    var apertureNote: String
    var shutterNote: String

    static let placeholder = CameraSettings(
        iso: "ISO 100",
        aperture: "f/2.8",
        shutterSpeed: "1/500s",
        whiteBalance: "Auto (AWB)",
        exposureCompensation: "-0.7 EV",
        focusMode: "Single AF (S-AF)",
        shootingMode: "Aperture Priority (A)",
        isoNote: "Noise Optimized",
        apertureNote: "Shallow Depth",
        shutterNote: "Freeze Motion"
    )
}

struct ShootingAdvice {
    var settings: CameraSettings
    var technicalAnalysis: String
    var compositionTip: String
    var equipmentTip: String
    var lightQualityDescription: String
    var lightWindowSeconds: TimeInterval?

    static let placeholder = ShootingAdvice(
        settings: .placeholder,
        technicalAnalysis: "Based on current Golden Hour luminance, a wider aperture emphasises warm bokeh. High contrast between highlights and shadows requires -0.7 EV to preserve sky detail.",
        compositionTip: "Rule of thirds with peak alignment",
        equipmentTip: "Use CPL filter for glare reduction",
        lightQualityDescription: "Light quality is peaking. Move to high-ground for optimal silhouette opportunities.",
        lightWindowSeconds: 24 * 60 + 12
    )
}
