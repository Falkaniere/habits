import XCTest
import CoreData
@testable import HabitTracker

class HabitViewModelTests: XCTestCase {

    var viewModel: HabitViewModel!
    var context: NSManagedObjectContext!
    var mockNotificationManager: MockNotificationManager!

    override func setUpWithError() throws {
        // Set up the in-memory Core Data stack
        let persistentContainer = NSPersistentContainer(name: "HabitModel")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        persistentContainer.persistentStoreDescriptions = [description]
        persistentContainer.loadPersistentStores(completionHandler: { _, error in
            XCTAssertNil(error)
        })

        context = persistentContainer.viewContext
        mockNotificationManager = MockNotificationManager()

        viewModel = HabitViewModel(
            habitService: HabitService(context: context), notificationManager: NotificationManagerProtocol as! NotificationManagerProtocol)
    }

    override func tearDownWithError() throws {
        viewModel = nil
        context = nil
        mockNotificationManager = nil
    }

    // MARK: - Test Cases

    func testAddHabit() throws {
        // Given: Set up the ViewModel's state for adding a habit
        viewModel.title = "Test Habit"
        viewModel.notificationText = "Reminder to complete your habit"
        viewModel.notificationEnabled = true
        viewModel.notificationDate = Date().addingTimeInterval(3600) // 1 hour later
        viewModel.frequency = .daily

        // When: The addHabit function is called
        viewModel.addHabit()

        // Then: Verify the habit was added to Core Data
        let fetchRequest: NSFetchRequest<Habit> = Habit.fetchRequest()
        let habits = try context.fetch(fetchRequest)

        XCTAssertEqual(habits.count, 1)
        XCTAssertEqual(habits.first?.title, "Test Habit")
        XCTAssertEqual(habits.first?.notificationText, "Reminder to complete your habit")
        XCTAssertTrue(habits.first?.notificationEnabled ?? false)
        XCTAssertEqual(habits.first?.frequency, HabitFrequency.daily.rawValue)

        // Verify the notification was scheduled
        XCTAssertTrue(mockNotificationManager.didScheduleNotification)
        XCTAssertEqual(mockNotificationManager.scheduledNotificationTitle, "Test Habit")
        XCTAssertEqual(mockNotificationManager.scheduledNotificationBody, "Reminder to complete your habit")
    }

    func testAddHabitWithoutNotification() throws {
        // Given: Set up ViewModel's state for a habit without notifications
        viewModel.title = "Test Habit without Notification"
        viewModel.notificationEnabled = false

        // When: The addHabit function is called
        viewModel.addHabit()

        // Then: Verify the habit was added to Core Data without notifications
        let fetchRequest: NSFetchRequest<Habit> = Habit.fetchRequest()
        let habits = try context.fetch(fetchRequest)

        XCTAssertEqual(habits.count, 1)
        XCTAssertEqual(habits.first?.title, "Test Habit without Notification")
        XCTAssertFalse(((habits.first?.notificationEnabled) != nil))
        XCTAssertTrue(habits.first?.notificationIDs?.isEmpty ?? true)

        // Verify no notification was scheduled
        XCTAssertFalse(mockNotificationManager.didScheduleNotification)
    }

    func testMarkAsDone() throws {
        // Given: Add a habit and ensure it's marked as not done
        viewModel.title = "Test Habit"
        viewModel.addHabit()

        let fetchRequest: NSFetchRequest<Habit> = Habit.fetchRequest()
        var habits = try context.fetch(fetchRequest)
        let habit = habits.first
        XCTAssertFalse(habit?.isDone ?? true)

        // When: Mark the habit as done
        viewModel.markAsDoneFunc(habit: habit!)

        // Then: Verify the habit is marked as done
        habits = try context.fetch(fetchRequest)
        XCTAssertTrue(habits.first?.isDone ?? false)
    }

    func testDeleteHabit() throws {
        // Given: Add a habit and check its presence
        viewModel.title = "Habit to Delete"
        viewModel.addHabit()

        let fetchRequest: NSFetchRequest<Habit> = Habit.fetchRequest()
        var habits = try context.fetch(fetchRequest)
        XCTAssertEqual(habits.count, 1)

        // When: Delete the habit
        viewModel.deleteHabits(at: IndexSet(integer: 0))

        // Then: Verify the habit is deleted
        habits = try context.fetch(fetchRequest)
        XCTAssertEqual(habits.count, 0)
    }

    class MockNotificationManager: NotificationManager {
        var didScheduleNotification = false
        var scheduledNotificationTitle: String?
        var scheduledNotificationBody: String?

        override func scheduleNotification(title: String, body: String, triggerDate: Date, frequency: String) -> String {
            didScheduleNotification = true
            scheduledNotificationTitle = title
            scheduledNotificationBody = body
            return "mock-notification-id"
        }
    }
}


