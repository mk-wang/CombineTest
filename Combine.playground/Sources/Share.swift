import Foundation

public func testShare() {
    test { obsSet, done in
        let pub = (1 ... 3).publisher
            .print("Origin")
            .delay(for: 1, scheduler: DispatchQueue.main)
            .map { _ in Int.random(in: 0 ... 100) }
            .print("Random")
//            .share()

        pub.sink { debugPrint("Stream 1 received: \($0)") }
            .store(in: &obsSet)
   
        pub.sink { _ in
            done()
        } receiveValue: { 
            debugPrint("Stream 2 received: \($0)")
        }.store(in: &obsSet)
    }
}
