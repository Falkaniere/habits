import SwiftUI

struct HabitCard: View {
    let title: String
    let description: String
    let habitProgess: CGFloat

    var body: some View {
        HStack {
            HabitProgressBar(progress: habitProgess)
                .frame(width: 16, height: 16)
                .padding()
            
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
                .padding()
        }
        .padding(.vertical)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    return HabitCard(
        title: "Test Habit",
        description: "Test Description",
        habitProgess: 0.5
    )
}
