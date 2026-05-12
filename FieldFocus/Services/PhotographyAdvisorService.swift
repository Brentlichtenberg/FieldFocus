import Foundation
import os.log

private let logger = Logger(subsystem: "com.appsOnapps.FieldFocus", category: "PhotographyAdvisor")

/// Generates Olympus Stylus 1s-specific camera settings and advice based
/// on current weather/lighting conditions.
@MainActor
final class PhotographyAdvisorService: ObservableObject {
    @Published var advice: ShootingAdvice = .placeholder
    @Published var chatMessages: [ChatMessage] = []
    @Published var isThinking = false

    struct ChatMessage: Identifiable {
        let id = UUID()
        let role: Role
        let text: String
        enum Role { case user, assistant }
    }

    func generateAdvice(for weather: WeatherSnapshot) {
        logger.info("Generating advice for condition: \(weather.condition.rawValue)")
        advice = Self.buildAdvice(weather: weather)
    }

    func sendMessage(_ text: String, weather: WeatherSnapshot) async {
        chatMessages.append(ChatMessage(role: .user, text: text))
        isThinking = true
        defer { isThinking = false }
        // Simulate an AI response based on keyword matching + weather context
        let response = await Task.detached(priority: .userInitiated) {
            Self.generateChatResponse(userInput: text, weather: weather)
        }.value
        chatMessages.append(ChatMessage(role: .assistant, text: response))
    }

