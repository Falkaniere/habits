//
//  Habit+CoreDataProperties.swift
//  HabitTracker
//
//  Created by Jonatas Falkaniere on 30/05/25.
//
//

import Foundation
import CoreData


extension Habit {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Habit> {
        return NSFetchRequest<Habit>(entityName: "Habit")
    }

    @NSManaged public var completedDays: [Date]?
    @NSManaged public var createdAt: Date?
    @NSManaged public var dailyFrequency: Int16
    @NSManaged public var frequency: String?
    @NSManaged public var isDone: Bool
    @NSManaged public var lastDayCompleted: Date?
    @NSManaged public var notificationDate: Date?
    @NSManaged public var notificationEnabled: Bool
    @NSManaged public var notificationIDs: [String]?
    @NSManaged public var notificationText: String?
    @NSManaged public var progress: Int16
    @NSManaged public var title: String?
    @NSManaged public var id: UUID?

}

extension Habit : Identifiable {

}
