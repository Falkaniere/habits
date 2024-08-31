//
//  HabitTrackerApp.swift
//  HabitTracker
//
//  Created by Jonatas Falkaniere on 31/08/24.
//

import SwiftUI

@main
struct HabitTrackerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
