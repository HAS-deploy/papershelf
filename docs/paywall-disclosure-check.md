# Paywall Disclosure Check — PaperShelf

> **If this app has any auto-renewable subscription**, every box below must
> be checked before the build ships. Missing any single one is a HARD
> rejection under **Guideline 3.1.2(a/c)**. The paywall-hard-gate.py script
> reads this file and fails if any box is unchecked.

App has a subscription? Yes — Unlimited Annual $19.99/year; Lifetime $39.99 non-consumable

If the answer above is **no**, stop here — this file does not apply.

---

## In-app checklist (visible on the paywall screen the reviewer will see)

Verified in `PaperShelf/Features/Paywall/PaywallView.swift` (Stage 3.5):

- [x] Subscription **title** displayed (matches ASC reference name)
- [x] Subscription **length** displayed ("monthly" / "yearly" / "week" / etc.)
- [x] **Price** per period displayed (e.g. "$4.99/month")
- [x] Price-per-unit displayed if not obvious on the primary unit
      (e.g. "$59.99/year (~$5/month)") — yearly shows "$X per year · auto-renewable"; lifetime shows one-time
- [x] Exact sentence present, verbatim:
      **"Payment will be charged to your Apple ID account at
      confirmation of purchase."**
- [x] Exact sentence present, verbatim:
      **"Subscription automatically renews unless canceled at least 24
      hours before the end of the current period."**
- [x] Exact sentence present, verbatim:
      **"Your account will be charged for renewal within 24 hours prior
      to the end of the current period."**
- [x] Exact sentence present, verbatim:
      **"Subscriptions may be managed and auto-renewal may be turned off
      by going to the user's Account Settings after purchase."**
- [x] Tappable **Privacy Policy** link — opens live URL (not `mailto:`)
- [x] Tappable **Terms of Use (EULA)** link — opens live URL
- [x] **Restore Purchases** button visible
- [x] Cancel / Dismiss button visible (not a dark pattern — reviewer must
      be able to close the paywall without buying)

## ASC metadata checklist

**Stage 5 — deferred until ASC app/IAP create (Owner GO). Not claimed done.**

- Stage 5: Privacy Policy URL populated on App Information tab (Pages URL live; ASC field not written yet)
- Stage 5: EULA / Terms of Use URL on App Information or description
- Stage 5: Each subscription has its own App Store Review screenshot via subscriptionAppStoreReviewScreenshots
- Stage 5: Each subscription priced across territories
- Stage 5: Each subscription `READY_TO_SUBMIT` before version submit

## Paywall screenshot evidence

- `screenshots/iphone/03-paywall.png` (primary)
- `screenshots/paywall-primary.png` (copy for disclosure packet)

## Source file(s) implementing the paywall

PaperShelf/Features/Paywall/PaywallView.swift
PaperShelf/Services/PurchaseManager.swift
PaperShelf/Services/PricingConfig.swift
PaperShelf/Services/EntitlementStore.swift

## Link reachability check (run before every submission)

```bash
curl -sSfI https://has-deploy.github.io/papershelf/privacy.html >/dev/null && echo "privacy OK"
curl -sSfI https://has-deploy.github.io/papershelf/terms.html   >/dev/null && echo "terms OK"
```

Both should print `OK`. If not, fix hosting before shipping.
