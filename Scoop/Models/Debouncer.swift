import Foundation
import Dispatch

class Debouncer {
    private var workItem: DispatchWorkItem?
    private let queue: DispatchQueue
    
    init(queue: DispatchQueue = DispatchQueue.main) {
        self.queue = queue
    }
    
    func delay(for delay: TimeInterval, _ block: @escaping () -> Void) {
        workItem?.cancel()
        workItem = DispatchWorkItem(block: block)
        queue.asyncAfter(deadline: .now() + delay, execute: workItem!)
    }
}
