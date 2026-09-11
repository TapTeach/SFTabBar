#!/usr/bin/env python3
"""Generate SFTabBar's symbol catalog from Apple's own SF Symbols metadata.

The SF Symbols app ships three property lists that between them describe every
symbol, its categories, and the release it was introduced in. Reading them
directly means the catalog is complete and correctly categorised by
construction, instead of being hand-maintained -- which is how new symbols
ended up stranded in a "What's New" bucket, invisible to category filtering.

Usage:
    Scripts/generate-symbols.py                      # newest SF Symbols app found
    Scripts/generate-symbols.py --app "/Applications/SF Symbols 8 beta.app"
    Scripts/generate-symbols.py --check              # verify the committed catalog

Run it again whenever Apple ships a new SF Symbols release; nothing else in the
project needs to change.
"""

import argparse
import datetime
import glob
import json
import plistlib
import re
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
OUTPUT = REPO_ROOT / "SFTabBar" / "SFTabBar" / "Resources" / "symbols-catalog.json"

# Categories that describe how a symbol *renders* rather than what it depicts.
# They overlap every real category and would make the browser useless.
NON_SEMANTIC = {"all", "whatsnew", "draw", "variable", "multicolor"}

# Symbols belonging to none of the semantic categories still need a home.
FALLBACK_TITLE = "Uncategorized"


def find_symbols_app(explicit=None):
    """Locate the SF Symbols app, preferring the highest version installed."""
    if explicit:
        path = Path(explicit)
        if not path.exists():
            sys.exit(f"error: {path} does not exist")
        return path

    candidates = [Path(p) for p in glob.glob("/Applications/SF Symbols*.app")]
    if not candidates:
        sys.exit(
            "error: no SF Symbols app found in /Applications.\n"
            "Download it from https://developer.apple.com/sf-symbols/"
        )
    return max(candidates, key=lambda p: version_tuple(read_version(p)))


def read_version(app_path):
    info = plistlib.loads((app_path / "Contents" / "Info.plist").read_bytes())
    return info.get("CFBundleShortVersionString", "0")


def version_tuple(version):
    parts = []
    for chunk in version.split("."):
        parts.append(int(chunk) if chunk.isdigit() else 0)
    return tuple(parts)


def load_metadata(app_path):
    metadata = app_path / "Contents" / "Resources" / "Metadata"
    if not metadata.is_dir():
        sys.exit(f"error: no Metadata directory in {app_path}")

    def read(name):
        path = metadata / name
        if not path.exists():
            sys.exit(f"error: {path} is missing -- unexpected app layout")
        return plistlib.loads(path.read_bytes())

    return (
        read("categories.plist"),
        read("symbol_categories.plist"),
        read("name_availability.plist"),
        read_aliases(metadata / "name_aliases.strings"),
    )


def read_aliases(path):
    """Deprecated spellings that resolve to a canonical symbol name.

    These carry availability entries but are duplicates of symbols already in
    the catalog, so they are excluded rather than listed twice.
    """
    if not path.exists():
        return set()

    raw = path.read_bytes()
    encoding = "utf-16" if raw[:2] in (b"\xff\xfe", b"\xfe\xff") else "utf-8"
    text = raw.decode(encoding, errors="replace")
    return {
        match.group(1)
        for match in re.finditer(r'"?([\w.]+)"?\s*=\s*"?[^";]+"?\s*;', text)
    }


