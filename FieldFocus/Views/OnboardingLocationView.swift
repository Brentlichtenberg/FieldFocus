import SwiftUI
import CoreLocation
import MapKit

// MARK: - Persistent model (mirrors LocationSearchView — same UserDefaults key)

private struct RecentLocation: Identifiable, Codable {
    let id: UUID
    let name: String
    let latitude: Double
    let longitude: Double

    init(name: String, latitude: Double, longitude: Double) {
        self.id = UUID()
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }

    private static let key = "FieldFocus.recentLocations"

    static func loadAll() -> [RecentLocation] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let items = try? JSONDecoder().decode([RecentLocation].self, from: data)
        else { return [] }
        return items
    }

    static func save(_ location: RecentLocation) {
        var all = loadAll().filter { $0.name != location.name }
        all.insert(location, at: 0)
        if let data = try? JSONEncoder().encode(Array(all.prefix(10))) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}

// MARK: - Search result model

private struct OnboardingResult: Identifiable {
    let id = UUID()
    let name: String
    let subtitle: String?
    let coordinate: CLLocationCoordinate2D
}

// MARK: - View

struct OnboardingLocationView: View {
    @Binding var hasCompletedOnboarding: Bool
    let onComplete: () -> Void

    @EnvironmentObject var locationService: LocationService

    @State private var searchText = ""
    @State private var searchResults: [OnboardingResult] = []
    @State private var isSearching = false
    @State private var recentLocations: [RecentLocation] = []
    @State private var searchTask: Task<Void, Never>?
    @State private var waitingForGPS = false

    var body: some View {
        ZStack(alignment: .top) {
            FieldFocusTheme.Color.background.ignoresSafeArea()

            VStack(spacing: 0) {
                headerBar
                ScrollView {
                    VStack(spacing: FieldFocusTheme.Spacing.md) {
                        searchBar
                        if searchText.isEmpty {
                            gpsButton
                            if !recentLocations.isEmpty {
                                recentLocationsList
                            }
                        } else {
                            searchResultsList
                        }
                    }
                    .padding(FieldFocusTheme.Spacing.pagePad)
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear { recentLocations = RecentLocation.loadAll() }
        .onChange(of: locationService.currentLocation) { _, location in
            guard waitingForGPS, let location else { return }
            let name = locationService.locationName.isEmpty ? "Current Location" : locationService.locationName
            RecentLocation.save(RecentLocation(
                name: name,
                latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude
            ))
            finish()
        }
    }

    // MARK: - Header

    private var headerBar: some View {
        HStack {
            Spacer()
            VStack(spacing: 6) {
                Image(systemName: "camera.aperture")
                    .font(.system(size: 26))
                    .foregroundColor(FieldFocusTheme.Color.orange)
                Text("WHERE ARE YOU SHOOTING?")
                    .font(FieldFocusTheme.Typography.labelCaps())
                    .foregroundColor(.white)
                    .kerning(0.8)
            }
            Spacer()
        }
        .padding(.horizontal, FieldFocusTheme.Spacing.pagePad)
        .padding(.vertical, FieldFocusTheme.Spacing.lg)
        .background(FieldFocusTheme.Color.navyDark)
    }

    // MARK: - Search bar

    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(FieldFocusTheme.Color.textSecondary)
            TextField("Search city, zip code, or address…", text: $searchText)
                .font(FieldFocusTheme.Typography.bodyMD())
                .foregroundColor(FieldFocusTheme.Color.textPrimary)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.words)
            if isSearching {
                ProgressView().tint(FieldFocusTheme.Color.orange)
            } else if !searchText.isEmpty {
                Button {
                    searchText = ""
                    searchResults = []
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(FieldFocusTheme.Color.textSecondary)
                }
            }
        }
        .padding(FieldFocusTheme.Spacing.md)
        .background(FieldFocusTheme.Color.surface)
        .cornerRadius(FieldFocusTheme.Radius.base)
        .overlay(
            RoundedRectangle(cornerRadius: FieldFocusTheme.Radius.base)
                .stroke(FieldFocusTheme.Color.outline, lineWidth: 1)
        )
        .onChange(of: searchText) { _, newValue in
            searchTask?.cancel()
            guard !newValue.trimmingCharacters(in: .whitespaces).isEmpty else {
                searchResults = []
                return
            }
            searchTask = Task {
                try? await Task.sleep(for: .milliseconds(500))
                guard !Task.isCancelled else { return }
                await performSearch(query: newValue)
            }
        }
    }

    // MARK: - Search results

    private var searchResultsList: some View {
        VStack(alignment: .leading, spacing: FieldFocusTheme.Spacing.sm) {
            if !isSearching && searchResults.isEmpty {
                Text("No results — try a city, zip code, or address.")
                    .font(FieldFocusTheme.Typography.bodySM())
                    .foregroundColor(FieldFocusTheme.Color.textSecondary)
                    .padding(.vertical, FieldFocusTheme.Spacing.sm)
            }
            ForEach(searchResults) { result in
                locationRow(icon: "mappin.circle", title: result.name, subtitle: result.subtitle) {
                    selectResult(result)
                }
            }
        }
    }

