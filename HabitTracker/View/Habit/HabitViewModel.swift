import Foundation
import Combine
import CoreData
import UserNotifications

class HabitViewModel: ObservableObject {
    private let habitService: HabitService
    private let notificationManager: NotificationManagerProtocol
    private var habits: [Habit]
    
    @Published var habit = HabitModel()

    init(habitService: HabitService, notificationManager: NotificationManagerProtocol) {
        self.habitService = habitService
        self.notificationManager = notificationManager
    }
    
    func loadHabits() {
        habits = habitService.fetchHabits()
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
        habitService.saveHabit()
        loadHabits()
    }
    
    func addHabit() {
        if !(title.isEmpty || notificationText.isEmpty) {
            SnackbarManager.shared.showSnackbar(title: "Favor preencher titulo e notificação texto")
        }
        
        let newHabit = toFillInHabit(habitToFill: Habit(context: habitService.context))
        
        do {
            let notificationIdentifier = scheduleNotification(for: newHabit)
            newHabit.notificationIDs?.append(notificationIdentifier)
        }
    }
    
    private func incrementDailyFrequency() {
        $habit.dailyFrequency += 1
    }
    
    private func decrementDailyFrequency() {
        if $habit.dailyFrequency > 0 {
            $habit.dailyFrequency -= 1
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

