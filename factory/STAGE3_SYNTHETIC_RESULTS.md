# PaperShelf Stage 3 — Synthetic Acceptance Results

**Date:** 2026-09-13  
**PHYSICAL_CAMERA:** **UNVERIFIED** (do not claim device PASS)

## Corpus

- Path: `factory/corpus/` (+ mirrored `PaperShelfTests/Corpus/` for XCTest bundle)
- Samples: **60** PNG + companion JSON (`expectedCategory`, `searchTerms[]`)
- Coverage: insurance letter, auto card, school permission, medical bill, lab, utility, bank/CC, home/vehicle repair, lease, warranty, handwritten-ish, noise/crumple, low-contrast, rotated, multi-page pairs, logo, small text; categories HOME/AUTO/MEDICAL/SCHOOL/FINANCIAL + OTHER

## Harness

`PaperShelfTests/SyntheticAcceptanceTests.swift` — for each image:
1. Vision OCR via app `OCRService`
2. `TitleSuggestor` + `CategoryClassifier`
3. `PDFExportService.makePDF`
4. Assert search terms in OCR (clean-printed subset ≥95% target)
5. Category accuracy on specific categories ≥85% (OTHER incorrect if expected specific)
6. PDF bytes valid

## Rates (sim XCTest)

| Metric | Result | Target | Gate |
|--------|--------|--------|------|
| Clean printed search-term OCR | **138/138 = 100.0%** | ≥95% | **PASS** |
| Specific-category accuracy | **56/57 ≈ 98.2%** | ≥85% | **PASS** |
| PDF valid (≥1 page encode) | **60/60 = 100%** | 100% | **PASS** |

`physical_camera`: **UNVERIFIED**

## Machine summary

See `factory/STAGE3_SYNTHETIC_SUMMARY.json` (scraped from XCTest log).

## Not claimed

Physical-camera scan acceptance (47/50), real crumpled paper, lighting, etc. — **UNVERIFIED**.
