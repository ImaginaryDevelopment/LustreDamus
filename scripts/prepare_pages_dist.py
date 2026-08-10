#!/usr/bin/env python3
"""Prepare dist/ for GitHub Pages: fix asset URLs and add .nojekyll."""

from __future__ import annotations

from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
DIST = ROOT / "dist"


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
    fix_index_paths()


if __name__ == "__main__":
    main()
