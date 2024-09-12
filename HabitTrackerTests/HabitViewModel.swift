import XCTest
import CoreData
@testable import HabitTracker

final class HabitViewModelTests: XCTestCase {
    
    var viewModel: HabitViewModel!
    var context: NSManagedObjectContext!

    override func setUpWithError() throws {
        let persistentContainer = NSPersistentContainer(name: "HabitModel")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        persistentContainer.persistentStoreDescriptions = [description]
        try persistentContainer.loadPersistentStores(completionHandler: { _, error in
            XCTAssertNil(error)
        })
        context = persistentContainer.viewContext
        viewModel = HabitViewModel(context: context)
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        context = nil
    }
}
