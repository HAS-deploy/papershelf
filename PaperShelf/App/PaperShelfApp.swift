import SwiftUI
import SwiftData

@main
struct PaperShelfApp: App {
    @StateObject private var appModel = AppModel()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(appModel.entitlements)
                .environmentObject(appModel.lock)
                .environmentObject(appModel.purchases)
                .task {
                    await appModel.purchases.refreshEntitlements()
                    await appModel.purchases.loadProducts()
                }
                .sheet(isPresented: .constant(ProcessInfo.processInfo.arguments.contains("-ScreenshotPaywall"))) {
                    PaywallView()
                        .environmentObject(appModel.entitlements)
                        .environmentObject(appModel.purchases)
                }
        }
        .modelContainer(for: ShelfDocument.self)
    }
}

@MainActor
final class AppModel: ObservableObject {
    let entitlements: EntitlementStore
    let lock: AppLockService
    let purchases: PurchaseManager

    init() {
        let entitlements = EntitlementStore()
        self.entitlements = entitlements
        self.lock = AppLockService()
        self.purchases = PurchaseManager(entitlements: entitlements)
    }
}
