import Foundation
import Combine
import CoreData
import UserNotifications

class HabitViewModel: ObservableObject {
    private let habitService: HabitService
    private let notificationManager: NotificationManagerProtocol

    @Published var habits: [Habit] = []
    @Published var addNewHabit: Bool = false
    @Published var title: String = ""
    @Published var notificationText: String = ""
    @Published var notificationEnabled: Bool = false
    @Published var notificationDate: Date = Date()
    @Published var frequencyType: HabitFrequency = .daily
    @Published var createdAt: Date = Date()
    @Published var isDone: Bool = false
    @Published var notificationIDs: [String] = []
    @Published var totalFrequency: Int16 = 0
    @Published var currentDoneCount: Int16 = 0
    @Published var lastDayCompleted: Date = Date()
    @Published var progress: Int = 0
    @Published var id: UUID = UUID()

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
    
    func toFillInHabit(habitToFill: Habit) -> Habit {
        habitToFill.title = title
        habitToFill.notificationText = notificationText
        habitToFill.notificationDate = notificationDate
        habitToFill.frequencyType = frequencyType.rawValue
        habitToFill.createdAt = Date()
        habitToFill.isDone = isDone
        habitToFill.notificationEnabled = notificationEnabled
        habitToFill.notificationIDs = notificationIDs
        habitToFill.totalFrequency = totalFrequency
        habitToFill.currentDoneCount = currentDoneCount
        habitToFill.lastDayCompleted = lastDayCompleted
        habitToFill.progress = 0
        habitToFill.id = id
        
        return habitToFill
    }
    
    func scheduleNotification(for habit: Habit) -> String {
        let title = habit.title ?? "Habit Reminder"
        let body = habit.notificationText ?? "Don't forget to complete your habit!"
        
        return notificationManager.scheduleNotification(
            title: title,
            body: body,
            triggerDate: notificationDate,
            frequency: frequencyType.rawValue
        )
    }
}

