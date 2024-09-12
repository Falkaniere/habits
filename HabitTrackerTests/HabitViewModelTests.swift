import XCTest
import CoreData
@testable import HabitTracker

class HabitViewModelTests: XCTestCase {
    
    var viewModel: HabitViewModel!
    var context: NSManagedObjectContext?

    override func setUpWithError() throws {
        let persistentContainer = NSPersistentContainer(name: "HabitModel")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        persistentContainer.persistentStoreDescriptions = [description]
        persistentContainer.loadPersistentStores(completionHandler: { _, error in
            XCTAssertNil(error)
        })
        context = persistentContainer.viewContext
        viewModel = HabitViewModel(context: context!)
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        context = nil
    }

    func testAddHabit() throws {
        // Given
        viewModel.title = "Test Habit"
        viewModel.notificationText = "Reminder to complete your habit"
        viewModel.notificationEnabled = true
        viewModel.notificationDate = Date().addingTimeInterval(3600) // 1 hour later
        viewModel.frequency = .daily

        // When
        viewModel.addHabit()
        
        // Then
        let fetchRequest: NSFetchRequest<Habit> = Habit.fetchRequest()
        let habits = try context?.fetch(fetchRequest)
        
        XCTAssertEqual(habits?.count, 1)
        XCTAssertEqual(habits?.first?.title, "Test Habit")
        XCTAssertEqual(habits?.first?.notificationText, "Reminder to complete your habit")
        XCTAssertTrue(habits?.first?.notificationEnabled ?? false)
        XCTAssertEqual(habits?.first?.frequency, HabitFrequency.daily.rawValue)
    }
    
    func testNotificationScheduling() throws {
        // Given
        viewModel.title = "Test Habit with Notification"
        viewModel.notificationText = "Reminder to complete your habit"
        viewModel.notificationEnabled = true
        viewModel.notificationDate = Date().addingTimeInterval(3600) // 1 hour later
        viewModel.frequency = .daily

        // When
        viewModel.addHabit()

        // Then
        let fetchRequest: NSFetchRequest<Habit> = Habit.fetchRequest()
        let habits = try context?.fetch(fetchRequest)
        
        let habit = habits?.first
        XCTAssertNotNil(habit?.notificationIDs)
        XCTAssertFalse(habit?.notificationIDs?.isEmpty ?? true)
    }

    func testAddHabitWithoutNotification() throws {
        // Given
        viewModel.title = "Test Habit without Notification"
        viewModel.notificationEnabled = false

        // When
        viewModel.addHabit()

        // Then
        let fetchRequest: NSFetchRequest<Habit> = Habit.fetchRequest()
        let habits = try context?.fetch(fetchRequest)
        
        XCTAssertEqual(habits?.count, 1)
        XCTAssertEqual(habits?.first?.title, "Test Habit without Notification")
        XCTAssertTrue(habits?.first?.notificationIDs?.isEmpty ?? false)
    }

    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

    class MockHabitViewModel: HabitViewModel {
        var didScheduleNotification = false
        
        override func scheduleNotification(for habit: Habit, at date: Date, frequency: String) -> String {
            didScheduleNotification = true
            return "mock-notification-id"
        }
    }

    func testNotificationMocking() throws {
        // Given
        let mockViewModel = MockHabitViewModel(context: context!)
        mockViewModel.title = "Test Habit"
        mockViewModel.notificationEnabled = true

        // When
        mockViewModel.addHabit()

        // Then
        XCTAssertTrue(mockViewModel.didScheduleNotification)
    }

}
