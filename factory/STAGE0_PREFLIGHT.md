# Stage 0 — PREFLIGHT — PaperShelf
**Date:** 2026-09-12  
**Name:** PaperShelf  
**Bundle:** `com.papershelf.app`  
**Slug:** papershelf  

| Check | Result | Severity |
|---|---|---|
| iTunes exact "PaperShelf" | No exact-name live app (fuzzy results only: Penbook, Paperly PDF, etc.) | PASS |
| Name similarity | Crowded "Paper/Scanner" category; name not identical to a live title | SOFT WARN |
| ASC bundle `com.papershelf.app` | GET bundleIds filter → **0** | **PASS (HARD)** |
| ASC portfolio name collision | 0/19 apps with "paper" in name | PASS |
| Domain papershelf.com | Resolves (registered) — marketing can use HAS-deploy Pages | INFO |
| Domain papershelf.app | No DNS | INFO |
| GitHub `HAS-deploy/papershelf` | HTTP 404 (available) | PASS |
| USPTO TESS | Manual: https://tmsearch.uspto.gov/search/search-information | OWNER |

**Verdict: PASS** — proceed to Stage 0.5. Soft warn: category is competitive; differentiation is local-first auto-name/file, not "another scanner."
