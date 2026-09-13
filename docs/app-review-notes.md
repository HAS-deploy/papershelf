# App Review Information → Notes — PaperShelf

> Paste this (minus the commentary blocks) into
> **App Store Connect → App → Version → App Review Information → Notes**
> when submitting. Keep it to 1,500 chars or less.
>
> This file is regenerated from `docs/apple-review-risk-profile.md`
> section 8 (flags) and section 11 (reviewer-notes draft). If the risk
> profile changes, re-scaffold this file or edit in place to match.

---

## What PaperShelf does

Scan a document; PaperShelf names it, files it, makes it searchable, and shares a clean PDF — no account.

## How to exercise the app in 30 seconds

1) Launch 2) Scan/import page 3) Accept title/category → Save 4) Search a printed word 5) Share PDF 6) Optional: create 21st doc to see paywall → Cancel

## Why each permission prompt appears

Camera scans paperwork. Photos imports existing images. Face ID optionally locks the app.
<!--
  One short paragraph per permission in section 7 of the risk profile.
  Copy the NS*UsageDescription text verbatim and add a sentence of context
  the reviewer couldn't derive from the string alone.
-->

## Pre-emptive notes on flagged items

On-device AI: OCR and naming/classification use Apple Vision and local heuristics; document contents are not uploaded to a developer or third-party AI service.
Medical/financial scans: PaperShelf stores documents locally and does not interpret, diagnose, or advise.
Privacy: No account; local storage; optional Face ID; Share Sheet only on user action.
IAP: Free tier includes full features with a 20-document cap; Unlimited is $19.99/year or $39.99 lifetime with required auto-renew disclosures on the annual paywall.
<!--
  For every box checked in section 8 of the risk profile, one paragraph:
  name the concern, cite the guideline number, explain why we comply, point
  to specific evidence in the app.

  Examples:

  AI content (17+):
  "PaperShelf uses OpenAI's text API to summarize user-uploaded
  contracts. Per 4.0 design + 1.1 safety, the app rates at 17+; content is
  generated from user uploads only, not open-ended prompts; output is
  shown read-only."

  Document parsing (2.1 completeness):
  "Every parser path has error, empty, and partial-input handling — see
  Parser.parseIngredientLine covering 10+ malformed cases in
  ParserTests.swift. No crash path, no placeholder UI."

  Reader-app exception (3.1.3(a)):
  "PaperShelf signs into None via web OAuth; we do not sell or
  unlock content inside the app. All payment happens on None's
  web property. Users can still use the app's local features without an
  account."
-->

## Demo credentials

N/A — no login
<!--
  If login is required, paste the demo creds from
  docs/reviewer-demo-credentials.md. If no accounts, say "No login
  required — the app works from the first launch."
-->

## Known limitations we want to acknowledge

Physical-camera QA required before App Store submit. Optional iCloud sync not in V1.
<!--
  Small but non-guideline-breaking things worth pre-empting:
  - "iPad landscape-only: we split to phone/pad assets in a future update"
  - "No macOS support yet"
  - "Analytics: we use Apple App Analytics only; no third-party tracking"
-->

## Contact during review

- Name: Tony McMurtrey
- Email: tony@medbillresolve.com
- Phone: N/A — email support only

---

_Last edited: 2026-09-13_
