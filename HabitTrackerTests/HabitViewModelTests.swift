import XCTest
import CoreData
@testable import HabitTracker

// MARK: - MockNotificationManager
final class MockNotificationManager {
    var didScheduleNotification = false
    var didFailToSchedule = false
    var scheduledNotificationTitle: String?
    var scheduledNotificationBody: String?
    var shouldFail = false
    var onScheduleNotification: (() -> Void)?
    
    func scheduleNotification(title: String, body: String, triggerDate: Date, frequency: String) -> String {
        if shouldFail {
            didFailToSchedule = true
            return ""
        }
        didScheduleNotification = true
        scheduledNotificationTitle = title
        scheduledNotificationBody = body
        onScheduleNotification?()
        return "mock-notification-id"
    }
}

class HabitViewModelTests: XCTestCase {
    var viewModel: HabitViewModel!
    var context: NSManagedObjectContext!
    var mockNotificationManager: MockNotificationManager!

    override func setUp() {
        super.setUp()
        
        let persistentContainer = NSPersistentContainer(name: "HabitModel")
        
        context = persistentContainer.viewContext
        mockNotificationManager = MockNotificationManager()
        
        viewModel = HabitViewModel(
            habitService: HabitService(context: context),
            notificationManager: mockNotificationManager
        )
    }
    
    func testLoadHabits() {
        XCTFail()
    }
    
    func testDeletHabits() {
        XCTFail()
        
    }
    
    func testMarkAsDone() {
        XCTFail()
        
    }
    
    func testAddHabit() {
        XCTFail()
        
    }
    
    func testScheduleNotification() {
        XCTFail()
        
    }
}


