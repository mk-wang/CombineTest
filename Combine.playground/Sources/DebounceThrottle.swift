import Combine
import Foundation

public func testThrottle() {
    test() {obsSet, done in
        let start = Date()
        let subject = PassthroughSubject<Int, Never>()
        let publisher = subject.print("DEBUG").eraseToAnyPublisher()
        
        publisher.debounce(for: .seconds(3), scheduler: RunLoop.main)
            .sink { index in
                debugPrint("debounce \(index) \(start.passedTime)")
            }.store(in: &obsSet)
        
        publisher.throttle(for: .seconds(3), scheduler: RunLoop.main, latest: false)
            .sink { index in
                debugPrint("throttle latest false\t\(index) \(start.passedTime)")
            }.store(in: &obsSet)
        
        publisher.throttle(for: .seconds(3), scheduler: RunLoop.main, latest: true)
            .sink { index in
                debugPrint("throttle latest true\t\(index) \(start.passedTime)")
            }.store(in: &obsSet)
        
        DispatchQueue.global(qos: .background).async {
            (0 ..< 16).forEach {
                subject.send($0 + 1)
                sleep(1)
            }
            sleep(4)
            done()
        }
    }
}
