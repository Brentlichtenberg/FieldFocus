import SwiftUI

/// "Select Shooting Location" screen — matches the Stitch location screen.
struct LocationSearchView: View {
    @EnvironmentObject var locationService: LocationService
    @Environment(\.dismiss) private var dismiss

    @State private var searchText = ""
    @State private var recentLocations: [String] = ["Bryant Park, NY", "Santa Monica Pier, CA", "Yosemite National Park, CA"]

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                FieldFocusTheme.Color.background.ignoresSafeArea()

                VStack(spacing: 0) {
                    headerBar
                    ScrollView {
                        VStack(spacing: FieldFocusTheme.Spacing.md) {
                            searchBar
                            manualEntryButton
                            recentLocationsList
                        }
                        .padding(FieldFocusTheme.Spacing.pagePad)
                    }
                }
            }
            .navigationBarHidden(true)
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
            // Balance spacer
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
        }
        .padding(FieldFocusTheme.Spacing.md)
        .background(FieldFocusTheme.Color.surface)
        .cornerRadius(FieldFocusTheme.Radius.base)
        .overlay(
            RoundedRectangle(cornerRadius: FieldFocusTheme.Radius.base)
                .stroke(FieldFocusTheme.Color.outline, lineWidth: 1)
        )
    }

    // MARK: - Manual (GPS) entry
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

    // MARK: - Recent locations list
    private var recentLocationsList: some View {
        VStack(alignment: .leading, spacing: FieldFocusTheme.Spacing.sm) {
            Text("RECENT LOCATIONS")
                .font(FieldFocusTheme.Typography.labelCaps())
                .foregroundColor(FieldFocusTheme.Color.textSecondary)
                .kerning(0.8)

            ForEach(recentLocations, id: \.self) { place in
                Button {
                    // In a real app this would geocode the place name
                    dismiss()
                } label: {
                    HStack {
                        Image(systemName: "clock.arrow.circlepath")
                            .foregroundColor(FieldFocusTheme.Color.textSecondary)
                            .font(.system(size: 14))
                        Text(place)
                            .font(FieldFocusTheme.Typography.bodyMD())
                            .foregroundColor(FieldFocusTheme.Color.textPrimary)
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
        }
    }
}

#Preview {
    LocationSearchView()
        .environmentObject(LocationService())
}
