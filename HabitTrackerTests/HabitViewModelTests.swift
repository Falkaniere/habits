import XCTest
import CoreData
@testable import HabitTracker

class HabitViewModelTests: XCTestCase {

    var viewModel: HabitViewModel!
    var context: NSManagedObjectContext!
    var mockNotificationManager: MockNotificationManager!

    override func setUpWithError() throws {
        // Configurando Core Data in-memory
        let persistentContainer = NSPersistentContainer(name: "HabitModel")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        persistentContainer.persistentStoreDescriptions = [description]
        persistentContainer.loadPersistentStores(completionHandler: { _, error in
            XCTAssertNil(error)
        })

        context = persistentContainer.viewContext
        mockNotificationManager = MockNotificationManager()

        // Inicializando o ViewModel com o serviço de hábitos e o gerenciador de notificações mockado
        viewModel = HabitViewModel(
            habitService: HabitService(context: context), notificationManager: mockNotificationManager as NotificationManagerProtocol)
    }

    override func tearDownWithError() throws {
        viewModel = nil
        context = nil
        mockNotificationManager = nil
    }

    // MARK: - Testes

    func testAddHabit() throws {
        // Configurando o estado do ViewModel para adicionar um hábito
        viewModel.title = "Test Habit"
        viewModel.notificationText = "Reminder to complete your habit"
        viewModel.notificationEnabled = true
        viewModel.notificationDate = Date().addingTimeInterval(3600) // 1 hora depois
        viewModel.frequency = .daily

        // Expectativa para o agendamento da notificação
        let notificationExpectation = expectation(description: "Notificação agendada")

        mockNotificationManager.onScheduleNotification = {
            notificationExpectation.fulfill() // Confirma que a notificação foi agendada
        }

        // Adicionando o hábito
        viewModel.addHabit()

        // Verificando se o hábito foi adicionado ao Core Data
        let fetchRequest: NSFetchRequest<Habit> = Habit.fetchRequest()
        let habits = try context.fetch(fetchRequest)

        XCTAssertEqual(habits.count, 1)
        XCTAssertEqual(habits.first?.title, "Test Habit")
        XCTAssertEqual(habits.first?.notificationText, "Reminder to complete your habit")
        XCTAssertTrue(habits.first?.notificationEnabled ?? false)
        XCTAssertEqual(habits.first?.frequency, HabitFrequency.daily.rawValue)

        // Aguardar o agendamento da notificação
        wait(for: [notificationExpectation], timeout: 1.0)

        // Verificando que a notificação foi realmente agendada
        XCTAssertTrue(mockNotificationManager.didScheduleNotification)
        XCTAssertEqual(mockNotificationManager.scheduledNotificationTitle, "Test Habit")
        XCTAssertEqual(mockNotificationManager.scheduledNotificationBody, "Reminder to complete your habit")
    }

    func testAddHabitWithoutNotification() throws {
        // Configurando o ViewModel para um hábito sem notificações
        viewModel.title = "Test Habit without Notification"
        viewModel.notificationEnabled = false

        // Adicionando o hábito
        viewModel.addHabit()

        // Verificando se o hábito foi adicionado ao Core Data sem notificações
        let fetchRequest: NSFetchRequest<Habit> = Habit.fetchRequest()
        let habits = try context.fetch(fetchRequest)

        XCTAssertEqual(habits.count, 1)
        XCTAssertEqual(habits.first?.title, "Test Habit without Notification")
        XCTAssertFalse(habits.first?.notificationEnabled ?? true)
        XCTAssertTrue(habits.first?.notificationIDs?.isEmpty ?? true)

        // Verificando que nenhuma notificação foi agendada
        XCTAssertFalse(mockNotificationManager.didScheduleNotification)
    }

    func testMarkAsDone() throws {
        // Adicionando um hábito e verificando se está como não concluído
        viewModel.title = "Test Habit"
        viewModel.addHabit()

        let fetchRequest: NSFetchRequest<Habit> = Habit.fetchRequest()
        var habits = try context.fetch(fetchRequest)
        let habit = habits.first
        XCTAssertFalse(habit?.isDone ?? true)

        // Marcando o hábito como concluído
        viewModel.markAsDoneFunc(habit: habit!)

        // Verificando se o hábito foi marcado como concluído
        habits = try context.fetch(fetchRequest)
        XCTAssertTrue(habits.first?.isDone ?? false)
    }

    func testDeleteHabit() throws {
        // Adicionando um hábito e verificando se ele foi salvo
        viewModel.title = "Habit to Delete"
        viewModel.addHabit()

        let fetchRequest: NSFetchRequest<Habit> = Habit.fetchRequest()
        var habits = try context.fetch(fetchRequest)
        XCTAssertEqual(habits.count, 1)

        // Deletando o hábito
        viewModel.deleteHabits(at: IndexSet(integer: 0))

        // Verificando se o hábito foi deletado
        habits = try context.fetch(fetchRequest)
        XCTAssertEqual(habits.count, 0)
    }

    // Teste de erro para verificar falhas no agendamento de notificações
    func testNotificationSchedulingFailure() throws {
        // Configurando o mock para simular uma falha no agendamento de notificação
        mockNotificationManager.shouldFail = true

        viewModel.title = "Test Habit"
        viewModel.notificationEnabled = true
        viewModel.addHabit()

        // Verificando se o agendamento falhou
        XCTAssertTrue(mockNotificationManager.didFailToSchedule)
    }

    // MARK: - MockNotificationManager

    class MockNotificationManager: NotificationManagerProtocol {
        var didScheduleNotification = false
        var didFailToSchedule = false
        var scheduledNotificationTitle: String?
        var scheduledNotificationBody: String?
        var shouldFail = false
        var onScheduleNotification: (() -> Void)?

        override func scheduleNotification(title: String, body: String, triggerDate: Date, frequency: String) -> String {
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
}
