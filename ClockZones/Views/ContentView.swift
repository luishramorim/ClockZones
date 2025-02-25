//
//  ContentView.swift
//  ClockZones
//
//  Created by Luis Amorim on 25/02/25.
//

import SwiftUI
import CoreData

/// The main view displaying saved timezones filtered via the built‑in searchable modifier.
/// Each list row shows the timezone's current time (without seconds, updating in real time based on GMT),
/// the timezone's name, and its UTC offset. Tapping a row navigates to a detail view that displays an analog clock for the selected timezone.
struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Timezone.text, ascending: true)],
        animation: .default
    )
    private var timezones: FetchedResults<Timezone>

    /// The search text used to filter the list of saved timezones.
    @State private var searchText: String = ""
    /// Controls the presentation of the search sheet.
    @State private var showingSearchSheet: Bool = false

    /// A computed property that filters timezones from Core Data based on the search text.
    private var filteredTimezones: [Timezone] {
        if searchText.isEmpty {
            return Array(timezones)
        } else {
            return timezones.filter { tz in
                let textMatch = tz.text?.localizedCaseInsensitiveContains(searchText) ?? false
                let valueMatch = tz.value?.localizedCaseInsensitiveContains(searchText) ?? false
                return textMatch || valueMatch
            }
        }
    }

    var body: some View {
        NavigationView {
            Group {
                if filteredTimezones.isEmpty {
                    // Empty view when there are no timezones to display.
                    VStack(spacing: 10) {
                        Image(systemName: "clock.badge.xmark")
                            .font(.system(size: 64))
                            .foregroundStyle(.secondary)
                        
                        Text("No Timezones Available")
                            .bold()
                            .font(.title3)
                            .foregroundColor(.primary)
                        
                        Text("Tap '+' to add a new timezone.")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach(filteredTimezones) { tz in
                            // Each row is a navigation link to the analog clock detail view.
                            NavigationLink(destination: AnalogClockDetailView(timezone: tz)) {
                                VStack(alignment: .leading, spacing: 4) {
                                    // Display current time based on GMT + offset.
                                    RealTimeClockText(timezoneOffset: tz.offset)
                                        .font(.title)
                                        .bold()
                                        .foregroundColor(.blue)
                                    // Display the timezone name.
                                    Text(tz.value ?? "Unknown")
                                        .font(.headline)
                                    // Display the UTC offset.
                                    Text("UTC: \(tz.formattedUTC)")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                .padding(.vertical, 4)
                            }
                        }
                        .onDelete(perform: deleteTimezones)
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("ClockZones")
            .searchable(text: $searchText)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingSearchSheet.toggle() }) {
                        Label("Search and Add", systemImage: "plus")
                    }
                }
            }
            // Present the search sheet to add a new timezone from JSON.
            .sheet(isPresented: $showingSearchSheet) {
                SearchTimezoneView()
            }
        }
    }

    /// Deletes the selected timezones from Core Data.
    /// - Parameter offsets: The index set of items to delete.
    private func deleteTimezones(offsets: IndexSet) {
        withAnimation {
            offsets.map { filteredTimezones[$0] }.forEach(viewContext.delete)
            do {
                try viewContext.save()
            } catch {
                print("Error deleting: \(error.localizedDescription)")
            }
        }
    }
}

extension Timezone {
    /// A computed property to format the offset into a string showing hours and minutes.
    var formattedUTC: String {
        let absOffset = abs(self.offset)
        let hours = Int(absOffset)
        let minutes = absOffset - Double(hours)
        let minuteValue = minutes == 0.5 ? 30 : 0
        let sign = self.offset < 0 ? "-" : "+"
        return "\(sign)\(hours):\(String(format: "%02d", minuteValue))"
    }
}

/// A view that displays the current time (without seconds) updating in real time based on a timezone offset.
/// The base time is set to GMT, and then the offset is applied.
struct RealTimeClockText: View {
    /// The timezone offset in hours.
    var timezoneOffset: Double

    var body: some View {
        TimelineView(.periodic(from: Date(), by: 1)) { timeline in
            // Get the current GMT time.
            let gmtTime = timeline.date
            // Apply the timezone offset (in seconds).
            let adjustedTime = gmtTime.addingTimeInterval(timezoneOffset * 3600)
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            // Set the formatter to GMT so that the base time is always GMT.
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            return Text(formatter.string(from: adjustedTime))
        }
    }
}

#Preview {
    ContentView()
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
