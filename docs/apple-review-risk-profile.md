# Apple Review Risk Profile — PaperShelf

**App name (marketing):** PaperShelf
**Bundle ID:** com.papershelf.app
**ASC App ID:** (not created — Stage 5)
**Primary owner:** Anthony McMurtrey / Tony McMurtrey

**Filled:** 2026-09-12 (Stage 0.5)  
**Sources:** `docs/spec.md` / Anthony V1 brief 2026-09-12; factory shared constants; ASC Stage 0 preflight  
**Owner:** Anthony McMurtrey  
**Bundle:** `com.papershelf.app`  
**Provisional marketing URL:** `https://has-deploy.github.io/papershelf/` (Pages not created yet — Stage 1.5)

## 1. One-sentence app purpose
Scan a document; the app automatically names it, files it into one of six categories, makes it searchable via on-device OCR, and lets the user share a clean PDF — no account required.  
*(cite: V1 promise)*

## 2. Account / login model
**No account.** No Sign in with Apple. Optional Face ID / device passcode app lock only (LocalAuthentication).  
*(cite: V1 Privacy — no account; Face ID lock)*  
4.8 SIWA: **N/A** (no third-party login).

## 3. Payment model
- Free tier with document cap (20 stored documents)
- Auto-renewable subscription: **Unlimited — $19.99/year**
- Non-consumable: **Unlimited Lifetime — $39.99**
- **No monthly**
- No ads, no watermark, no Stripe, no reader-app exception  
*(cite: V1 Monetization)*

## 4. What the app sells
**Digital unlock** of unlimited local document storage (and premium discriminator may include automatic classification/naming if needed). Not physical goods, not SaaS, not services performed off-device.  
*(cite: V1 Monetization)*

## 5. Data collected / stored / shared
| Data type | Collected by us? | Stored | Shared / leaves device |
|---|---|---|---|
| Document images / PDFs | No (user creates locally) | On device only | Only if user exports via Share Sheet |
| OCR text | No server collection | On device only | Only if user exports |
| Titles / categories | No | On device | Only if user exports |
| Purchase receipts | Apple StoreKit only | Apple + on-device entitlements | Apple |
| Analytics / IDFA / contact / health / financial account numbers | **Not collected** | — | — |
*(cite: V1 Privacy — no account, local storage, do not collect document contents; prefer no analytics V1)*

## 6. Account deletion path (5.1.1(v))
**N/A** — no accounts. User deletes documents in-app; uninstall removes local data.  
*(cite: no account)*

## 7. Permissions + NS*UsageDescription (planned)
| Permission | Why | Planned usage string direction |
|---|---|---|
| Camera | Document scanning | Scan paperwork to create PDFs |
| Photo Library (read) | Import existing photos/files | Import documents from Photos |
| Face ID | Optional app lock | Unlock PaperShelf |
No microphone, no precise always location, no contacts, no HealthKit.  
*(cite: V1 Scanner + Privacy)*

## 8. Regulated / high-scrutiny flags
| Flag | Status | Note |
|---|---|---|
| AI / ML | **ON** — on-device Vision OCR + local title/category heuristics | No external LLM/GPT API *(cite: V1 OCR + What NOT to build)* |
| Kids | OFF | |
| Health | OFF as product claim — users may scan medical bills; **no medical interpretation** *(cite: NOT list)* | Pre-empt in §11 |
| Finance | OFF as product claim — users may scan statements; **no advice/bookkeeping** *(cite: NOT list)* | Pre-empt in §11 |
| Legal | OFF | |
| UGC / social | OFF | |
| Code execution | OFF | |
| Background location | OFF | |
| Custom crypto | OFF | |
| Accounts / cloud backend | OFF | |

## 9. Reviewer demo path (5–10 taps)
1. Launch (no login)  
2. Tap **Scan** → allow camera if prompted  
3. Capture/import ≥1 page → confirm crop  
4. Wait for OCR → accept/edit proposed title + category → **Save**  
5. Confirm appears under Recent / category  
6. Search a printed word from the doc → open result  
7. Share → Save to Files / dismiss  
8. (Optional) Settings → enable Face ID lock  
9. Create docs until free cap → paywall shows Unlimited Annual / Lifetime → Cancel purchase OK  
*(cite: V1 core flow + monetization)*

## 10. Backend dependencies + uptime
**None for V1.** No Firebase/Supabase/custom AI backend. StoreKit + Apple frameworks only.  
*(cite: V1 architecture / NOT list)*  
Uptime during review: N/A (fully offline capable aside from IAP).

## 11. Pre-emptive reviewer notes draft
- **On-device AI (Guideline 4.2 / ML):** OCR and naming/classification run entirely on-device via Apple Vision and local heuristics; no document contents are uploaded to a developer server or third-party AI API.  
- **Medical paperwork:** App stores user-scanned documents locally and does not interpret, diagnose, or provide medical advice.  
- **Financial paperwork:** App does not provide banking, tax, or investment advice; it is a local scanner/archive utility.  
- **Privacy:** No account; documents remain on device unless the user explicitly shares via the system Share Sheet.  
- **IAP:** Free tier includes full scan/OCR/search/export with a 20-document storage cap; Unlimited is offered as $19.99/year auto-renewable and $39.99 lifetime; no ads or export watermarks.

## 12. Required App Store screenshots (planned)
1. Scan / camera capture  
2. Auto title + category confirmation  
3. Archive (Recent + categories)  
4. Search results  
5. Document viewer + Share  
6. Paywall (Unlimited) — honest prices  
*(cite: V1 UI surfaces)*

## 13. Privacy policy + terms URLs
Provisional (create at Stage 1.5 / Pages):  
- Privacy: `https://has-deploy.github.io/papershelf/privacy.html`  
- Terms: `https://has-deploy.github.io/papershelf/terms.html`  
- Support: `https://has-deploy.github.io/papershelf/support.html`  
- Marketing: `https://has-deploy.github.io/papershelf/`  
*(factory constant HAS-deploy Pages; not live until Stage 1.5 deploy)*

## 14. Subscription 3.1.2(a) — literal paywall commitment
Annual Unlimited **requires** these sentences on the paywall (factory / Apple 3.1.2(a)). Owner confirms paywall will **literally render** (prices configurable to ASC SoT):

- Payment will be charged to your Apple ID account at confirmation of purchase.  
- Subscription automatically renews unless it is canceled at least 24 hours before the end of the current period.  
- Your account will be charged for renewal within 24 hours prior to the end of the current period.  
- You can manage and cancel subscriptions in App Store account settings.  
- Any unused portion of a free trial (if offered later) is forfeited when you purchase a subscription.

**V1:** No free trial planned in Anthony brief — omit trial sentence if no trial is configured; do not invent a trial.  
Lifetime is non-consumable — not subject to auto-renew disclosure block, but restore purchases required.

## 15. Go / no-go
**GO for Stage 1 scaffold** — Stage 0 PASS; profile filled from owner V1 brief; no accounts/backend; annual + lifetime IAP with free 20-doc cap; on-device OCR only.

### Highest-risk guideline numbers (for Stage 1 notes)
**3.1.1 / 3.1.2(a)** (IAP + annual disclosure) · **5.1.1** (camera/photos privacy strings; local docs) · **4.2** (minimum functionality — must not look like a thin wrapper; scanner+OCR+file+search must work) · **2.1** (app completeness) · medical/finance **perception** risk mitigated by no-interpretation claims.