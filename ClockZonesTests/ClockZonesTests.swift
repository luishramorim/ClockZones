//
//  ClockZonesTests.swift
//  ClockZonesTests
//
//  Created by Luis Amorim on 25/02/25.
//

import XCTest
import CoreData
@testable import ClockZones

/// A set of unit tests for the ClockZones project.
final class ClockZonesTests: XCTestCase {

    /// The in-memory persistence controller used for testing.
    var persistenceController: PersistenceController!
    /// The managed object context from the in-memory persistent container.
    var context: NSManagedObjectContext!

    /// Sets up the in-memory Core Data stack before each test.
    override func setUpWithError() throws {
        persistenceController = PersistenceController(inMemory: true)
        context = persistenceController.container.viewContext
    }

    /// Tears down the Core Data stack after each test.
    override func tearDownWithError() throws {
        context = nil
        persistenceController = nil
    }

    /// Tests the formattedUTC computed property of the Timezone Core Data model.
    ///
    /// Creates a dummy Timezone object with an offset of 1.5 hours and verifies that the formattedUTC property returns "+1:30".
    func testFormattedUTC() throws {
        let tz = Timezone(context: context)
        tz.offset = 1.5
        XCTAssertEqual(tz.formattedUTC, "+1:30", "Formatted UTC string does not match the expected value '+1:30'")
    }

    /// Tests decoding of a TimezoneEntry from JSON.
    ///
    /// This verifies that the TimezoneEntry model correctly decodes a sample JSON object.
    func testTimezoneEntryDecoding() throws {
        let jsonString = """
        {
          "value": "Pacific Standard Time",
          "abbr": "PST",
          "offset": -8,
          "isdst": false,
          "text": "(UTC-08:00) Pacific Standard Time (US & Canada)",
          "utc": ["America/Los_Angeles", "America/Tijuana"]
        }
        """
        let data = Data(jsonString.utf8)
        let decoder = JSONDecoder()
        let entry = try decoder.decode(TimezoneEntry.self, from: data)
        XCTAssertEqual(entry.value, "Pacific Standard Time")
        XCTAssertEqual(entry.abbr, "PST")
        XCTAssertEqual(entry.offset, -8)
        XCTAssertEqual(entry.isdst, false)
        XCTAssertEqual(entry.text, "(UTC-08:00) Pacific Standard Time (US & Canada)")
        XCTAssertEqual(entry.utc, ["America/Los_Angeles", "America/Tijuana"])
    }

    /// Tests the time formatting logic used in RealTimeClockText.
    ///
    /// This test manually simulates a GMT date and applies a timezone offset,
    /// then verifies that the formatted time string is as expected.
    func testRealTimeClockTextFormatting() throws {
        let timezoneOffset: Double = 2.0 // 2 hours offset
        // Create a date in GMT: for example, January 1, 2022, at 12:00:00 GMT.
        let dateComponents = DateComponents(timeZone: TimeZone(secondsFromGMT: 0), year: 2022, month: 1, day: 1, hour: 12, minute: 0, second: 0)
        let calendar = Calendar(identifier: .gregorian)
        guard let gmtDate = calendar.date(from: dateComponents) else {
            XCTFail("Failed to create test date")
            return
        }
        // Apply the timezone offset (2 hours).
        let adjustedDate = gmtDate.addingTimeInterval(timezoneOffset * 3600)
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "HH:mm"
        let formatted = formatter.string(from: adjustedDate)
        // Expected time: 12:00 GMT + 2 hours = 14:00
        XCTAssertEqual(formatted, "14:00", "RealTimeClockText formatter did not produce the expected time '14:00'")
    }
}
