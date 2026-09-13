# CHANGE_REPORT — PaperShelf STAGE3 SYNTHETIC ACCEPTANCE (2026-09-13)

**Path:** `/Users/tony/Developer/papershelf` only  
**PHYSICAL_CAMERA:** **UNVERIFIED** — do not claim device PASS  
**ASC / PostHog:** none

## Delivered

1. **Corpus (≥50):** `factory/corpus/` — **60** synthetic PNGs + JSON expectations (also bundled as `PaperShelfTests/Corpus/`).
2. **Harness:** `PaperShelfTests/SyntheticAcceptanceTests.swift` exercises app `OCRService` → `TitleSuggestor` → `CategoryClassifier` → `PDFExportService`.
3. **Results:** `factory/STAGE3_SYNTHETIC_RESULTS.md` + `factory/STAGE3_SYNTHETIC_SUMMARY.json`

## Rates

| Gate | Rate | Target | Result |
|------|------|--------|--------|
| Clean printed OCR search terms | **100%** (138/138) | ≥95% | **PASS** |
| Specific-category (non-OTHER expected) | **≈98.2%** (56/57) | ≥85% | **PASS** |
| PDF generate valid | **100%** (60/60) | 100% | **PASS** |

## Build / tests

Full `xcodebuild test` **TEST SUCCEEDED** (unit + synthetic). Build remains green.

## Explicit non-claims

- Physical camera scan corpus / 47/50 real-scan acceptance: **UNVERIFIED**
- No ASC, no analytics SDKs, no scope creep
