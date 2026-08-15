# SFTabBar

An iOS design tool for building and previewing iPhone tab bars with SF Symbols.
Configure 2–5 tabs, watch a static mock update live, run the arrangement in a
real `TabView`, then copy the generated SwiftUI.

Requires iOS 27 and Xcode 27.

## Tab roles

Each tab can take one role, matching SwiftUI's `TabRole`:

| Role | Rendering |
|---|---|
| None | Sits in the main glass capsule with its label |
| Search | Detached into the trailing slot, icon only |
| Prominent | Detached into the trailing slot, icon only |

At most one tab may be search and one prominent. When both exist, the prominent
tab takes the trailing slot and the search tab falls back into the capsule —
mirroring Apple's rule that a search tab only inherits the prominent treatment
when nothing else claims it. Verified against iOS 27.0 (24A5408d): the prominent
treatment *is* the detached slot, with no extra fill or tint, and badges are
honoured there.

A prominent tab is a destination, not a floating action button.

## Updating the SF Symbols catalog

The symbol browser reads `SFTabBar/Resources/symbols-catalog.json`, generated
from the metadata inside the installed SF Symbols app:

```bash
Scripts/generate-symbols.py
```

It picks the newest `/Applications/SF Symbols*.app` automatically; pass `--app`
to choose one explicitly, or `--check` to compare the committed catalog against
what is installed. Each symbol is filed under Apple's own categories *and* a
synthesized "What's New" section, so new symbols stay reachable through category
filtering. The catalog also carries each symbol's release and the earliest iOS
version that ships it.

Install a new SF Symbols release, rerun the script, commit the result — no code
changes needed.

## Build

```bash
xcodebuild -project SFTabBar.xcodeproj -scheme SFTabBar -destination 'platform=iOS Simulator,name=iPhone 17 Pro,OS=27.0' build
```
