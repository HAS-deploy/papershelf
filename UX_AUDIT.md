# PaperShelf — UX Audit (Stage 3.5)

**Date:** 2026-09-13  
**Scope:** High-value polish only. Physical camera UNVERIFIED. No NOT-list features.

## Findings

| Area | Severity | Finding | Action |
|------|----------|---------|--------|
| Empty states | Med | Empty shelf OK; no-results OK; missing “scanner unsupported” / camera-denied guidance | Add camera auth + unsupported copy |
| Errors | High | Camera denial not handled before VisionKit; OCR empty still saves but user gets no soft notice; PDF share failure silent | Preflight camera; OCR-empty alert; share error alert |
| Paywall | Med | Disclosures present; product buttons lack rich VoiceOver; loading state weak | Labels, loading ProgressView, Dynamic Type text styles |
| Dynamic Type | Med | Mostly system fonts; some fixed visual hierarchy OK; ensure titles use text styles | Prefer `.title`/`.headline`/`.body` |
| VoiceOver | High | Primary Scan/Import/Share/Unlock need explicit labels + hints | Add accessibilityLabel/Hint/Identifier |
| Dark mode | Low | Semantic colors mostly; processing dimmer uses black overlay | Use primary/black adaptive overlay |
| Lock screen | Low | Unlock control unlabeled for VO | Label + hint |
| Detail | Med | Page images unlabeled; empty OCR section absent | Accessibility on pages; “No text detected” section |

## Out of scope (NOT list)

Chat/RAG, accounts, Drive, folders/tags, GPT, analytics SDKs, redesign of IA.
