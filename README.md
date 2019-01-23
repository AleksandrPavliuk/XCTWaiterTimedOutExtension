# Source

```swift
extension XCTWaiter {
    static func waitForExpectation(withDescription: String,
                                   timedOut seconds: TimeInterval,
                                   andVerify assertsBlock:(() -> Void)) {
        let expectation = XCTestExpectation(description: withDescription)
        let _ = XCTWaiter.wait(for: [expectation], timeout: seconds)
        assertsBlock()
    }
}
```

# Usage
```swift
final class SomeMediatorTests: XCTestCase {

    var api: APIServiceMock!
    var view: ViewControllerMock!
    var mediator: SomeMediatorProtocol!

    override func setUp() {
        super.setUp()
        api = APIServiceMock()
        view = ViewControllerMock()
        mediator = SomeMediator(api: api, view: view)
    }

    func testRefreshUnreadNotificationsEndedSuccessfully() {
        api.backendModel = BackendNotificationsCodable.default

        mediator.refreshUnreadNotifications()

	// Closure will be executed after delay, in that case all async 
	// operations inside view updating process will have time to execute
        XCTWaiter.waitForExpectation(
            withDescription: "Waiting for notifications refresh",
            timedOut: 1,
            andVerify: {
            	// In the end of process, mediator should trigger view to
		// update and give new viewModel for that, error should be nil
                XCTAssertNotNil(self.view.viewModel)
                XCTAssertNil(self.view.error)
        }
        )
    }

    func testRefreshUnreadNotificationsEndedFailure() {
        api.error = SomeError.incorrectRequestError

        mediator.refreshUnreadNotifications()

        XCTWaiter.waitForExpectation(
            withDescription: "Waiting for notifications refresh failed",
            timedOut: 1,
            andVerify: {
            	// In the end of process, mediator should trigger view to 
		// update and give error instance, viewModel should be nil
                XCTAssertNil(self.view.viewModel)
                XCTAssertNotNil(self.view.error)
        }
        )
    }
}

```
