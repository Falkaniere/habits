import SwiftUI

struct AddHabit: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var habitModel: HabitViewModel
    
    @State private var habitName: String = ""
    @State private var habitDescription: String = ""
    @State private var frequency: HabitFrequency = .daily
    @State private var date = Date()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Habit Name")) {
                    TextField("Enter habit name", text: $habitName)
                }
                
                Section(header: Text("Description")) {
                    TextField("Enter habit description", text: $habitDescription)
                }
                
                Section(header: Text("Frequency")) {
                    Picker("Frequency", selection: $frequency) {
                        ForEach(HabitFrequency.allCases, id: \.self) { frequency in
                            Text(frequency.rawValue).tag(frequency)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                DatePicker("Remember me at:", selection: $date, displayedComponents: [.hourAndMinute])
            }
            .navigationBarTitle("Add New Habit", displayMode: .inline)
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }, trailing: Button("Save") {
                saveHabit()
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
    
    private func saveHabit() {
        habitModel.title = habitName
        habitModel.notificationText = habitDescription
        habitModel.notificationDate = date
        habitModel.frequency = frequency
        habitModel.notificationEnabled = true
        habitModel.isDone = false
        habitModel.addHabit()
    }
}


enum HabitFrequency: String, Codable, CaseIterable {
    case daily = "Daily"
    case weekly = "Weekly"
    case monthly = "Monthly"
}


#Preview {
    AddHabit()
}
