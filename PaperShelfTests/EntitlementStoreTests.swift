import XCTest
@testable import PaperShelf

@MainActor
final class EntitlementStoreTests: XCTestCase {
    func testFreeLimitGate() {
        let store = EntitlementStore()
        store.setLifetimeUnlocked(false)
        store.setSubscription(active: false, expiry: nil)
        XCTAssertTrue(store.canAddDocument(currentCount: 0))
        XCTAssertTrue(store.canAddDocument(currentCount: 19))
        XCTAssertFalse(store.canAddDocument(currentCount: 20))
    }

    func testLifetimeUnlocks() {
        let store = EntitlementStore()
        store.setLifetimeUnlocked(true)
        XCTAssertTrue(store.canAddDocument(currentCount: 500))
    }
}
