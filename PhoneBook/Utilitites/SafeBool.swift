import Foundation

/// Thread safe bool

class SafeBool {
    private var isTrue: Bool = false
    private let queue = DispatchQueue(label: "safe bool", attributes: .concurrent)
    
    public func write(value: Bool) {
        queue.async(flags: .barrier) {
            self.isTrue = value
        }
    }
    
    public func read() -> Bool {
        var result: Bool = false
        queue.sync {
            result = isTrue
        }
        return result
    }
}
