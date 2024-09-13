import CoreData

class HabitService {
    var context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func fetchHabits() -> [Habit] {
        let request: NSFetchRequest<Habit> = Habit.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Habit.createdAt, ascending: false)]
        
        do {
            return try context.fetch(request)
        } catch {
            print("Failed to fetch habits: \(error)")
            return []
        }
    }

    func saveHabit(_ habit: Habit) {
        do {
            try context.save()
        } catch {
            print("Failed to save habit: \(error.localizedDescription)")
        }
    }

    func deleteHabit(_ habit: Habit) {
        context.delete(habit)
        saveContext()
    }
    
    func saveContext() {
        do {
            try context.save()
        } catch {
            print("Failed to save context: \(error.localizedDescription)")
        }
    }
}
