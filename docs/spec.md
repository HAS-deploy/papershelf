# PaperShelf — Build #1 (LOCKED 2026-09-12)
**Working name:** PaperShelf (rename OK before ASC create)  
**Owner GO:** Anthony — stop researching; one Builder cycle  
**Promise:** Scan a document. It automatically gets named, filed, becomes searchable, and can be shared as a clean PDF. No account required.

## V1 includes
Scan (multi-page, VisionKit, crop/perspective, reorder) · on-device Vision OCR · auto title · 6 categories (Home/Auto/Medical/School/Financial/Other) · archive Recent+categories · local search · PDF export/Share · Face ID lock · StoreKit 2 free 20 docs / Unlimited $19.99/yr + $39.99 lifetime · no monthly · no ads

## Explicitly NOT V1
Chat/RAG · teams · web · Android · accounts · Firebase · e-sign · fax · expense/tax · GPT API · folders/tags · Drive/Dropbox · filter sliders

## Stack
Swift · SwiftUI · Vision/VisionKit · PDFKit · SwiftData · StoreKit 2 · LocalAuthentication · no server

## Acceptance (do not fake device tests)
Scan 47/50 · OCR ≥95% printed · category ≥85% · ~15s one-page save · zero-confusion stranger test · release gate PASS/FAIL list

## ADAPT note
ExpiryVault = expiration reminders — **REJECT ADAPT**; this is scan→OCR→file→search. New app.


---
Full engineering brief:

You are the lead iOS engineer building and validating a production-quality App Store MVP.

App working name: PaperShelf (bundle provisional: com.papershelf.app — changeable before ASC create).

CORE PROMISE:
Scan a document. The app automatically names it, files it, makes it searchable, and lets the user share a clean PDF. No account required.

PRIORITY: The smallest application that performs this workflow exceptionally reliably — NOT maximum features.

PRODUCT PRINCIPLES
1. Native iOS first (Swift / SwiftUI).
2. No user account.
3. Local-first.
4. No backend unless technically unavoidable.
5. No external AI API unless absolutely necessary.
6. Prefer Apple frameworks.
7. Privacy by default.
8. Fast launch.
9. Extremely simple UI.
10. Every primary workflow must actually work on a physical iPhone (mark UNVERIFIED — DEVICE TEST REQUIRED if not tested; never fabricate device tests).

CORE USER FLOW (optimize relentlessly):
OPEN APP → Scan → photograph one or more pages → auto crop/correct → local OCR → propose useful name → propose one of six categories → Save → appears in archive → search finds OCR words → open → share/export PDF.

TECH STACK
Swift, SwiftUI, latest production iOS SDK, Vision / VisionKit, PDFKit, SwiftData (unless strong reason for Core Data), StoreKit 2, LocalAuthentication, native Share Sheet. Document every third-party dependency and why Apple frameworks were inadequate. Prefer ZERO third-party deps.

DOCUMENT MODEL (minimum)
UUID, created/modified dates, title, suggested title, category, OCR text, page count, page/image refs, generated PDF ref, optional import source.

CATEGORIES (fixed V1 — no taxonomy system):
HOME, AUTO, MEDICAL, SCHOOL, FINANCIAL, OTHER

SCANNER
Multi-page; detect boundaries; crop; perspective correct; rotate; reorder; delete; retake; import from Photos/Files where practical; portrait+landscape; readable output. Sensible auto enhancement ONLY — no filter sliders.

OCR
On-device Vision OCR; non-blocking UI; store normalized text; preserve scan if OCR fails; never destroy scan on OCR failure. Search indexes title + OCR text + category.

AUTOMATIC TITLE
Propose concise human-readable title from OCR (org + doc type + date when certain). Never invent facts not in document. Conservative when uncertain. Always editable.

AUTOMATIC CATEGORY
Classify into the six categories from contents; deterministic/local only; no upload. Low confidence → OTHER. User can change.

ARCHIVE UI
Prominent Scan; Search; Recent; six categories. Rows: title, category, date, page count, thumbnail if performant. Extremely simple.

SEARCH
Fast local search as user types; title + OCR + category.

DOCUMENT VIEWER
View/zoom pages; edit title/category; delete; share; export PDF; print via iOS.

PDF EXPORT
Valid multi-page PDF; Share Sheet (AirDrop, Messages, Mail, Files, Print).

PRIVACY
No account; no mandatory cloud; on-device storage; optional Face ID app lock; App Store privacy language; do not collect document contents; analytics only if privacy-safe product events (prefer none for V1).

MONETIZATION (StoreKit 2)
Free: max 20 stored documents; scan/OCR/search/export work normally.
Paid Unlimited: $19.99/year + $39.99 lifetime. NO monthly. No ads. No watermark. No crippled exports.
Paywall when exceeding free limit. Purchases, restore, entitlement persistence, expiration, lifetime, errors. StoreKit Configuration file for local testing. Products configurable (ASC prices may differ).

FAILURE HANDLING
Camera denied, OCR fail, interrupted scan, background during processing, low storage, bad import, PDF fail, StoreKit unavailable/cancel/restore, Face ID unavailable/fail, delete single/multi-page, restart during processing. Data loss unacceptable.

PERFORMANCE TARGETS
Fast cold launch; scan UI almost immediately; ~15s one-page capture→saved; no UI freeze during OCR; smooth scroll ≥500 docs; usable search with thousands OCR records. Measure.

ACCESSIBILITY
Dynamic Type, VoiceOver, contrast, large targets, dark mode, landscape where practical.

TEST CORPUS
Insurance letter, auto card, permission slip, medical bill, lab results, utility, bank/CC statements, home/vehicle repair invoice, lease, warranty, handwritten, crumpled, low-light, angled, multi-page, logo, small text, mixed orientation. Synthetic OK for automated tests; physical-camera required before release-ready.

ACCEPTANCE (do not mark complete until verified)
- Scan: ≥47/50 acceptable PDFs without image editing
- OCR: ≥95% clearly printed terms found
- Classification: ≥85% on five specific categories (OTHER ≠ correct when obvious)
- Search: known OCR terms return correct doc
- PDF: correct page count/order
- Persistence: kill/restart — no loss
- Purchase: annual, lifetime, cancel, fail, restore, expiration sim, offline entitlement
- Privacy: never transmit images/OCR/titles to external endpoint

RELEASE GATE (PASS means exercised+verified; never fabricate device tests)
ENGINEERING / SCANNING / OCR / CLASSIFICATION / SEARCH / EXPORT / PURCHASES / PRIVACY / UI-UX / ACCESSIBILITY / APP STORE READY

SCOPE CONTROL — DO NOT BUILD
document chatbot, RAG, web, Android, accounts, teams, shared workspaces, fax, e-sign, Dropbox/Drive, accounting, receipt expense, medical interpretation, tax advice, complicated folders, arbitrary tags, collaboration, GPT APIs. Record as future experiments only.

DELIVERABLES
1) working Xcode project 2) architecture summary 3) dependency inventory 4) feature checklist 5) automated test results 6) performance measurements 7) failed tests 8) known limitations 9) screenshots of critical flows 10) App Store metadata draft 11) privacy disclosures 12) purchase-product setup instructions 13) physical-device QA checklist 14) final release-gate report

Start by scaffolding the Xcode/SwiftUI project and implementing the core Scan→OCR→Name→Category→Save→Search→Share path end-to-end with StoreKit config. Ship a functional shell first; then harden toward acceptance tests. Do not polish indefinitely.
