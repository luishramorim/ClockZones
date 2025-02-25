//
//  ClockZonesApp.swift
//  ClockZones
//
//  Created by Luis Amorim on 25/02/25.
//

import SwiftUI

/// The main entry point for the ClockZones application.
///
/// This struct initializes the Core Data persistence controller and injects the managed object context into the environment,
/// then sets the root view of the app to `ContentView()`.
@main
struct ClockZonesApp: App {
    /// The shared persistence controller for managing Core Data.
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            /// The root view of the application.
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
