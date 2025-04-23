import SwiftUI

struct HabitProgressBar: View {
    let progress: CGFloat

    var body: some View {
      ZStack {
        Circle()
          .stroke(lineWidth: 2)
          .opacity(0.1)
          .foregroundColor(.blue)

        Circle()
          .trim(from: 0.0, to: min(progress, 1.0))
          .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
          .foregroundColor(.blue)
          .rotationEffect(Angle(degrees: 270.0))
          .animation(.linear, value: progress)
      }
    }
}


#Preview {
    HabitProgressBar(progress: 0.4)
        .frame(width: 16, height: 16)
}
