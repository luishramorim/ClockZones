//
//  AnalogClockView.swift
//  ClockZones
//
//  Created by Luis Amorim on 25/02/25.
//

import SwiftUI

/// A view that displays an analog clock adjusted for a specified time zone offset.
/// The clock’s base time is set to GMT. The clock face uses a solid background—white during day and black at night.
/// During the day, the hour and minute hands are always rendered in black, regardless of dark mode.
struct AnalogClockView: View {
    /// Determines whether the hour markers should be displayed as Roman numerals.
    var isRoman: Bool
    /// The time zone offset in hours (default is 0 for local time).
    var timezoneOffset: Double = 0

    var body: some View {
        // TimelineView provides a continuous stream of dates for smooth animation.
        TimelineView(.animation) { timeline in
            // Use timeline.date as the absolute (GMT) base time.
            let gmtDate = timeline.date
            // Apply the timezone offset (in seconds) to obtain the current time for the target timezone.
            let currentDate = gmtDate.addingTimeInterval(timezoneOffset * 3600)
            GeometryReader { geometry in
                let radius = min(geometry.size.width, geometry.size.height) / 2
                
                // Create a GMT-configured calendar for consistent time calculations.
                let calendar: Calendar = {
                    var cal = Calendar(identifier: .gregorian)
                    cal.timeZone = TimeZone(secondsFromGMT: 0)!
                    return cal
                }()
                
                // Determine if it's day or night based on the current GMT hour.
                let currentHour = calendar.component(.hour, from: currentDate)
                let isDay = (currentHour >= 8 && currentHour < 18)
                
                // Define the solid background color: white for day, black for night.
                let backgroundColor = isDay ? Color.white : Color.black
                // Define the stroke color: black for day, white for night.
                let strokeColor = isDay ? Color.black : Color.white
                
                ZStack {
                    // Clock face with a solid background and stroke.
                    Circle()
                        .fill(backgroundColor)
                        .overlay(
                            Circle().stroke(strokeColor, lineWidth: 1)
                        )
                        .shadow(color: strokeColor.opacity(0.3), radius: 4, x: 0, y: 2)
                        .frame(width: radius * 2, height: radius * 2)
                    
                    // Hour markers with larger, minimalist numerals.
                    // The numeral color is black if it's day, white if it's night.
                    ForEach(1...12, id: \.self) { i in
                        let label = isRoman ? romanNumeral(for: i) : String(i)
                        // Each marker is placed 30° apart, offset by -90° to start at the top.
                        let angle = Angle.degrees(Double(i) * 30 - 90)
                        let labelRadius = radius * 0.8
                        Text(label)
                            .font(.system(size: 28, weight: .medium, design: .rounded))
                            .foregroundColor(isDay ? .black : .white)
                            .position(
                                x: geometry.size.width / 2 + cos(angle.radians) * labelRadius,
                                y: geometry.size.height / 2 + sin(angle.radians) * labelRadius
                            )
                    }
                    
                    // Extract time components from currentDate using the GMT calendar.
                    let hour = calendar.component(.hour, from: currentDate) % 12
                    let minute = calendar.component(.minute, from: currentDate)
                    let second = calendar.component(.second, from: currentDate)
                    let nanosecond = calendar.component(.nanosecond, from: currentDate)
                    
                    // Calculate fractional seconds.
                    let fractionalSeconds = Double(second) + Double(nanosecond) / 1_000_000_000
                    // Calculate the angle for the hour hand.
                    let fractionalMinutes = Double(minute) + fractionalSeconds / 60
                    let hourAngle = (Double(hour) + fractionalMinutes / 60) * 30 // 360°/12
                    // Calculate the angle for the minute hand.
                    let minuteAngle = (Double(minute) + fractionalSeconds / 60) * 6 // 360°/60
                    // Calculate the angle for the second hand.
                    let secondAngle = fractionalSeconds * 6 // 360°/60
                    
                    // Set hand colors: during the day, use black; otherwise, use white.
                    let hourHandColor: Color = isDay ? .black : .white
                    let minuteHandColor: Color = isDay ? .black : Color.white.opacity(0.8)
                    
                    // Hour hand: a sleek Capsule shape.
                    Capsule()
                        .fill(hourHandColor)
                        .frame(width: 6, height: radius * 0.5)
                        .offset(y: -radius * 0.25)
                        .rotationEffect(Angle.degrees(hourAngle))
                    
                    // Minute hand: slender and extended.
                    Capsule()
                        .fill(minuteHandColor)
                        .frame(width: 4, height: radius * 0.7)
                        .offset(y: -radius * 0.35)
                        .rotationEffect(Angle.degrees(minuteAngle))
                    
                    // Second hand: very thin with a bright blue accent.
                    Capsule()
                        .fill(Color.blue)
                        .frame(width: 2, height: radius * 0.85)
                        .offset(y: -radius * 0.425)
                        .rotationEffect(Angle.degrees(secondAngle))
                    
                    // Center pivot: a small accented circle.
                    Circle()
                        .fill(Color.white)
                        .frame(width: 12, height: 12)
                        .overlay(
                            Circle().stroke(Color.blue.opacity(0.8), lineWidth: 2)
                        )
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
        }
    }
    
    /// Converts an integer number (1...12) to its corresponding Roman numeral.
    /// - Parameter number: The integer value between 1 and 12.
    /// - Returns: A string representing the Roman numeral.
    func romanNumeral(for number: Int) -> String {
        switch number {
        case 1: return "I"
        case 2: return "II"
        case 3: return "III"
        case 4: return "IV"
        case 5: return "V"
        case 6: return "VI"
        case 7: return "VII"
        case 8: return "VIII"
        case 9: return "IX"
        case 10: return "X"
        case 11: return "XI"
        case 12: return "XII"
        default: return ""
        }
    }
}

#Preview {
    AnalogClockView(isRoman: false, timezoneOffset: 1.5)
        .frame(width: 300, height: 300)
        .padding()
}
