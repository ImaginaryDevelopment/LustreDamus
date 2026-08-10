#!/usr/bin/env python3
"""Prepare dist/ for GitHub Pages: sync samples, fix asset URLs, add .nojekyll."""

from __future__ import annotations

import shutil
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
DIST = ROOT / "dist"
ASSETS_SAMPLE = ROOT / "assets" / "samples" / "palworld" / "Mounts.md"
SOURCE_SAMPLE = ROOT / "samples" / "Mounts.md"


def sync_sample() -> None:
    if not SOURCE_SAMPLE.exists():
        raise SystemExit(f"Missing sample source: {SOURCE_SAMPLE}")
    ASSETS_SAMPLE.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy2(SOURCE_SAMPLE, ASSETS_SAMPLE)
    dist_sample = DIST / "samples" / "palworld" / "Mounts.md"
    dist_sample.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy2(SOURCE_SAMPLE, dist_sample)


def fix_index_paths() -> None:
    index = DIST / "index.html"
    html = index.read_text(encoding="utf-8")
    html = html.replace('src="/lustre_damus.js"', 'src="./lustre_damus.js"')
    html = html.replace('href="/app.css"', 'href="./app.css"')
    index.write_text(html, encoding="utf-8")
    (DIST / ".nojekyll").write_text("", encoding="utf-8")
    print(index.read_text(encoding="utf-8"))


def main() -> None:
    if not DIST.exists():
        raise SystemExit("dist/ missing — run `gleam run -m lustre/dev build` first")
    sync_sample()
    fix_index_paths()


if __name__ == "__main__":
    main()
