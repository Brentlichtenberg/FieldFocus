import SwiftUI

@main
struct FieldFocusApp: App {
    @StateObject private var locationService = LocationService()
    @StateObject private var weatherService = WeatherService()
    @StateObject private var advisorService = PhotographyAdvisorService()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(locationService)
                .environmentObject(weatherService)
                .environmentObject(advisorService)
                .preferredColorScheme(.light)
        }
    }
}
