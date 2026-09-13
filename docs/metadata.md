# ASC Metadata — PaperShelf

> Source of truth for what Stage 7 (`asc_metadata.py`) will push to App
> Store Connect. Keep this file synchronized with what's actually in ASC.
> Discrepancies between this file and ASC are a Stage 4A hard finding.

## App info (App Information tab)

| Field | Value |
|---|---|
| Name | PaperShelf |
| Subtitle (30 chars max) | Scan, name, file, find |
| Primary category | Productivity |
| Secondary category | Utilities |
| Privacy policy URL | https://has-deploy.github.io/papershelf/privacy.html |
| Privacy choices URL | (usually same as privacy URL) |

## Version info (per build)

| Field | Value |
|---|---|
| Version (MARKETING_VERSION) | 1.0.0 |
| Build (CURRENT_PROJECT_VERSION) | 1 |

## Version localization (en-US)

### Promotional text (170 chars, editable without new build)

Private paperwork scanner — on-device OCR, auto-file, PDF export.

### Description (≤4,000 chars)

PaperShelf turns messy paperwork into a searchable archive — privately, on your iPhone.

• Scan multi-page documents with automatic crop and perspective correction
• On-device OCR (Apple Vision) — searchable without uploading your files
• Automatic naming and one of six categories: Home, Auto, Medical, School, Financial, Other
• Fast local search across titles and document text
• Export clean PDFs via Share Sheet (AirDrop, Messages, Mail, Files, Print)
• Optional Face ID app lock
• No account. No mandatory cloud.

Free: up to 20 stored documents with full scan, OCR, search, and export.
Unlimited: $19.99/year or $39.99 lifetime. No ads. No watermarks.

PaperShelf does not interpret medical or financial advice — it stores and finds your scans.

> Guideline 2.3.1: description must accurately describe what the app does.
> Every feature claimed here must actually work in the build. Do not claim
> "unlimited" / "fully offline" / competitor-better phrasing unless you can
> back it up in the app. If the app has a subscription AND the EULA is
> Apple's standard one (no custom EULA uploaded), include a line like:
> "Terms of Use (EULA): https://www.apple.com/legal/internet-services/itunes/dev/stdeula/"

### Keywords (100 chars, comma-separated, no spaces)

scanner,ocr,pdf,documents,paperwork,scan,receipt,insurance,archive,files

### Support URL

https://has-deploy.github.io/papershelf/support.html

### Marketing URL (optional)

https://has-deploy.github.io/papershelf/

### What's New (release notes, per version)

Initial release.

## Review information

| Field | Value |
|---|---|
| Contact first name | Tony |
| Contact last name | McMurtrey |
| Contact email | tony@medbillresolve.com |
| Contact phone | N/A — email support only |
| Demo required | No |
| Demo username | N/A |
| Demo password | N/A |
| Review notes | (see `docs/app-review-notes.md` — paste into ASC Notes field) |

## Age rating

Answers set by `asc_metadata.py` — Apple's API wants literal booleans for
some and strings for others. Defaults:

- Cartoon/fantasy violence: `NONE`
- Realistic violence: `NONE`
- Prolonged graphic / sadistic violence: `NONE`
- Profanity / crude humor: `NONE`
- Sexual content or nudity: `NONE`
- Horror/fear themes: `NONE`
- Alcohol, tobacco, drug use: `NONE`
- Mature/suggestive themes: `NONE`
- Simulated gambling: `NONE`
- Medical/treatment information: `NONE`
- Unrestricted web access: `False`
- Gambling and contests: `False`
- Gambling (simulated): `NONE`
- Contests (user-generated): `False`

Override only when the app actually matches — e.g. AI content apps
typically bump to 17+.

## Content rights

`DOES_NOT_USE_THIRD_PARTY_CONTENT` unless PaperShelf bundles copyrighted
third-party material.

## Pricing

| Tier | Territory |
|---|---|
| Free with IAP | USA |

See Subscriptions playbook in `~/Documents/app-factory-workflow.md` for
setting per-territory prices when subs exist.

## IAP metadata (if any)

| Product ID | Reference name | Price | Subscription? |
|---|---|---|---|
| com.papershelf.app.unlimited.yearly | Unlimited Yearly | $19.99/year | Yes — auto-renewable annual |
| com.papershelf.app.unlimited.lifetime | Unlimited Lifetime | $39.99 | No — non-consumable |

## Screenshots

Place PNGs in `~/Developer/papershelf/screenshots/` in the following
structure:

```
screenshots/
  iphone-6.9/  3-10 PNGs, 1320×2868 or 2868×1320
  ipad-13/     3-10 PNGs, 2064×2752 or 2752×2064
```

Stage 7 uploads them via `POST /v1/appScreenshotSets`.
