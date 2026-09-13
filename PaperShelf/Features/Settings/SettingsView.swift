import SwiftUI
import SwiftData

struct SettingsView: View {
    @EnvironmentObject private var lock: AppLockService
    @EnvironmentObject private var entitlements: EntitlementStore
    @EnvironmentObject private var purchases: PurchaseManager
    @Query private var documents: [ShelfDocument]
    @State private var showPaywall = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Library") {
                    LabeledContent("Documents", value: "\(documents.count)")
                    if entitlements.hasUnlimited {
                        Text(entitlements.isLifetime ? "Unlimited · Lifetime" : "Unlimited · Yearly")
                            .accessibilityLabel(entitlements.isLifetime ? "Unlimited lifetime active" : "Unlimited yearly active")
                    } else {
                        Text("Free plan · \(max(0, EntitlementStore.freeDocumentLimit - documents.count)) slots left")
                            .foregroundStyle(.secondary)
                        Button("Upgrade to Unlimited") { showPaywall = true }
                            .accessibilityHint("Opens the upgrade screen")
                    }
                }

                Section("Security") {
                    Toggle("Require Face ID / Passcode", isOn: $lock.isEnabled)
                        .accessibilityHint("When enabled, PaperShelf locks when you leave the app")
                    Text("Locks PaperShelf when you leave the app. Documents never leave this device.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }

                Section("About") {
                    LabeledContent("Version", value: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0")
                    Text("On-device scan, OCR, and storage. No account. No analytics SDK.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }

                Section {
                    Button("Restore Purchases") {
                        Task { await purchases.restore() }
                    }
                    .accessibilityLabel("Restore purchases")
                }
            }
            .navigationTitle("Settings")
            .sheet(isPresented: $showPaywall) {
                PaywallView()
            }
        }
    }
}
