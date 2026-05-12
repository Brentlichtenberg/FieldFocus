import SwiftUI
import MapKit

// MARK: - Persistent recent location

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

    static func clearAll() {
        UserDefaults.standard.removeObject(forKey: key)
    }
}

// MARK: - View

struct LocationSearchView: View {
    @EnvironmentObject var locationService: LocationService
    @Environment(\.dismiss) private var dismiss

    @State private var searchText = ""
    @State private var searchResults: [MKMapItem] = []
    @State private var isSearching = false
    @State private var recentLocations: [RecentLocation] = []
    @State private var searchTask: Task<Void, Never>?

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                FieldFocusTheme.Color.background.ignoresSafeArea()

                VStack(spacing: 0) {
                    headerBar
                    ScrollView {
                        VStack(spacing: FieldFocusTheme.Spacing.md) {
                            searchBar
                            if searchText.isEmpty {
                                manualEntryButton
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
        }
    }

    // MARK: - Header

    private var headerBar: some View {
        HStack {
            Button { dismiss() } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
            }
            Spacer()
            Text("WHERE ARE YOU SHOOTING?")
                .font(FieldFocusTheme.Typography.labelCaps())
                .foregroundColor(.white)
                .kerning(0.8)
            Spacer()
            Image(systemName: "xmark").opacity(0)
        }
        .padding(.horizontal, FieldFocusTheme.Spacing.pagePad)
        .padding(.vertical, FieldFocusTheme.Spacing.md)
        .background(FieldFocusTheme.Color.navyDark)
    }

    // MARK: - Search bar

    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(FieldFocusTheme.Color.textSecondary)
            TextField("Search location…", text: $searchText)
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
                Text("No results — try a city, landmark, or address.")
                    .font(FieldFocusTheme.Typography.bodySM())
                    .foregroundColor(FieldFocusTheme.Color.textSecondary)
                    .padding(.vertical, FieldFocusTheme.Spacing.sm)
            }
            ForEach(searchResults, id: \.self) { item in
                let subtitle = [item.placemark.locality, item.placemark.administrativeArea]
                    .compactMap { $0 }.joined(separator: ", ")
                locationRow(icon: "mappin.circle", title: item.name ?? "Unknown", subtitle: subtitle.isEmpty ? nil : subtitle) {
                    selectMapItem(item)
                }
            }
        }
    }

    // MARK: - GPS button

    private var manualEntryButton: some View {
        Button {
            locationService.startUpdating()
            dismiss()
        } label: {
            HStack {
                Image(systemName: "location.fill")
                    .foregroundColor(FieldFocusTheme.Color.orange)
                VStack(alignment: .leading, spacing: 2) {
                    Text("USE CURRENT LOCATION")
                        .font(FieldFocusTheme.Typography.labelCaps())
                        .foregroundColor(FieldFocusTheme.Color.textPrimary)
                        .kerning(0.8)
                    Text("GPS auto-detect")
                        .font(FieldFocusTheme.Typography.bodySM())
                        .foregroundColor(FieldFocusTheme.Color.textSecondary)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(FieldFocusTheme.Color.textSecondary)
            }
            .padding(FieldFocusTheme.Spacing.md)
            .background(FieldFocusTheme.Color.surface)
            .cornerRadius(FieldFocusTheme.Radius.base)
            .overlay(
                RoundedRectangle(cornerRadius: FieldFocusTheme.Radius.base)
                    .stroke(FieldFocusTheme.Color.orange.opacity(0.4), lineWidth: 1.5)
            )
        }
    }

    // MARK: - Recent locations

    private var recentLocationsList: some View {
        VStack(alignment: .leading, spacing: FieldFocusTheme.Spacing.sm) {
            HStack {
                Text("RECENT LOCATIONS")
                    .font(FieldFocusTheme.Typography.labelCaps())
                    .foregroundColor(FieldFocusTheme.Color.textSecondary)
                    .kerning(0.8)
                Spacer()
                Button {
                    RecentLocation.clearAll()
                    recentLocations = []
                } label: {
                    Text("Clear")
                        .font(FieldFocusTheme.Typography.bodySM())
                        .foregroundColor(FieldFocusTheme.Color.orange)
                }
            }
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
        request.resultTypes = [.pointOfInterest, .address]

        do {
            let items: [MKMapItem] = try await withCheckedThrowingContinuation { continuation in
                MKLocalSearch(request: request).start { response, error in
                    if let error {
                        continuation.resume(throwing: error)
                    } else {
                        continuation.resume(returning: response?.mapItems ?? [])
                    }
                }
            }
            searchResults = Array(items.prefix(6))
        } catch {
            searchResults = []
        }
    }

    private func selectMapItem(_ item: MKMapItem) {
        let coordinate = item.placemark.coordinate
        let nameParts = [item.name, item.placemark.locality, item.placemark.administrativeArea]
            .compactMap { $0 }.prefix(2)
        let name = nameParts.isEmpty
            ? (item.placemark.title ?? "Selected Location")
            : nameParts.joined(separator: ", ")

        let recent = RecentLocation(name: name, latitude: coordinate.latitude, longitude: coordinate.longitude)
        RecentLocation.save(recent)

        locationService.setManualLocation(coordinate: coordinate, name: name)
        dismiss()
    }

    private func selectRecent(_ recent: RecentLocation) {
        locationService.setManualLocation(
            coordinate: CLLocationCoordinate2D(latitude: recent.latitude, longitude: recent.longitude),
            name: recent.name
        )
        dismiss()
    }
}

#Preview {
    LocationSearchView()
        .environmentObject(LocationService())
}
