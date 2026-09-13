import Foundation

@MainActor
final class EntitlementStore: ObservableObject {
    static let freeDocumentLimit = 20
    static let yearlyProductID = "com.papershelf.app.unlimited.yearly"
    static let lifetimeProductID = "com.papershelf.app.unlimited.lifetime"

    private let defaults = UserDefaults.standard
    private let unlimitedKey = "papershelf.unlimited.active"
    private let lifetimeKey = "papershelf.lifetime.active"
    private let expiryKey = "papershelf.subscription.expiry"

    @Published private(set) var isLifetime: Bool
    @Published private(set) var subscriptionExpiry: Date?

    init() {
        isLifetime = defaults.bool(forKey: lifetimeKey)
        if let t = defaults.object(forKey: expiryKey) as? Date {
            subscriptionExpiry = t
        } else {
            subscriptionExpiry = nil
        }
    }

    var hasUnlimited: Bool {
        if isLifetime { return true }
        if let expiry = subscriptionExpiry, expiry > Date() { return true }
        return defaults.bool(forKey: unlimitedKey) && (subscriptionExpiry == nil || (subscriptionExpiry ?? .distantPast) > Date())
    }

    func setLifetimeUnlocked(_ on: Bool) {
        isLifetime = on
        defaults.set(on, forKey: lifetimeKey)
        if on {
            defaults.set(true, forKey: unlimitedKey)
        }
        objectWillChange.send()
    }

    func setSubscription(active: Bool, expiry: Date?) {
        defaults.set(active, forKey: unlimitedKey)
        subscriptionExpiry = expiry
        if let expiry {
            defaults.set(expiry, forKey: expiryKey)
        } else {
            defaults.removeObject(forKey: expiryKey)
        }
        objectWillChange.send()
    }

    func canAddDocument(currentCount: Int) -> Bool {
        hasUnlimited || currentCount < Self.freeDocumentLimit
    }

    var remainingFreeSlots: Int {
        max(0, Self.freeDocumentLimit)
    }
}