def build_catalog(app_path):
    categories, symbol_categories, availability, aliases = load_metadata(app_path)
    app_version = read_version(app_path)

    releases = availability.get("symbols", {})
    year_to_release = availability.get("year_to_release", {})

    # name_availability.plist is the authoritative list of every symbol.
    # symbol_categories.plist covers most but not all of them, so driving the
    # catalog off the categories file alone silently drops ~500 real symbols
    # (apple.logo, arkit, app.gift.fill...). Take the union and let anything
    # without a category fall through to Uncategorized.
    universe = set(releases) - aliases

    # Apple's own display order, minus the rendering-attribute buckets.
    semantic = [c for c in categories if c["key"] not in NON_SEMANTIC]
    titles = {c["key"]: c.get("label", c["key"]) for c in semantic}
    icons = {c["key"]: c.get("icon") for c in semantic}

    buckets = {c["key"]: [] for c in semantic}
    orphans = []

    for name in sorted(universe):
        keys = [k for k in symbol_categories.get(name, []) if k in buckets]
        if keys:
            for key in keys:
                buckets[key].append(name)
        else:
            orphans.append(name)

    sections = []

    # The newest cohort leads the catalog -- it is what people open the app for.
    # Unlike the old hand-built catalogs these symbols are *also* filed under
    # their real categories below, so category filtering finds them too.
    newest_year = max(
        (r for r in year_to_release if r.split(".")[0].isdigit()),
        key=lambda r: version_tuple(r),
        default=None,
    )
    if newest_year:
        newest_major = newest_year.split(".")[0]
        whats_new = sorted(
            n for n in universe if releases[n].split(".")[0] == newest_major
        )
        if whats_new:
            major = app_version.split(".")[0]
            sections.append(
                {
                    "title": f"What's New in {major}",
                    "icon": "sparkles",
                    "items": whats_new,
                }
            )

    for category in semantic:
        key = category["key"]
        if buckets[key]:
            sections.append(
                {"title": titles[key], "icon": icons[key], "items": buckets[key]}
            )

    if orphans:
        sections.append(
            {"title": FALLBACK_TITLE, "icon": "square.grid.2x2", "items": orphans}
        )

    # A symbol's release is a property of the symbol, not of the category it is
    # listed under, so it lives in a lookup table rather than being repeated on
    # every one of the ~11k section entries.
    listed = {n for s in sections for n in s["items"]}

    return {
        "version": app_version,
        "generated": datetime.date.today().isoformat(),
        # release -> earliest iOS version carrying it, e.g. "2026" -> "27.0"
        "iOSVersions": {
            release: mapping["iOS"]
            for release, mapping in sorted(year_to_release.items())
            if "iOS" in mapping
        },
        # symbol -> the release that introduced it
        "symbolReleases": {
            name: releases[name] for name in sorted(listed) if name in releases
        },
        "sections": sections,
    }


def verify(catalog):
    """Assert the properties the hand-maintained catalogs used to get wrong."""
    by_title = {s["title"]: set(s["items"]) for s in catalog["sections"]}
    unique = set().union(*by_title.values()) if by_title else set()

    problems = []

    whats_new = next((t for t in by_title if t.startswith("What's New")), None)
    if whats_new:
        semantic = set().union(
            *(v for t, v in by_title.items() if t != whats_new)
        )
        stranded = by_title[whats_new] - semantic
        if stranded:
            # The original bug: new symbols reachable only through the
            # "What's New" bucket, invisible to every category filter.
            problems.append(
                f"{len(stranded)} new symbols are not in any real category "
                f"(e.g. {sorted(stranded)[:3]})"
            )

    missing_release = unique - set(catalog["symbolReleases"])
    if missing_release:
        problems.append(f"{len(missing_release)} symbols have no release metadata")

    if len(unique) < 4000:
        problems.append(f"only {len(unique)} symbols -- metadata looks truncated")

    for problem in problems:
        print(f"  FAIL: {problem}")
    return not problems


def summarise(catalog):
    unique = {n for s in catalog["sections"] for n in s["items"]}
    print(f"SF Symbols {catalog['version']}")
    print(f"  {len(unique)} unique symbols across {len(catalog['sections'])} sections")
    for section in catalog["sections"]:
        print(f"    {len(section['items']):>5}  {section['title']}")
    return unique


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--app", help="path to a specific SF Symbols.app")
    parser.add_argument(
        "--check",
        action="store_true",
        help="report what would change without writing",
    )
    args = parser.parse_args()

    app_path = find_symbols_app(args.app)
    print(f"reading {app_path}")

    catalog = build_catalog(app_path)
    summarise(catalog)

    print()
    if not verify(catalog):
        print("\nrefusing to write a catalog that fails verification")
        return 1
    print("verification passed")

    payload = json.dumps(catalog, indent=2, ensure_ascii=False) + "\n"

    if args.check:
        if not OUTPUT.exists():
            print(f"\n{OUTPUT.name} does not exist yet")
            return 1
        current = json.loads(OUTPUT.read_text())
        if current.get("version") != catalog["version"]:
            print(
                f"\ncommitted catalog is SF Symbols {current.get('version')}, "
                f"installed app is {catalog['version']}"
            )
            return 1
        print("\ncommitted catalog matches the installed SF Symbols version")
        return 0

    OUTPUT.parent.mkdir(parents=True, exist_ok=True)
    OUTPUT.write_text(payload)
    print(f"\nwrote {OUTPUT.relative_to(REPO_ROOT)} ({len(payload) / 1024:.0f} KB)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
