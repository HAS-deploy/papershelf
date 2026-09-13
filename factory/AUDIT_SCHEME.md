# Xcode scheme for audits

On macOS case-insensitive APFS, `PaperShelf.xcscheme` and `papershelf.xcscheme` collide.

**Canonical scheme name:** `papershelf` (matches folder basename → `audit-full.py` default).

```bash
xcodebuild -project PaperShelf.xcodeproj -scheme papershelf -destination 'platform=iOS Simulator,name=iPhone 17 Pro' test
```

Target / display name remain **PaperShelf** (`com.papershelf.app`).
