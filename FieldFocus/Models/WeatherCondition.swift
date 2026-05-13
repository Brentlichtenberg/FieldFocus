import Foundation

// MARK: - Day Phase
/// Describes where in the solar day the current moment falls.
enum DayPhase: String {
    case nightPreDawn   = "Pre-Dawn"
    case blueHourMorn   = "Blue Hour"
    case goldenMorn     = "Golden Morning"
    case earlyMorning   = "Early Morning"
    case morning        = "Morning"
    case solarNoon      = "Solar Noon"
    case afternoon      = "Afternoon"
    case lateAfternoon  = "Late Afternoon"
    case goldenEvening  = "Golden Evening"
    case blueHourEve    = "Twilight"
    case nightPostDusk  = "Night"

    /// Derives the current day phase from sunrise/sunset times.
    /// Falls back to clock-hour heuristics when sun data is unavailable.
    static func compute(sunrise: Date?, sunset: Date?, now: Date = Date()) -> DayPhase {
        guard let sunrise, let sunset else {
            let hour = Calendar.current.component(.hour, from: now)
            switch hour {
            case 0..<5:   return .nightPreDawn
            case 5..<6:   return .blueHourMorn
            case 6..<8:   return .goldenMorn
            case 8..<11:  return .morning
            case 11..<14: return .solarNoon
            case 14..<17: return .afternoon
            case 17..<19: return .lateAfternoon
            case 19..<20: return .goldenEvening
            case 20..<21: return .blueHourEve
            default:      return .nightPostDusk
            }
        }

        let dayLength   = sunset.timeIntervalSince(sunrise)
        let solarNoon   = sunrise.addingTimeInterval(dayLength / 2)

        let blueMornStart  = sunrise.addingTimeInterval(-30 * 60)
        let goldenMornEnd  = sunrise.addingTimeInterval(45 * 60)
        let earlyMornEnd   = sunrise.addingTimeInterval(3 * 3600)
        let solarNoonStart = solarNoon.addingTimeInterval(-2 * 3600)
        let solarNoonEnd   = solarNoon.addingTimeInterval(2 * 3600)
        let lateAftStart   = sunset.addingTimeInterval(-3 * 3600)
        let goldenEveStart = sunset.addingTimeInterval(-45 * 60)
        let goldenEveEnd   = sunset.addingTimeInterval(20 * 60)
        let blueEveEnd     = sunset.addingTimeInterval(50 * 60)

        if now < blueMornStart  { return .nightPreDawn }
        if now < sunrise        { return .blueHourMorn }
        if now < goldenMornEnd  { return .goldenMorn }
        if now < solarNoonStart { return now < earlyMornEnd ? .earlyMorning : .morning }
        if now < solarNoonEnd   { return .solarNoon }
        if now < lateAftStart   { return .afternoon }
        if now < goldenEveStart { return .lateAfternoon }
        if now < goldenEveEnd   { return .goldenEvening }
        if now < blueEveEnd     { return .blueHourEve }
        return .nightPostDusk
    }
}

// MARK: - Light Condition
enum LightCondition: String, CaseIterable, Identifiable {
    case goldenHour  = "Golden Hour"
    case blueHour    = "Blue Hour"
    case overcast    = "Overcast"
    case brightSun   = "Bright Sun"
    case cloudy      = "Cloudy"
    case rain        = "Rain"
    case snow        = "Snow"
    case night       = "Night"

    var id: String { rawValue }

    var systemIcon: String {
        switch self {
        case .goldenHour:  return "sun.horizon.fill"
        case .blueHour:    return "moon.haze.fill"
        case .overcast:    return "cloud.fill"
        case .brightSun:   return "sun.max.fill"
        case .cloudy:      return "cloud.sun.fill"
        case .rain:        return "cloud.rain.fill"
        case .snow:        return "snowflake"
        case .night:       return "moon.stars.fill"
        }
    }
}

struct WeatherSnapshot: Identifiable {
    let id = UUID()
    var condition: LightCondition
    var temperatureKelvin: Int      // color temperature in K
    var cloudCoverPercent: Int
    var windSpeedMPH: Double
    var windDirectionCardinal: String
    var goldenHourStart: Date?          // evening golden hour start
    var goldenHourEnd: Date?            // evening golden hour end
    var morningGoldenHourStart: Date?
    var morningGoldenHourEnd: Date?
    var sunriseTime: Date?
    var sunsetTime: Date?
    var dayPhase: DayPhase
    var locationName: String

    static let placeholder = WeatherSnapshot(
        condition: .goldenHour,
        temperatureKelvin: 5400,
        cloudCoverPercent: 12,
        windSpeedMPH: 8,
        windDirectionCardinal: "NW",
        goldenHourStart: nil,
        goldenHourEnd: nil,
        morningGoldenHourStart: nil,
        morningGoldenHourEnd: nil,
        sunriseTime: nil,
        sunsetTime: nil,
        dayPhase: .solarNoon,
        locationName: "Current Location"
    )
}
