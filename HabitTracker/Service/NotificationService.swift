import Foundation
import SwiftUI

class NotificationService {
    static func requestNotificationPermission() async {
        let center = UNUserNotificationCenter.current()

        do {
            try await center.requestAuthorization(options: [.alert, .sound, .badge])
        } catch {
            print("error whule try to get location")
        }
    }
    
    static func checkNotificationPermission() async -> Bool {
        let center = UNUserNotificationCenter.current()
        
        let settings = await center.notificationSettings()

        switch settings.authorizationStatus {
        case .authorized:
            return true
        case .denied, .notDetermined, .provisional, .ephemeral:
            return false
        @unknown default:
            return false
        }
    }
}
