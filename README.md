# ClockZones

[![Swift Version](https://img.shields.io/badge/Swift-6.0-orange.svg)](https://swift.org) [![iOS Deployment Target](https://img.shields.io/badge/iOS-16-blue.svg)](https://developer.apple.com/documentation/ios) [![CoreData Enabled](https://img.shields.io/badge/CoreData-Enabled-green.svg)](https://developer.apple.com/documentation/coredata)

ClockZones is a SwiftUI application that demonstrates how to use Core Data for persistent storage of timezone data. The app allows users to import timezone data from a JSON file, display the timezones in a list with real-time updated current times (based on GMT), and view detailed analog clock displays for each timezone.

## Features

- **Import Timezones:** Load timezone data from a bundled JSON file.
- **Real-Time Updates:** Displays the current time (without seconds) that updates in real time based on GMT.
- **Detailed Clock View:** Tap on a timezone to see an analog clock with a toggle to switch between Arabic and Roman numerals.
- **Core Data Integration:** Uses Core Data to store, retrieve, and manage timezone data.
- **Unit Testing:** Includes unit tests for JSON decoding, time formatting, and Core Data model computations.

## Requirements

- **Swift:** 6.0+
- **iOS:** 16+
- **Xcode:** 14+

## Installation

Clone the repository:

```bash
git clone https://github.com/luishramorim/ClockZones.git
```

Open the ClockZones.xcodeproj file in Xcode and build the project.

## Usage

- **Main View:** Displays a list of timezones with their current times (adjusted based on GMT) and UTC offsets.
- **Detailed View:** Tap a timezone to navigate to a detailed view with an analog clock and digital time display.
- **Add Timezone:** Use the import or manual addition feature to add new timezones to the list.

## Running Tests

The project includes unit tests for key functionalities:
- **TimezoneEntry Decoding:** Verifies correct decoding of timezone data from JSON.
- **UTC Formatting:** Tests the formatted UTC string computation.
- **Real-Time Clock Formatting:** Ensures that the time display updates correctly based on GMT and offset.

Run the tests by selecting the `ClockZonesTests` scheme in Xcode.

## Screenshots

<table>
  <tr>
    <td align="center"><img src="https://github.com/user-attachments/assets/c184f89b-2090-433e-b8e5-7bc59ba2e954" alt="IMG_0980" width="150"></td>
    <td align="center"><img src="https://github.com/user-attachments/assets/0dac19bf-bb02-4fc9-a1b8-6eb9bd195b32" alt="IMG_0979" width="150"></td>
    <td align="center"><img src="https://github.com/user-attachments/assets/49a68174-5abf-4875-b41a-c26c31b36d76" alt="IMG_0978" width="150"></td>
  </tr>
  <tr>
    <td align="center"><img src="https://github.com/user-attachments/assets/939fe4df-b604-46b0-8e56-4d2586cbe9a2" alt="IMG_0977" width="150"></td>
    <td align="center"><img src="https://github.com/user-attachments/assets/d1f78a85-9101-4e8b-a03e-4fe874768303" alt="IMG_0976" width="150"></td>
    <td align="center"><img src="https://github.com/user-attachments/assets/917307a0-c515-47ee-8666-3a692b611f4f" alt="IMG_0981" width="150"></td>

  </tr>
</table>
## License

This project is licensed under the MIT License.