    // MARK: - Advice generation (Stylus 1s knowledge base)
    private static func buildAdvice(weather: WeatherSnapshot) -> ShootingAdvice {
        let settings: CameraSettings
        let technical: String
        let composition: String
        let equipment: String
        let lightDesc: String

        switch weather.condition {
        case .goldenHour:
            settings = CameraSettings(
                iso: "ISO 100",
                aperture: "f/2.8",
                shutterSpeed: "1/500s",
                whiteBalance: "Shade (7500K)",
                exposureCompensation: "-0.7 EV",
                focusMode: "Single AF (S-AF)",
                shootingMode: "Aperture Priority (A)",
                isoNote: "Noise free",
                apertureNote: "Warm bokeh",
                shutterNote: "Freeze motion"
            )
            technical = "Golden hour luminance on the Stylus 1s rewards f/2.8 for glowing bokeh. Dial in -0.7 EV to prevent sky blow-out. Use Shade WB to amplify warmth rather than letting AWB cool it down."
            composition = "Rule of thirds — position the horizon on the lower third and let the warm sky fill the frame."
            equipment = "Use a CPL filter to deepen blue sky contrast and reduce reflections off water."
            lightDesc = "Light quality is peaking. Move to high-ground for optimal silhouette opportunities."

        case .blueHour:
            settings = CameraSettings(
                iso: "ISO 400",
                aperture: "f/2.8",
                shutterSpeed: "1/60s",
                whiteBalance: "Tungsten (3200K)",
                exposureCompensation: "+0.3 EV",
                focusMode: "Single AF (S-AF)",
                shootingMode: "Manual (M)",
                isoNote: "Low noise",
                apertureNote: "Max light intake",
                shutterNote: "Hand-hold limit"
            )
            technical = "Blue hour offers a brief window of even, blue-tinted light. At ISO 400 the Stylus 1s retains excellent detail. Use manual mode to lock exposure and bracket ±1 stop."
            composition = "Long leading lines (roads, bridges) converging to a point work beautifully in the cool blue palette."
            equipment = "A small tripod or the in-body stabilisation at minimum. Use the self-timer to eliminate shake."
            lightDesc = "15-minute window of rich blue tones. Lock your settings now."

        case .overcast:
            settings = CameraSettings(
                iso: "ISO 200",
                aperture: "f/5.6",
                shutterSpeed: "1/250s",
                whiteBalance: "Cloudy (6000K)",
                exposureCompensation: "+0.3 EV",
                focusMode: "Continuous AF (C-AF)",
                shootingMode: "Aperture Priority (A)",
                isoNote: "Clean shadows",
                apertureNote: "Flat-light sharpness",
                shutterNote: "Sharp handheld"
            )
            technical = "Overcast skies act as a giant softbox. f/5.6 maximises sharpness across the frame. Slight +0.3 EV lift prevents muddy shadows. Great for portraits — no harsh catch-lights."
            composition = "Fill the frame with your subject; the flat sky adds nothing. Get closer than feels comfortable."
            equipment = "A reflector or white card can bounce light back into shadows under brows and chins for portraits."
            lightDesc = "Soft, directional-free light. Ideal for portraits, macro, and detail shots."

        case .brightSun:
            settings = CameraSettings(
                iso: "ISO 100",
                aperture: "f/8.0",
                shutterSpeed: "1/1000s",
                whiteBalance: "Daylight (5500K)",
                exposureCompensation: "-0.3 EV",
                focusMode: "Single AF (S-AF)",
                shootingMode: "Shutter Priority (S)",
                isoNote: "Base ISO",
                apertureNote: "Deep depth",
                shutterNote: "Freeze fast motion"
            )
            technical = "Bright midday sun is high-contrast. f/8 gives deep depth-of-field and eliminates diffraction. Expose for the highlights (-0.3 EV) and recover shadows in post."
            composition = "Shoot into open shade or wait for clouds. If shooting in sun, use hard shadows as a design element."
            equipment = "A lens hood is essential. Consider an ND filter to allow wider apertures in very bright conditions."
            lightDesc = "High contrast, harsh shadows. Best for architecture and abstract texture."

        case .cloudy:
            settings = CameraSettings(
                iso: "ISO 200",
                aperture: "f/4.0",
                shutterSpeed: "1/320s",
                whiteBalance: "Cloudy (6000K)",
                exposureCompensation: "0 EV",
                focusMode: "Continuous AF (C-AF)",
                shootingMode: "Program (P)",
                isoNote: "Clean",
                apertureNote: "Balanced",
                shutterNote: "Sharp"
            )
            technical = "Partial cloud cover produces mixed lighting. Programme mode with AWB lets the Stylus 1s react quickly to changing patches of light and shadow."
            composition = "Watch for a shaft of light breaking through — position your subject in that pool and shoot quickly."
            equipment = "Keep lens dry. Carry a microfibre cloth to clean front element if drops land."
            lightDesc = "Variable light with interesting drama when sun breaks through."

        case .rain:
            settings = CameraSettings(
                iso: "ISO 400",
                aperture: "f/2.8",
                shutterSpeed: "1/125s",
                whiteBalance: "Cloudy (6500K)",
                exposureCompensation: "+0.7 EV",
                focusMode: "Continuous AF (C-AF)",
                shootingMode: "Aperture Priority (A)",
                isoNote: "Light sensitivity",
                apertureNote: "Max intake",
                shutterNote: "Freeze raindrops"
            )
            technical = "Rain photography rewards moody, high-contrast images. The Stylus 1s is NOT weather-sealed — shoot from under cover or use a rain sleeve. +0.7 EV compensates for the dark grey sky metering bias."
            composition = "Reflections in puddles mirror entire scenes — get low and shoot at water level."
            equipment = "⚠️ The Stylus 1s is not weather-sealed. Use a rain cover or plastic bag with a cut-out for the lens."
            lightDesc = "Dramatic, moody light. Protect the camera — it is NOT waterproof."

        case .snow:
            settings = CameraSettings(
                iso: "ISO 200",
                aperture: "f/5.6",
                shutterSpeed: "1/500s",
                whiteBalance: "Daylight (5500K)",
                exposureCompensation: "+1.0 EV",
                focusMode: "Single AF (S-AF)",
                shootingMode: "Aperture Priority (A)",
                isoNote: "Detail in snow",
                apertureNote: "Crisp flakes",
                shutterNote: "Freeze snowflakes"
            )
            technical = "Snow is highly reflective — your meter will underexpose by 1.5 stops. +1.0 EV keeps snow white rather than grey. Battery life drops in cold; keep spare warm in a pocket."
            composition = "Look for a single colourful subject contrasting against the white expanse — a red door, a dark tree silhouette."
            equipment = "Condensation forms when bringing a cold camera indoors. Seal it in a zip-lock bag first and let it warm slowly."
            lightDesc = "Bright, reflective scene. Compensate exposure aggressively."

        case .night:
            settings = CameraSettings(
                iso: "ISO 1600",
                aperture: "f/2.8",
                shutterSpeed: "4s",
                whiteBalance: "Tungsten (3200K)",
                exposureCompensation: "0 EV",
                focusMode: "Manual Focus (MF)",
                shootingMode: "Manual (M)",
                isoNote: "Acceptable noise",
                apertureNote: "Max light",
                shutterNote: "Light trails"
            )
            technical = "Night shooting requires a tripod and manual focus (auto-focus hunts in darkness). The Stylus 1s noise at ISO 1600 is manageable. Use the built-in intervalometer for star trails."
            composition = "Frame lights sources — street lamps, car trails, illuminated windows — to lead the eye through the scene."
            equipment = "Tripod mandatory. Use the 2-second self-timer or an OA-TC1 remote to prevent shutter-tap shake."
            lightDesc = "Long exposure territory. A tripod is not optional."
        }

        return ShootingAdvice(
            settings: settings,
            technicalAnalysis: technical,
            compositionTip: composition,
            equipmentTip: equipment,
            lightQualityDescription: lightDesc,
            lightWindowSeconds: nil
        )
    }

