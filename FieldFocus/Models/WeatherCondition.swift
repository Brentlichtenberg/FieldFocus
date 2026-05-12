import Foundation

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
    var goldenHourStart: Date?
    var goldenHourEnd: Date?
    var sunriseTime: Date?
    var sunsetTime: Date?
    var locationName: String

    static let placeholder = WeatherSnapshot(
        condition: .goldenHour,
        temperatureKelvin: 5400,
        cloudCoverPercent: 12,
        windSpeedMPH: 8,
        windDirectionCardinal: "NW",
        goldenHourStart: nil,
        goldenHourEnd: nil,
        sunriseTime: nil,
        sunsetTime: nil,
        locationName: "Current Location"
    )
}
