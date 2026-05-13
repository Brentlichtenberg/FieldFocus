import SwiftUI

@main
struct FieldFocusApp: App {
    @StateObject private var locationService = LocationService()
    @StateObject private var weatherService = WeatherService()
    @StateObject private var advisorService = PhotographyAdvisorService()

    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var onboardingInitialTab: ContentView.AppTab = .guide

    var body: some Scene {
        WindowGroup {
            Group {
                if hasCompletedOnboarding {
                    ContentView(initialTab: onboardingInitialTab)
                } else {
                    LandingView(
                        hasCompletedOnboarding: $hasCompletedOnboarding,
                        onComplete: { onboardingInitialTab = .advice }
                    )
                }
            }
            .environmentObject(locationService)
            .environmentObject(weatherService)
            .environmentObject(advisorService)
            .preferredColorScheme(.light)
            .onAppear {
                locationService.requestLocationPermission()
            }
            .onChange(of: locationService.currentLocation) { _, location in
                guard let location else { return }
                Task {
                    await weatherService.fetchWeather(for: location)
                    advisorService.generateAdvice(for: weatherService.snapshot)
                }
            }
            .onChange(of: locationService.locationName) { _, name in
                weatherService.snapshot.locationName = name
            }
        }
    }
}
