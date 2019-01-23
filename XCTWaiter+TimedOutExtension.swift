//
//  Created by Aleksandr Pavliuk on 12/25/18.
//

import Foundation
import XCTest

extension XCTWaiter {
    static func waitForExpectation(withDescription: String,
                                   timedOut seconds: TimeInterval,
                                   andVerify assertsBlock:(() -> Void)) {
        let expectation = XCTestExpectation(description: withDescription)
        let _ = XCTWaiter.wait(for: [expectation], timeout: seconds)
        assertsBlock()
    }
}
