import UserNotifications

func scheduleNotification(title: String, body: String, triggerDate: Date) -> String {
    let content = UNMutableNotificationContent()
    
    content.title = title
    content.body = body
    content.sound = UNNotificationSound.default

    let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.hour, .minute], from: triggerDate), repeats: true)

    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

    UNUserNotificationCenter.current().add(request) { error in
        if let error = error {
            print("Failed to add notification: \(error.localizedDescription)")
        }
    }
    
    return request.identifier
}
