//
//  TimeZoneEntry.swift
//  ClockZones
//
//  Created by Luis Amorim on 25/02/25.
//

import Foundation

/// A model representing a timezone entry as defined in the JSON data.
///
/// This structure conforms to `Codable` for easy decoding from JSON, and to `Identifiable` so it can be used in SwiftUI lists.
/// The unique identifier is derived from the `text` property.
struct TimezoneEntry: Codable, Identifiable {
    /// A unique identifier for the timezone entry, using the `text` property.
    var id: String { text }
    
    /// The value identifier of the timezone.
    let value: String
    /// The abbreviation of the timezone.
    let abbr: String
    /// The offset from GMT in hours.
    let offset: Double
    /// A Boolean indicating whether the timezone observes daylight saving time.
    let isdst: Bool
    /// A descriptive text for the timezone.
    let text: String
    /// A list of UTC identifiers associated with the timezone.
    let utc: [String]
}
