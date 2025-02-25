//
//  Persistence.swift
//  ClockZones
//
//  Created by Luis Amorim on 25/02/25.
//

import CoreData

/// A controller that manages the Core Data stack for the ClockZones application.
///
/// This controller initializes the persistent container with the given model name and provides
/// a shared instance for use throughout the application. It also supports an in‑memory store for testing purposes.
struct PersistenceController {
    /// The shared instance of the persistence controller.
    static let shared = PersistenceController()

    /// The persistent container that encapsulates the Core Data stack.
    let container: NSPersistentContainer

    /// Initializes the persistence controller.
    ///
    /// - Parameter inMemory: If true, the persistent store is configured to reside in memory only.
    ///   This is useful for testing purposes. The default value is false.
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "ClockZones")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Failed to load persistent store: \(error), \(error.userInfo)")
            }
        }
    }
}
