import UserNotifications

class NotificationManager {
    
    func scheduleNotification(title: String, body: String, triggerDate: Date, frequency: String) -> String {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default
        
        var trigger: UNNotificationTrigger?
        
        switch frequency {
        case "Daily":
            let dailyTriggerDate = Calendar.current.dateComponents([.hour, .minute], from: triggerDate)
            trigger = UNCalendarNotificationTrigger(dateMatching: dailyTriggerDate, repeats: true)
        
        case "Weekly":
            let weeklyTriggerDate = Calendar.current.dateComponents([.weekday, .hour, .minute], from: triggerDate)
            trigger = UNCalendarNotificationTrigger(dateMatching: weeklyTriggerDate, repeats: true)
        
        case "Monthly":
            let monthlyTriggerDate = Calendar.current.dateComponents([.day, .hour, .minute], from: triggerDate)
            trigger = UNCalendarNotificationTrigger(dateMatching: monthlyTriggerDate, repeats: true)
        
        default:
            print("Unknown frequency. Defaulting to Daily.")
            let defaultTriggerDate = Calendar.current.dateComponents([.hour, .minute], from: triggerDate)
            trigger = UNCalendarNotificationTrigger(dateMatching: defaultTriggerDate, repeats: true)
        }
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to add notification: \(error.localizedDescription)")
            }
        }
        
        return request.identifier
    }

}
