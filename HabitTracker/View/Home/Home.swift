import SwiftUI

struct Home: View {
    @State var isAddingNewHabit: Bool = false
    @StateObject var habitModel = HabitViewModel(
        habitService: HabitService(context: PersistenceController.shared.container.viewContext),
        notificationManager: NotificationManager()
    )
    
    var body: some View {
        NavigationView {
            List {
                ForEach(habitModel.habits, id: \.self) { habit in
                    HStack {
                        Button(action: {
                            habitModel.markAsDoneFunc(habit: habit)
                        }) {
                            Image(systemName: habit.isDone ? "checkmark.square.fill" : "square")
                                .font(.system(size: 24))
                        }
                        .buttonStyle(PlainButtonStyle())
                        .padding(.trailing)
                        
                        ZStack {
                            HabitCard(
                                title: habit.title ?? "",
                                description: habit.notificationText ?? ""
                            )
                            
                            NavigationLink(destination: HabitDetail(habit: habit)) {
                                EmptyView()
                            }
                            .opacity(0)
                        }
                    }
                }
                .onDelete(perform: habitModel.deleteHabits)
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
        .sheet(isPresented: $isAddingNewHabit, onDismiss: habitModel.loadHabits) {
            AddHabit()
                .environmentObject(habitModel)
        }
        .onAppear(perform: habitModel.loadHabits)
    }

}
