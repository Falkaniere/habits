import SwiftUI

struct HabitCard: View {
    @Binding var toggleOn: Bool
    let title: String
    let description: String
    let markAsDone: () -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.system(size: 18))

                Text(description)
                    .font(.system(size: 12))
                    .opacity(0.8)
                    .lineLimit(1)
            }

            Spacer()
            Image(systemName: "gear")
                .font(.system(size: 18))
        }
        .padding(.vertical)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    @State var toggleOn = false

    return HabitCard(
        toggleOn: $toggleOn,
        title: "Test Habit",
        description: "Test Description",
        markAsDone: {
            toggleOn.toggle()
        }
    )
}
