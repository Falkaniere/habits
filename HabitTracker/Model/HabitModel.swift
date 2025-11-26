import Foundation

struct HabitModel {
    var title = ""
    var description = ""
    var notificationText = ""
    var notificationEnabled = false
    var notificationDate = Date()
    var frequency = HabitFrequency.daily
    var createdAt = Date()
    var isDone = false
    var notificationIDs = [""]
    var dailyFrequency = 0
    var completedDays = [Date()]
    var lastDayCompleted = Date()
}


