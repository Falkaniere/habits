import Foundation
import Combine
import CoreData
import UserNotifications

class HabitViewModel: ObservableObject {
    
    @Published var addNewHabit: Bool = false
    
    @Published var title: String = ""
    @Published var notificationText: String = ""
    @Published var notificationEnabled: Bool = false
    @Published var notificationDate: Date = Date()
    @Published var frequency: HabitFrequency = .daily
    @Published var createdAt: Date = Date()
    @Published var isDone: Bool = false
    @Published var notificationIDs: [String] = []
    
    private var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func addHabit() {
        let newHabit = Habit(context: context)
        newHabit.title = title
        newHabit.notificationText = notificationText
        newHabit.notificationDate = notificationDate
        newHabit.frequency = frequency.rawValue
        newHabit.createdAt = Date()
        newHabit.isDone = isDone
        newHabit.notificationEnabled = notificationEnabled
        newHabit.notificationIDs = notificationIDs
        
        do {
            let notificationIdentifier = scheduleNotification(for: newHabit, at: notificationDate)
            newHabit.notificationIDs?.append(notificationIdentifier)
            try context.save()
        } catch {
            print("Error saving new habit: \(error.localizedDescription)")
        }
    }
    
    func scheduleNotification(for habit: Habit, at date: Date) -> String {
        let title = habit.title ?? "Habit Reminder"
        let body = habit.notificationText ?? "Don't forget to complete your habit!"
        
        return HabitTracker.scheduleNotification(title: title, body: body, triggerDate: date)
    }
}

