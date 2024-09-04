//
//  Habit.swift
//  HabitTracker
//
//  Created by Jonatas Falkaniere on 01/09/24.
//

import Foundation

//struct Habit: Identifiable, Codable {
//    var id: UUID
//    
//}

enum HabitFrequency: String, Codable, CaseIterable {
    case daily = "Daily"
    case weekly = "Weekly"
    case monthly = "Monthly"
}
