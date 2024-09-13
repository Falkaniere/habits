import Foundation
import Combine
import CoreData
import UserNotifications

class HabitViewModel: ObservableObject {
    private var habitService: HabitService
    private var notificationManager: NotificationManager

    @Published var habits: [Habit] = []
    @Published var addNewHabit: Bool = false
    @Published var title: String = ""
    @Published var notificationText: String = ""
    @Published var notificationEnabled: Bool = false
    @Published var notificationDate: Date = Date()
    @Published var frequency: HabitFrequency = .daily
    @Published var createdAt: Date = Date()
    @Published var isDone: Bool = false
    @Published var notificationIDs: [String] = []
    
    init(habitService: HabitService, notificationManager: NotificationManager) {
        self.habitService = habitService
        self.notificationManager = notificationManager
    }
    
    func loadHabits() {
        habits = habitService.fetchHabits().sorted { !$0.isDone && $1.isDone }
    }

    func deleteHabits(at offsets: IndexSet) {
        offsets.forEach { index in
            let habit = habits[index]
            habitService.deleteHabit(habit)
        }
        loadHabits()
    }

    func markAsDoneFunc(habit: Habit) {
        habit.isDone.toggle()
        habitService.saveHabit(habit)
        loadHabits()
    }
    
    func addHabit() {
        let newHabit = Habit(context: habitService.context)
        newHabit.title = title
        newHabit.notificationText = notificationText
        newHabit.notificationDate = notificationDate
        newHabit.frequency = frequency.rawValue
        newHabit.createdAt = Date()
        newHabit.isDone = isDone
        newHabit.notificationEnabled = notificationEnabled
        newHabit.notificationIDs = notificationIDs
        
        do {
            let notificationIdentifier = scheduleNotification(for: newHabit)
            newHabit.notificationIDs?.append(notificationIdentifier)
        }
    }
    
    func scheduleNotification(for habit: Habit) -> String {
        let title = habit.title ?? "Habit Reminder"
        let body = habit.notificationText ?? "Don't forget to complete your habit!"
        
        return notificationManager.scheduleNotification(
            title: title,
            body: body,
            triggerDate: notificationDate,
            frequency: frequency.rawValue
        )
    }
}

