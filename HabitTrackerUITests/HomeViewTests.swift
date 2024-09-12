import XCTest
import SwiftUI
import CoreData
@testable import HabitTracker

class HomeViewTests: XCTestCase {
    var viewModel: HabitViewModel!
    var context: NSManagedObjectContext!

    override func setUpWithError() throws {
        // Create in-memory Core Data stack
        let persistentContainer = NSPersistentContainer(name: "HabitModel")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        persistentContainer.persistentStoreDescriptions = [description]
        try persistentContainer.loadPersistentStores(completionHandler: { _, error in
            XCTAssertNil(error)
        })
        context = persistentContainer.viewContext

        // Initialize ViewModel
        viewModel = HabitViewModel(context: context)
    }

    func testLoadHabitsOnAppear() {
        let homeView = Home()
        let exp = homeView.onAppear {
            XCTAssertFalse(homeView.habits.isEmpty)
        }
    }
}
