import Foundation
import CoreLocation
import Combine
import os.log

private let logger = Logger(subsystem: "com.appsOnapps.FieldFocus", category: "WeatherService")

/// Fetches weather data from Open-Meteo (no API key required).
@MainActor
final class WeatherService: ObservableObject {
    @Published var snapshot: WeatherSnapshot = .placeholder
    @Published var isLoading = false
    @Published var error: String?

    private let session = URLSession.shared

    func fetchWeather(for location: CLLocation) async {
        isLoading = true
        error = nil
        defer { isLoading = false }

        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude
        let urlString = "https://api.open-meteo.com/v1/forecast?latitude=\(lat)&longitude=\(lon)&current=weathercode,windspeed_10m,winddirection_10m,cloudcover&daily=sunrise,sunset&timezone=auto&forecast_days=1"

        guard let url = URL(string: urlString) else { return }

        do {
            let (data, _) = try await session.data(from: url)
            let decoded = try JSONDecoder().decode(OpenMeteoResponse.self, from: data)
            snapshot = decoded.toWeatherSnapshot(locationName: snapshot.locationName)
            logger.info("Weather fetched: \(self.snapshot.condition.rawValue)")
        } catch {
            self.error = error.localizedDescription
            logger.error("Weather fetch failed: \(error.localizedDescription)")
        }
    }
}

// MARK: - Open-Meteo response models
private struct OpenMeteoResponse: Decodable {
    struct Current: Decodable {
        let weathercode: Int
        let windspeed10m: Double
        let winddirection10m: Double
        let cloudcover: Int
        enum CodingKeys: String, CodingKey {
            case weathercode
            case windspeed10m    = "windspeed_10m"
            case winddirection10m = "winddirection_10m"
            case cloudcover
        }
    }
    struct Daily: Decodable {
        let sunrise: [String]
        let sunset: [String]
    }
    let current: Current
    let daily: Daily

    func toWeatherSnapshot(locationName: String) -> WeatherSnapshot {
        let condition = LightCondition.from(weatherCode: current.weathercode, cloudCover: current.cloudcover)
        let direction = cardinalDirection(degrees: current.winddirection10m)
        let iso = ISO8601DateFormatter()
        iso.formatOptions = [.withInternetDateTime]
        let sunrise = daily.sunrise.first.flatMap { iso.date(from: $0 + ":00") }
        let sunset  = daily.sunset.first.flatMap  { iso.date(from: $0 + ":00") }
        let goldenStart = sunset.map { $0.addingTimeInterval(-45 * 60) }
        let goldenEnd   = sunset.map { $0.addingTimeInterval(20 * 60) }
        return WeatherSnapshot(
            condition: condition,
            temperatureKelvin: colorTemperature(for: condition),
            cloudCoverPercent: current.cloudcover,
            windSpeedMPH: current.windspeed10m * 0.621371,
            windDirectionCardinal: direction,
            goldenHourStart: goldenStart,
            goldenHourEnd: goldenEnd,
            sunriseTime: sunrise,
            sunsetTime: sunset,
            locationName: locationName
        )
    }
}

private func cardinalDirection(degrees: Double) -> String {
    let directions = ["N","NE","E","SE","S","SW","W","NW"]
    let index = Int((degrees / 45.0).rounded()) % 8
    return directions[index]
}

private func colorTemperature(for condition: LightCondition) -> Int {
    switch condition {
    case .goldenHour: return 3200
    case .blueHour:   return 8000
    case .overcast:   return 6500
    case .brightSun:  return 5500
    case .cloudy:     return 6000
    case .rain:       return 7000
    case .snow:       return 6500
    case .night:      return 3400
    }
}

private extension LightCondition {
    static func from(weatherCode: Int, cloudCover: Int) -> LightCondition {
        switch weatherCode {
        case 71...77: return .snow
        case 80...82, 85, 86, 95...99: return .rain
        case 51...67: return .rain
        case 45, 48: return .overcast
        default:
            switch cloudCover {
            case 0...20:  return .brightSun
            case 21...60: return .cloudy
            default:      return .overcast
            }
        }
    }
}
