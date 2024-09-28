import SwiftUI
import UserNotifications

@main
struct HabitTrackerApp: App {
    let persistenceController = PersistenceController.shared
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .onAppear {
                    Task {
                        let isGranted = await NotificationService.checkNotificationPermission()
                        if !isGranted {
                            _ = await NotificationService.requestNotificationPermission()
                        }
                    }
                }
        }
    }
}
