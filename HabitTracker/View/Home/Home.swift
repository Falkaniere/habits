import SwiftUI

struct Home: View {
    @Environment(\.managedObjectContext) var context

    @FetchRequest(
        entity: Habit.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Habit.createdAt, ascending: false)],
        animation: .default
    )
    var fetchedHabits: FetchedResults<Habit>
    
    @State var habits: [Habit] = []
    @State var isAddingNewHabit: Bool = false
    @EnvironmentObject var habitModel: HabitViewModel
    
    var body: some View {
        NavigationView {
            List {
                ForEach(habits, id: \.self) { habit in
                    HStack {
                        Button(action: {
                            markAsDoneFunc(habit: habit)
                        }) {
                            Image(systemName: habit.isDone ? "checkmark.square.fill" : "square")
                                .font(.system(size: 24))
                        }

                        NavigationLink(destination: HabitDetail(habit: habit)) {
                            HabitCard(
                                toggleOn: Binding(
                                    get: { habit.isDone },
                                    set: { habit.isDone = $0 }
                                ),                                title: habit.title ?? "",
                                description: habit.notificationText ?? "",
                                markAsDone: {}
                            )
                        }
                    }
                }
                .onDelete(perform: deleteHabits)
            }
            .listStyle(.grouped)
            .navigationTitle("My habits")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        isAddingNewHabit = true
                    } label: {
                        Image(systemName: "square.and.pencil")
                            .font(.title2)
                    }
                }
            }
            
        }
        .sheet(isPresented: $isAddingNewHabit, onDismiss: loadHabits) {
            AddHabit()
                .environmentObject(habitModel)
        }
        .onAppear(perform: loadHabits)
    }
    
    private func loadHabits() {
        habits = fetchedHabits.sorted { !$0.isDone && $1.isDone }
    }
    
    private func deleteHabits(offsets: IndexSet) {
        offsets.forEach { index in
            let habit = habits[index]
            context.delete(habit)
        }
        
        do {
            try context.save()
            loadHabits()
        } catch {
            print("Failed to delete habit: \(error.localizedDescription)")
        }
    }
    
    private func markAsDoneFunc(habit: Habit) {
        habit.isDone.toggle()
        
        do {
            try context.save()
            loadHabits()
        } catch {
            print("Failed to save habit: \(error.localizedDescription)")
        }
    }
}
