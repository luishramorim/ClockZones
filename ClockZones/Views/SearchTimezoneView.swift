//
//  SearchTimezoneView.swift
//  ClockZones
//
//  Created by Luis Amorim on 25/02/25.
//

import SwiftUI
import CoreData

/// A view that loads a JSON of timezones, allows searching through them via the navigation bar search field,
/// and lets the user add a selected timezone to Core Data by tapping on the row.
/// After adding, the view dismisses itself.
struct SearchTimezoneView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss

    /// The text entered for searching the JSON.
    @State private var searchText: String = ""
    /// All timezones loaded from the JSON.
    @State private var jsonTimezones: [TimezoneEntry] = []
    /// The filtered timezones based on the search text.
    @State private var filteredTimezones: [TimezoneEntry] = []

    var body: some View {
        NavigationView {
            List(filteredTimezones) { entry in
                // Wrap the entire row in a button to add the timezone when tapped.
                Button(action: {
                    addTimezone(entry: entry)
                }) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(entry.value)
                            .font(.headline)
                            .foregroundColor(.primary)
                        Text("UTC: \(formattedOffset(for: entry.offset))")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Add timezone")
            // Place the search field in the navigation view.
            .searchable(text: $searchText)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
            .onAppear(perform: loadJSON)
            // Filter the JSON whenever the search text changes.
            .onChange(of: searchText) {
                filterJSON()
            }
            
        }
    }
    
    /// Loads the JSON file from the bundle and decodes it into an array of TimezoneEntry.
    private func loadJSON() {
        guard let url = Bundle.main.url(forResource: "timezones", withExtension: "json") else {
            print("File timezones.json not found.")
            return
        }
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let entries = try decoder.decode([TimezoneEntry].self, from: data)
            jsonTimezones = entries
            // Initially display all entries.
            filteredTimezones = entries
        } catch {
            print("Error when load the JSON file: \(error)")
        }
    }
    
    /// Filters the loaded timezones based on the search text.
    private func filterJSON() {
        if searchText.isEmpty {
            filteredTimezones = jsonTimezones
        } else {
            filteredTimezones = jsonTimezones.filter { entry in
                entry.text.localizedCaseInsensitiveContains(searchText) ||
                entry.value.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    /// Adds the selected timezone entry to Core Data and dismisses the view.
    /// - Parameter entry: The TimezoneEntry selected by the user.
    private func addTimezone(entry: TimezoneEntry) {
        let newTz = Timezone(context: viewContext)
        newTz.id = UUID()
        newTz.value = entry.value
        newTz.abbr = entry.abbr
        newTz.offset = entry.offset
        newTz.isdst = entry.isdst
        newTz.text = entry.text
        newTz.utc = entry.utc.joined(separator: ", ")
        
        do {
            try viewContext.save()
            print("Timezone added!")
            // Dismiss the sheet after adding the timezone.
            dismiss()
        } catch {
            print("Error find a new timezone: \(error.localizedDescription)")
        }
    }
    
    /// Formats a Double offset into a string showing hours and minutes.
    /// - Parameter offset: The timezone offset as a Double.
    /// - Returns: A formatted string, for example "+1:30" if offset is 1.5.
    func formattedOffset(for offset: Double) -> String {
        let absOffset = abs(offset)
        let hours = Int(absOffset)
        let minutes = absOffset - Double(hours)
        // Convert 0.5 to 30 minutes; otherwise, 0.
        let minuteValue = minutes == 0.5 ? 30 : 0
        let sign = offset < 0 ? "-" : "+"
        return "\(sign)\(hours):\(String(format: "%02d", minuteValue))"
    }
}

#Preview {
    SearchTimezoneView()
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
