# CHANGE_REPORT — PaperShelf STAGE 3.5 UX (2026-09-13)

**Path:** `/Users/tony/Developer/papershelf` only  
**PHYSICAL_CAMERA:** **UNVERIFIED**  
**ASC / PostHog / NOT-list features:** none

## Audit

`UX_AUDIT.md` — findings table + explicit out-of-scope.

## Fixes shipped

| Gap | Fix |
|-----|-----|
| Camera denied | `CameraAuth` preflight + Settings alert before VisionKit |
| Scanner unsupported | Empty-state + error copy; Import still available |
| OCR empty | Document still saved; soft alert “Saved without readable text” |
| Scanner fail | `DocumentScannerView.onFail` → user-visible error |
| PDF share fail | Alert on detail (was silent) |
| Paywall clarity | Loading prices, yearly/lifetime VO labels+hints, free-plan explanation, combined disclosure a11y |
| Free limit | Shelf banner when not Unlimited |
| Dynamic Type | System text styles (title/headline/body/footnote/subheadline) |
| VoiceOver | Scan/Import/Share/Delete/Unlock/Upgrade/Restore/rows/pages labeled |
| Dark mode | Semantic backgrounds; processing overlay uses `Color.primary.opacity` |
| Empty OCR section | Explicit “No readable text detected…” on detail |

## Verify

| Check | Result |
|-------|--------|
| Debug build | **BUILD SUCCEEDED** |
| Full unit + synthetic tests | **TEST SUCCEEDED** (8 tests, 0 failures) |
| Hygiene | Sim shut down; Simulator quit |

## Not done / not claimed

Physical camera UX on device · ASC · new product features from NOT list.