    // MARK: - Chat response generator
    private static func generateChatResponse(userInput: String, weather: WeatherSnapshot) -> String {
        let input = userInput.lowercased()
        let c = weather.condition

        if input.contains("white balance") || input.contains("wb") || input.contains("colour") || input.contains("color") {
            return "For \(c.rawValue) at \(weather.temperatureKelvin)K, I'd set White Balance to \(Self.buildAdvice(weather: weather).settings.whiteBalance). On the Stylus 1s, go to Menu → Shooting Menu 1 → WB and select it manually — this stops AWB from second-guessing the warm or cool cast that makes the light interesting."
        }
        if input.contains("iso") {
            return "For \(c.rawValue) I recommend \(Self.buildAdvice(weather: weather).settings.iso). On the Stylus 1s, press the Fn1 button (or dive into the Super Control Panel via OK button) and dial the ISO wheel. Stay at base ISO whenever your shutter speed is above 1/30s."
        }
        if input.contains("aperture") || input.contains("f/") || input.contains("depth") {
            return "Set \(Self.buildAdvice(weather: weather).settings.aperture). On the Stylus 1s in Aperture Priority (A mode), rotate the rear dial to change aperture. The lens is sharpest between f/4–f/8 for landscapes, and f/2.8–f/4 for portraits with subject isolation."
        }
        if input.contains("shutter") || input.contains("motion") || input.contains("blur") {
            return "Use \(Self.buildAdvice(weather: weather).settings.shutterSpeed). Switch to Shutter Priority (S mode) on the mode dial, then spin the rear dial. For motion blur intentionally, drop to 1/30s or slower — the Stylus 1s optical stabilisation (IS) handles 3–4 stops of hand-held compensation."
        }
        if input.contains("focus") {
            return "For \(c.rawValue), I suggest \(Self.buildAdvice(weather: weather).settings.focusMode). On the Stylus 1s, tap the AF mode button (lower-left of the lens ring area) or assign it to Fn2. For tricky low-contrast scenes, use Manual Focus and zoom in via the MF Assist feature to nail precision."
        }
        if input.contains("barn") || input.contains("texture") || input.contains("wood") {
            return "For weathered textures under diffused \(c.rawValue) light, try f/8 for maximum edge-to-edge sharpness and set White Balance to Cloudy (6000K) to add a subtle warm cast that brings out wood grain and rust. Side-lighting (if available) will rake across the surface and emphasise texture. +0.3 EV prevents shadow detail going muddy."
        }
        if input.contains("portrait") || input.contains("person") || input.contains("face") {
            return "Portraits in \(c.rawValue): use f/2.8–f/4 for subject separation, C-AF to track your subject's eye, and Shade WB to flatter skin tones. The Stylus 1s Face Priority AF (FP) mode does a reliable job — enable it via the AF target selector."
        }
        if input.contains("sunset") || input.contains("sunrise") || input.contains("golden") {
            return "Golden hour on the Stylus 1s: f/2.8, 1/500s, ISO 100, White Balance set to Shade (7500K) — this boosts the amber and orange tones rather than neutralising them. Use -0.7 EV exposure compensation so the sky doesn't blow out. Frame the sun just outside the corner of the frame for a natural lens-flare effect."
        }

        // Default response
        let adv = Self.buildAdvice(weather: weather)
        return "For your current \(c.rawValue) conditions, I'd suggest starting with \(adv.settings.iso), \(adv.settings.aperture), \(adv.settings.shutterSpeed) and WB set to \(adv.settings.whiteBalance) on the Stylus 1s. \(adv.technicalAnalysis)"
    }
}
