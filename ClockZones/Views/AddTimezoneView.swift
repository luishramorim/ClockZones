//
//  AddTimezoneView.swift
//  ClockZones
//
//  Created by Luis Amorim on 25/02/25.
//

import SwiftUI
import CoreData

/// A view that allows the user to manually add a new timezone entry.
///
/// This view provides a form with fields for entering the details of a timezone.
/// On saving, the new timezone is persisted using Core Data and the view dismisses itself.
struct AddTimezoneView: View {
    /// Dismisses the current view.
    @Environment(\.dismiss) private var dismiss
    /// The managed object context used for Core Data operations.
    @Environment(\.managedObjectContext) private var viewContext
    
    // MARK: - State Properties
    /// The value identifier for the timezone.
    @State private var value: String = ""
    /// The abbreviation of the timezone.
    @State private var abbr: String = ""
    /// The offset from GMT in hours.
    @State private var offset: Double = 0.0
    /// A Boolean indicating whether daylight saving time is observed.
    @State private var isdst: Bool = false
    /// A descriptive text for the timezone.
    @State private var text: String = ""
    /// A string containing a list of UTC identifiers, separated by commas.
    @State private var utc: String = "" // Example: "America/Sao_Paulo, America/Rio_Branco"
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            Form {
                // MARK: Basic Information Section
                Section(header: Text("Basic Information")) {
                    TextField("Value", text: $value)
                    TextField("Abbr", text: $abbr)
                    
                    TextField("Offset", value: $offset, format: .number)
                        .keyboardType(.decimalPad)
                    
                    Toggle("Observes Daylight Saving Time (DST)?", isOn: $isdst)
                }
                
                // MARK: Description Section
                Section(header: Text("Description")) {
                    TextField("Text (description)", text: $text)
                }
                
                // MARK: UTC List Section
                Section(header: Text("UTC List (separate with commas)")) {
                    TextField("UTC Strings", text: $utc)
                        .textInputAutocapitalization(.never)
                }
            }
            .navigationTitle("New Timezone")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        addTimezone()
                    }
                }
            }
        }
    }
    
    // MARK: - Methods
    /// Creates and saves a new timezone entry in Core Data.
    ///
    /// This method initializes a new `Timezone` object using the values from the form,
    /// attempts to save the context, and dismisses the view upon success.
    private func addTimezone() {
        let newTz = Timezone(context: viewContext)
        newTz.id = UUID()
        newTz.value = value
        newTz.abbr = abbr
        newTz.offset = offset
        newTz.isdst = isdst
        newTz.text = text
        newTz.utc = utc  // Stored as a single string
        
        do {
            try viewContext.save()
            dismiss()
        } catch {
            print("Failed to save new timezone: \(error.localizedDescription)")
        }
    }
}
