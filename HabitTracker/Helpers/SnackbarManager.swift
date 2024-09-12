import SwiftUI
import Combine

class SnackbarManager: ObservableObject {
    static let shared = SnackbarManager()

    @Published var data = SnackbarData(title: "", type: .info)
    @Published var show = false

    private init() {}

    func showSnackbar(title: String, detail: String? = nil, type: SnackbarType = .warning) {
        DispatchQueue.main.async {
            self.data = SnackbarData(title: title, detail: detail, type: type)
            self.show = true
        }
    }
}

struct SnackbarData {
    var title: String
    var detail: String? = nil
    var type: SnackbarType
}

enum SnackbarType {
    case info
    case warning
    case success
    case error

    var tintColor: SwiftUI.Color {
        switch self {
        case .info:
            return SwiftUI.Color.blue
        case .success:
            return SwiftUI.Color.green
        case .warning:
            return SwiftUI.Color.yellow
        case .error:
            return SwiftUI.Color.red
        }
    }
}

struct FloatingSnackbar: View {
    @ObservedObject var snackbarManager = SnackbarManager.shared

    var body: some View {
        if snackbarManager.show {
            VStack {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(snackbarManager.data.title)
                            .bold()
                            .foregroundColor(.black)
                        if let detail = snackbarManager.data.detail {
                            Text(detail)
                                .font(Font.system(size: 15, weight: Font.Weight.light, design: Font.Design.default))
                        }
                    }
                    Spacer()
                }
                .foregroundColor(SwiftUI.Color.white)
                .padding(12)
                .background(snackbarManager.data.type.tintColor)
                .cornerRadius(8)
                .shadow(radius: 20)
                .padding()
                Spacer()
            }
            .transition(AnyTransition.move(edge: .top).combined(with: .opacity))
            .animation(.easeInOut(duration: 1.2))
            .onTapGesture {
                withAnimation {
                    snackbarManager.show = false
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    withAnimation {
                        snackbarManager.show = false
                    }
                }
            }
        }
    }
}

extension View {
    func floatingSnackbar() -> some View {
        ZStack {
            self
            FloatingSnackbar()
        }
    }
}
