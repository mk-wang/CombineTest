import Combine
import Foundation
import PlaygroundSupport

public extension Date {
    var passedTime: TimeInterval {
        -self.timeIntervalSinceNow
    }
}

public func debugPrint(_ string: String) {
    let date = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm:ss.SSS"
    print(formatter.string(from: date) + " " + string)
}

private var playgroundPageObs: AnyCancellable?
public func test(action: (inout Set<AnyCancellable>, @escaping () -> Void) -> Void) {
    var obsSet = Set<AnyCancellable>()

    debugPrint("------- begin -------")
    let subject = PassthroughSubject<Void, Never>()

    playgroundPageObs = subject.sink {
        debugPrint("------- end -------")
        obsSet.removeAll()
        PlaygroundPage.current.finishExecution()
    }

    PlaygroundPage.current.needsIndefiniteExecution = true
    action(&obsSet) {
        subject.send(())
    }
}
