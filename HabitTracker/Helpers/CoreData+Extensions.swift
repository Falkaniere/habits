import Foundation

extension Optional where Wrapped == String {
    var bound: String {
        get { self ?? "" }
        set { self = newValue }
    }
}

extension Optional where Wrapped == Date {
    var bound: Date {
        get { self ?? Date() }
        set { self = newValue }
    }
}
