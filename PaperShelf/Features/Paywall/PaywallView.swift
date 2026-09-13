import SwiftUI
import StoreKit

struct PaywallView: View {
    @EnvironmentObject private var purchases: PurchaseManager
    @EnvironmentObject private var entitlements: EntitlementStore
    @Environment(\.dismiss) private var dismiss

    private let privacyURL = URL(string: "https://has-deploy.github.io/papershelf/privacy.html")!
    private let termsURL = URL(string: "https://has-deploy.github.io/papershelf/terms.html")!

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Unlimited documents")
                        .font(.largeTitle.bold())
                        .accessibilityAddTraits(.isHeader)
                    Text("Free includes \(EntitlementStore.freeDocumentLimit) saved scans. Unlimited removes the cap — same scan, OCR, search, and PDF export. No ads. No watermark.")
                        .font(.body)
                        .foregroundStyle(.secondary)

                    if purchases.isLoading && purchases.yearlyProduct == nil {
                        ProgressView("Loading prices…")
                            .accessibilityLabel("Loading subscription prices")
                    }

                    if let yearly = purchases.yearlyProduct {
                        Button {
                            Task { await purchases.purchase(yearly) }
                        } label: {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Unlimited Yearly")
                                    .font(.headline)
                                Text("\(yearly.displayPrice) per year · auto-renewable")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(Color.accentColor.opacity(0.15))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .buttonStyle(.plain)
                        .accessibilityIdentifier("paywall.yearly")
                        .accessibilityLabel("Buy Unlimited Yearly for \(yearly.displayPrice) per year")
                        .accessibilityHint("Starts an auto-renewable one-year subscription")
                    } else if !purchases.isLoading {
                        Text("Unlimited Yearly — \(PricingConfig.yearlyDisplayPrice)/year")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.secondary.opacity(0.12))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .accessibilityLabel("Unlimited Yearly \(PricingConfig.yearlyDisplayPrice) per year")
                    }

                    if purchases.lifetimeProduct == nil && !purchases.isLoading {
                        Text("Unlimited Lifetime — \(PricingConfig.lifetimeDisplayPrice) one-time")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.secondary.opacity(0.12))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .accessibilityLabel("Unlimited Lifetime \(PricingConfig.lifetimeDisplayPrice)")
                    }

                    if let lifetime = purchases.lifetimeProduct {
                        Button {
                            Task { await purchases.purchase(lifetime) }
                        } label: {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Unlimited Lifetime")
                                    .font(.headline)
                                Text("\(lifetime.displayPrice) one-time purchase")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(Color.secondary.opacity(0.12))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .buttonStyle(.plain)
                        .accessibilityIdentifier("paywall.lifetime")
                        .accessibilityLabel("Buy Unlimited Lifetime for \(lifetime.displayPrice)")
                        .accessibilityHint("One-time purchase, not a subscription")
                    }

                    // Guideline 3.1.2(a) — annual subscription disclosures (verbatim)
                    VStack(alignment: .leading, spacing: 8) {
                        Text("PaperShelf Unlimited Yearly is an auto-renewable subscription for one year.")
                        Text("Payment will be charged to your Apple ID account at confirmation of purchase.")
                        Text("Subscription automatically renews unless canceled at least 24 hours before the end of the current period.")
                        Text("Your account will be charged for renewal within 24 hours prior to the end of the current period.")
                        Text("Subscriptions may be managed and auto-renewal may be turned off by going to the user's Account Settings after purchase.")
                    }
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .accessibilityIdentifier("paywall.subscriptionDisclosures")
                    .accessibilityElement(children: .combine)

                    HStack(spacing: 16) {
                        Link("Privacy Policy", destination: privacyURL)
                        Link("Terms of Use", destination: termsURL)
                    }
                    .font(.footnote)

                    Button("Restore Purchases") {
                        Task { await purchases.restore() }
                    }
                    .accessibilityIdentifier("paywall.restore")
                    .accessibilityLabel("Restore purchases")
                    .accessibilityHint("Restores previous Unlimited purchases for this Apple ID")

                    if let err = purchases.lastError {
                        Text(err)
                            .font(.footnote)
                            .foregroundStyle(.red)
                            .accessibilityLabel("Purchase error: \(err)")
                    }
                }
                .padding()
            }
            .navigationTitle("Upgrade")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                        .accessibilityIdentifier("paywall.close")
                        .accessibilityLabel("Close upgrade screen")
                }
            }
            .task {
                await purchases.loadProducts()
                if entitlements.hasUnlimited { dismiss() }
            }
            .onChange(of: entitlements.hasUnlimited) { _, on in
                if on { dismiss() }
            }
        }
    }

}
