import SwiftUI

struct AddHabit: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var habitModel: HabitViewModel
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Habit Name")) {
                    TextField("Enter habit name", text: $habitModel.habit.title)
                }
                
                Section(header: Text("Description")) { 
                    TextField("Enter habit description", text: $habitModel.habit.habitDescription, axis: .vertical)
                }
                
                Section(header: Text("Frequency")) {
                    Picker("Frequency", selection: $habitModel.habit.frequency) {
                        ForEach(HabitFrequency.allCases, id: \.self) { frequency in
                            Text(frequency.rawValue).tag(frequency)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Daily frequency")) {
                    Stepper {
                        Text("Should be done \(habitModel.habit.dailyFrequency) times to be completed")
                    } onIncrement: {
                        habitModel.incrementDailyFrequency()
                    } onDecrement: {
                        habitModel.decrementDailyFrequency()
                    }
                }
                
                DatePicker("Remember me at:", selection: $habitModel.habit.notificationDate, displayedComponents: [.hourAndMinute])
            }
            .navigationBarTitle("Add New Habit", displayMode: .inline)
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }, trailing: Button("Save") {
                habitModel.addHabit()
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

#Preview {
    AddHabit()
}
