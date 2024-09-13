import SwiftUI 
import UserNotifications

struct ContentView: View {
    var body: some View {
        Home()
//            .preferredColorScheme(.dark )
    }
    
    func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Permission granted")
            } else {
                print("Permission denied")
            }
        }
    }
}

#Preview {
    ContentView()
}
