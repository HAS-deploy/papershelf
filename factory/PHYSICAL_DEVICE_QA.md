# PaperShelf — Physical device QA (Stage 3 gate)
**App:** `/Users/tony/Developer/papershelf` · `com.papershelf.app`  
**Do not mark Stage 4 / APP STORE READY until this passes.**

## Install
1. Open `PaperShelf.xcodeproj` on Mac (or `xcodegen generate` first if needed)
2. Select your iPhone → Run
3. Allow Camera / Photos when prompted

## Pass bars (from V1)
| Gate | Target | Result |
|---|---|---|
| Scan quality | ≥47/50 ugly real docs → acceptable PDF without manual image edit | |
| OCR search | ≥95% clearly printed target words found | |
| Classification | ≥85% on Home/Auto/Medical/School/Financial (OTHER ≠ win if obvious) | |
| Speed | ~15s one-page capture → saved | |
| Zero-confusion | Stranger scans, finds, shares without coaching | |
| Persistence | Kill app / restart — docs remain | |
| Paywall | Hit 21st doc → Unlimited annual/lifetime; Cancel OK; Restore OK | |
| Privacy | No unexpected network for document contents | |

## Suggested corpus mix
Insurance letter, auto card, permission slip, medical bill, lab results, utility, bank/CC statement, home/vehicle repair invoice, lease, warranty, handwritten, crumpled, low-light, angled, multi-page, logo, small text, mixed orientation.

## Log
Date / device / iOS / notes — attach failures with photo of original + PDF screenshot.
