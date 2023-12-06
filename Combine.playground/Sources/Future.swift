import Combine
import Foundation

func futureIncrement(
    integer: Int,
    afterDelay delay: TimeInterval) -> Future<Int, Never> {
        .init { promise in
            debugPrint("Original")
            
            DispatchQueue.global().asyncAfter(deadline: .now() + delay) {
                promise(.success(integer + 1))
            }
        }
    }

public func testFuture() {
    test { obsSet, done in
        let futurePublisher = futureIncrement(integer: 1, afterDelay: 2)

        futurePublisher
            .receive(on: RunLoop.main)
            .print("_Future_")
            .sink { completion in
                switch completion {
                case .finished:
                    debugPrint("finished")
                case let .failure(error):
                    debugPrint("Got a error: \(error)")
                }
                done()
            } receiveValue: { value in
                debugPrint(value)
            }.store(in: &obsSet)
    }
}
