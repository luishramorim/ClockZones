//
//  AnalogClockDetailView.swift
//  ClockZones
//
//  Created by Luis Amorim on 25/02/25.
//

import SwiftUI
import CoreData

/// A detail view that displays an analog clock for the selected timezone,
/// along with a real-time updating display of the current time.
/// The current time is calculated based on GMT.
///
/// The view shows an analog clock and a textual display of the current time,
/// and centers all content on the screen. A toggle is provided to switch between
/// Arabic and Roman numeral representations for the hour markers.
struct AnalogClockDetailView: View {
    /// The selected timezone passed from the main list.
    var timezone: Timezone
    
    /// A state variable to control whether to display Roman numerals.
    @State private var useRoman: Bool = false

    var body: some View {
        VStack {
            
            Spacer()
            
            // Display the analog clock, adjusting for the timezone offset,
            // and using the numeral style specified by the toggle.
            AnalogClockView(isRoman: useRoman, timezoneOffset: timezone.offset)
                .frame(width: 250, height: 250)
                .padding()

            // Display the current time using TimelineView for real-time updates.
            TimelineView(.periodic(from: Date(), by: 1)) { timeline in
                // Adjust the absolute GMT time by the timezone offset.
                let currentDate = timeline.date.addingTimeInterval(timezone.offset * 3600)
                let formatter = DateFormatter()
                // Configure the formatter to use GMT.
                formatter.timeZone = TimeZone(secondsFromGMT: 0)
                formatter.dateFormat = "HH:mm"
                return Text(formatter.string(from: currentDate))
                    .font(.title)
                    .bold()
                    .foregroundStyle(.blue)
                    .padding()
            }
            
            Spacer()
            
            // Toggle for switching numeral style.
            Toggle("Roman Numerals", isOn: $useRoman)
                .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)  // Center the content.
        .navigationTitle(timezone.value ?? "Unknown")
    }
}

#Preview {
    // For preview purposes, create a dummy timezone.
    let context = PersistenceController.shared.container.viewContext
    let dummyTimezone = Timezone(context: context)
    dummyTimezone.value = "Test Timezone"
    dummyTimezone.offset = 1.5
    dummyTimezone.text = "Test Timezone"
    return NavigationView {
        AnalogClockDetailView(timezone: dummyTimezone)
    }
}
