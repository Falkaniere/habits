import SwiftUI

struct HabitDetail: View {
    @Environment(\.managedObjectContext) var context
    @ObservedObject var habit: Habit
    
    @State private var editDisabled: Bool = true
    @State private var confirmSave: Bool = false
    
    var body: some View {
        NavigationView{
            Form {
                Section(header: Text("Title")) {
                    TextField("Habit", text: Binding(
                        get: { habit.title ?? "" },
                        set: { habit.title = $0 }
                    ))
                    .disabled(editDisabled)
                    .bold()
                }
                
                Section(header: Text("Description")) {
                    TextField("Description", text: Binding(
                        get: { habit.notificationText ?? "" },
                        set: { habit.notificationText = $0 }
                    ))
                    .disabled(editDisabled)
                    .bold()
                }
                
                Section(header: Text("Frequency")) {
                    Picker("Frequency", selection: Binding<HabitFrequency>(
                        get: {
                            HabitFrequency(rawValue: habit.frequency ?? HabitFrequency.daily.rawValue) ?? .daily
                        },
                        set: { newValue in
                            habit.frequency = newValue.rawValue
                        }
                    )) {
                        ForEach(HabitFrequency.allCases, id: \.self) { frequency in
                            Text(frequency.rawValue).tag(frequency)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .disabled(editDisabled)
                }
                
                Section(header: Text("Reminder")) {
                    Toggle(isOn: Binding<Bool>(
                        get: {
                            !habit.isDone
                        },
                        set: { newValue in
                            habit.isDone = !newValue
                        }
                    )) {
                        Text("Keep reminder")
                    }
                    .disabled(editDisabled)
                }
            }
        }
        .navigationBarTitle("Detail", displayMode: .inline)
        .navigationBarItems(trailing: Button(editDisabled ? "Edit" : "Save") {
            if editDisabled {
                editDisabled.toggle()
            } else {
                confirmSave = true
                editDisabled.toggle()
            }
        })
        .alert("Save changes?", isPresented: $confirmSave) {
            Button("Cancel") {
                confirmSave = false
            }
            Button("Save") {
                do {
                    try context.save()
                } catch {
                    // Handle save error
                }
                confirmSave = false
            }
        }
    }
}

struct HabitDetailed {
    var name: String
    var description: String
    var frequency: HabitFrequency
    var reminderMe: Bool
}

//#Preview {
//    HabitDetail(habit: Habit(entity: <#T##NSEntityDescription#>, insertInto: <#T##NSManagedObjectContext?#>))
//}
