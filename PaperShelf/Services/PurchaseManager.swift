import Foundation
import StoreKit

@MainActor
final class PurchaseManager: ObservableObject {
    @Published private(set) var products: [Product] = []
    @Published private(set) var isLoading = false
    @Published var lastError: String?

    let entitlements: EntitlementStore
    private var updatesTask: Task<Void, Never>?

    init(entitlements: EntitlementStore) {
        self.entitlements = entitlements
        updatesTask = Task { await listenForTransactions() }
    }

    deinit {
        updatesTask?.cancel()
    }

    func loadProducts() async {
        isLoading = true
        defer { isLoading = false }
        do {
            let ids: Set<String> = [
                EntitlementStore.yearlyProductID,
                EntitlementStore.lifetimeProductID
            ]
            products = try await Product.products(for: ids).sorted { lhs, rhs in lhs.price < rhs.price }
        } catch {
            lastError = error.localizedDescription
        }
    }

    func purchase(_ product: Product) async {
        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                let transaction = try checkVerified(verification)
                await apply(transaction)
                await transaction.finish()
            case .userCancelled:
                break
            case .pending:
                lastError = "Purchase pending approval."
            @unknown default:
                break
            }
        } catch {
            lastError = error.localizedDescription
        }
    }

    func restore() async {
        do {
            try await AppStore.sync()
            await refreshEntitlements()
        } catch {
            lastError = error.localizedDescription
        }
    }

    func refreshEntitlements() async {
        var lifetime = false
        var subExpiry: Date?
        for await result in Transaction.currentEntitlements {
            guard let transaction = try? checkVerified(result) else { continue }
            if transaction.productID == EntitlementStore.lifetimeProductID {
                lifetime = true
            } else if transaction.productID == EntitlementStore.yearlyProductID {
                subExpiry = transaction.expirationDate
            }
        }
        entitlements.setLifetimeUnlocked(lifetime)
        if lifetime {
            entitlements.setSubscription(active: true, expiry: nil)
        } else if let subExpiry, subExpiry > Date() {
            entitlements.setSubscription(active: true, expiry: subExpiry)
        } else {
            entitlements.setSubscription(active: false, expiry: subExpiry)
        }
    }

    private func apply(_ transaction: Transaction) async {
        if transaction.productID == EntitlementStore.lifetimeProductID {
            entitlements.setLifetimeUnlocked(true)
        } else if transaction.productID == EntitlementStore.yearlyProductID {
            entitlements.setSubscription(active: true, expiry: transaction.expirationDate)
        }
    }

    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified(_, let error):
            throw error
        case .verified(let safe):
            return safe
        }
    }

    private func listenForTransactions() async {
        for await update in Transaction.updates {
            if let transaction = try? checkVerified(update) {
                await apply(transaction)
                await transaction.finish()
            }
        }
    }

    var yearlyProduct: Product? {
        products.first { $0.id == EntitlementStore.yearlyProductID }
    }

    var lifetimeProduct: Product? {
        products.first { $0.id == EntitlementStore.lifetimeProductID }
    }
}