    // MARK: - GPS button

    private var gpsButton: some View {
        Button {
            waitingForGPS = true
            locationService.startUpdating()
        } label: {
            HStack {
                Image(systemName: waitingForGPS ? "location.north.line.fill" : "location.fill")
                    .foregroundColor(FieldFocusTheme.Color.orange)
                VStack(alignment: .leading, spacing: 2) {
                    Text(waitingForGPS ? "DETECTING LOCATION…" : "USE CURRENT LOCATION")
                        .font(FieldFocusTheme.Typography.labelCaps())
                        .foregroundColor(FieldFocusTheme.Color.textPrimary)
                        .kerning(0.8)
                    Text(waitingForGPS ? "Please wait" : "GPS auto-detect")
                        .font(FieldFocusTheme.Typography.bodySM())
                        .foregroundColor(FieldFocusTheme.Color.textSecondary)
                }
                Spacer()
                if waitingForGPS {
                    ProgressView().tint(FieldFocusTheme.Color.orange)
                } else {
                    Image(systemName: "chevron.right")
                        .foregroundColor(FieldFocusTheme.Color.textSecondary)
                }
            }
            .padding(FieldFocusTheme.Spacing.md)
            .background(FieldFocusTheme.Color.surface)
            .cornerRadius(FieldFocusTheme.Radius.base)
            .overlay(
                RoundedRectangle(cornerRadius: FieldFocusTheme.Radius.base)
                    .stroke(FieldFocusTheme.Color.orange.opacity(0.4), lineWidth: 1.5)
            )
        }
        .disabled(waitingForGPS)
    }

    // MARK: - Recent locations

    private var recentLocationsList: some View {
        VStack(alignment: .leading, spacing: FieldFocusTheme.Spacing.sm) {
            Text("RECENT LOCATIONS")
                .font(FieldFocusTheme.Typography.labelCaps())
                .foregroundColor(FieldFocusTheme.Color.textSecondary)
                .kerning(0.8)
            ForEach(recentLocations) { recent in
                locationRow(icon: "clock.arrow.circlepath", title: recent.name, subtitle: nil) {
                    selectRecent(recent)
                }
            }
        }
    }

    // MARK: - Shared row

    private func locationRow(icon: String, title: String, subtitle: String?, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(FieldFocusTheme.Color.textSecondary)
                    .font(.system(size: 14))
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(FieldFocusTheme.Typography.bodyMD())
                        .foregroundColor(FieldFocusTheme.Color.textPrimary)
                        .multilineTextAlignment(.leading)
                    if let subtitle {
                        Text(subtitle)
                            .font(FieldFocusTheme.Typography.bodySM())
                            .foregroundColor(FieldFocusTheme.Color.textSecondary)
                    }
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 12))
                    .foregroundColor(FieldFocusTheme.Color.textSecondary)
            }
            .padding(FieldFocusTheme.Spacing.md)
            .background(FieldFocusTheme.Color.surface)
            .cornerRadius(FieldFocusTheme.Radius.base)
            .overlay(
                RoundedRectangle(cornerRadius: FieldFocusTheme.Radius.base)
                    .stroke(FieldFocusTheme.Color.outline, lineWidth: 1)
            )
        }
    }

    // MARK: - Actions

    @MainActor
    private func performSearch(query: String) async {
        isSearching = true
        defer { isSearching = false }

        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.resultTypes = [.address, .pointOfInterest]

        do {
            let response = try await MKLocalSearch(request: request).start()
            searchResults = response.mapItems.prefix(6).compactMap { item in
                guard let location = item.placemark.location else { return nil }
                let name = item.placemark.locality
                    ?? item.name
                    ?? item.placemark.postalCode
                    ?? "Unknown"
                let subtitleParts = [
                    item.placemark.administrativeArea,
                    item.placemark.country
                ].compactMap { $0 }
                let subtitle = subtitleParts.isEmpty ? nil : subtitleParts.joined(separator: ", ")
                return OnboardingResult(name: name, subtitle: subtitle, coordinate: location.coordinate)
            }
        } catch {
            searchResults = []
        }
    }

    private func selectResult(_ result: OnboardingResult) {
        RecentLocation.save(RecentLocation(
            name: result.name,
            latitude: result.coordinate.latitude,
            longitude: result.coordinate.longitude
        ))
        locationService.setManualLocation(coordinate: result.coordinate, name: result.name)
        finish()
    }

    private func selectRecent(_ recent: RecentLocation) {
        locationService.setManualLocation(
            coordinate: CLLocationCoordinate2D(latitude: recent.latitude, longitude: recent.longitude),
            name: recent.name
        )
        finish()
    }

    private func finish() {
        onComplete()
        hasCompletedOnboarding = true
    }
}
