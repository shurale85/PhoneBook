import Foundation

/// Thread safe array
class SafeArray<T> {
    private var array = [T]()
    private let queue = DispatchQueue(label: "safe array", attributes: .concurrent)
    
    public func append(_ values: [T]) {
        queue.async(flags: .barrier) {
            self.array.append(contentsOf: values)
        }
    }
    
    public var valueArray: [T] {
        var result = [T]()
        queue.sync {
            result = self.array
        }
        return result
    }
}
