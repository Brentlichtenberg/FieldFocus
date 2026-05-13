import SwiftUI

struct ContentView: View {
    @EnvironmentObject var locationService: LocationService
    @EnvironmentObject var weatherService: WeatherService
    @EnvironmentObject var advisorService: PhotographyAdvisorService

    @State private var selectedTab: AppTab

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

    init(initialTab: AppTab = .guide) {
        _selectedTab = State(initialValue: initialTab)
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
    }
}
