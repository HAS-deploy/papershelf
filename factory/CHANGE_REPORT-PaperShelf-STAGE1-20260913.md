# CHANGE_REPORT — PaperShelf STAGE1 CODE SCAFFOLD (2026-09-13)

**Status:** Shell builds · unit tests green · launch smoke OK  
**Path:** `/Users/tony/Developer/papershelf` (new app — not a fork)  
**Bundle:** `com.papershelf.app` · Team `NH2XFPC9KN` · Version `1.0.0` / build `1`  
**DerivedData:** `/Users/tony/Developer/portfolio-growth/derived/papershelf-stage1`  
**Artifacts:** `/Users/tony/Developer/portfolio-growth/baseline-results/papershelf-stage1/`

## What shipped

XcodeGen project (**zero SPM / third-party deps** — **no PostHog**):

| Area | Implementation |
|------|----------------|
| Scan | VisionKit `VNDocumentCameraViewController` multi-page |
| Import | PhotosUI multi-image import |
| OCR | Vision `VNRecognizeTextRequest` on-device |
| Title | `TitleSuggestor` from OCR (conservative) |
| Category | `CategoryClassifier` → HOME/AUTO/MEDICAL/SCHOOL/FINANCIAL/OTHER |
| Persistence | SwiftData `ShelfDocument` + JPEG pages + PDF under Application Support |
| Archive | Recent list, category filter, local search title+OCR+category |
| Detail | Edit title/category, page preview, OCR text, Share Sheet PDF |
| Lock | Optional Face ID / passcode via LocalAuthentication |
| StoreKit 2 | Free **20** docs; Unlimited **yearly $19.99** + **lifetime $39.99**; `Configuration.storekit`; Restore; **3.1.2(a)** verbatim yearly disclosures on paywall |

**Not built (per V1 lock):** accounts, backend, GPT, analytics SDKs, chat/RAG, Drive, folders/tags.

## Products (local StoreKit)

- `com.papershelf.app.unlimited.yearly` — $19.99 / year  
- `com.papershelf.app.unlimited.lifetime` — $39.99 non-consumable  

## Verification

| Check | Result |
|-------|--------|
| `xcodegen generate` | OK → `PaperShelf.xcodeproj` |
| Debug build (iPhone 17 Pro sim) | **BUILD SUCCEEDED** |
| Unit tests | **TEST SUCCEEDED** — **7** tests, **0** failures |
| Launch | `simctl launch com.papershelf.app` → process alive; screenshot `launch.png` |
| Launch target | **`PaperShelf.app`** (not UITests-Runner) |

## Key files

- `project.yml`
- `ARCHITECTURE.md`
- `PaperShelf/App/PaperShelfApp.swift`, `RootView.swift`
- `PaperShelf/Services/*` (OCR, title, category, PDF, StoreKit, lock, pipeline)
- `PaperShelf/Features/{Scan,Archive,Document,Paywall,Settings}/*`
- `PaperShelf/Resources/Configuration.storekit`
- `PaperShelfTests/*`

## Known limitations (Stage 1)

- App icon asset placeholder (no 1024 marketing icon yet)
- Privacy/Terms paywall links point at future `has-deploy.github.io/papershelf/*` (docs HTML already in repo `docs/`)
- Device scan/OCR acceptance corpus **UNVERIFIED — DEVICE TEST REQUIRED**
- No ASC create/upload (not in scope)
- Entitlement unit tests touch shared `UserDefaults` keys (local sim only)

## Hygiene

Simulator shut down; Simulator.app quit; no leftover papershelf `xcodebuild`.

## Next (CoS)

Stage 1.5 packet placeholders · physical-device QA · icon · Pages hosting for privacy/terms · ASC when Owner GO.
