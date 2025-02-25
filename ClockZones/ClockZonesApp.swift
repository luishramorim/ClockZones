//
//  ClockZonesApp.swift
//  ClockZones
//
//  Created by Luis Amorim on 25/02/25.
//

import SwiftUI

@main
struct ClockZonesApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
