import SwiftUI

struct ContentView: View {
    @EnvironmentObject var locationService: LocationService
    @EnvironmentObject var weatherService: WeatherService
    @EnvironmentObject var advisorService: PhotographyAdvisorService

    @State private var selectedTab: AppTab = .guide

    enum AppTab: String, CaseIterable {
        case guide   = "Guide"
        case advice  = "Advice"
        case chat    = "Chat"
        case gear    = "Gear"

        var icon: String {
            switch self {
            case .guide:  return "location.north.fill"
            case .advice: return "sun.max.fill"
            case .chat:   return "bubble.left.and.bubble.right.fill"
            case .gear:   return "camera.fill"
            }
        }
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            WelcomeView()
                .tabItem { Label("Guide", systemImage: "location.north.fill") }
                .tag(AppTab.guide)

            ShootingAdviceView()
                .tabItem { Label("Advice", systemImage: "sun.max.fill") }
                .tag(AppTab.advice)

            AIAssistantView()
                .tabItem { Label("Chat", systemImage: "bubble.left.and.bubble.right.fill") }
                .tag(AppTab.chat)

            GearView()
                .tabItem { Label("Gear", systemImage: "camera.fill") }
                .tag(AppTab.gear)
        }
        .tint(FieldFocusTheme.Color.orange)
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

#Preview {
    ContentView()
        .environmentObject(LocationService())
        .environmentObject(WeatherService())
        .environmentObject(PhotographyAdvisorService())
}
