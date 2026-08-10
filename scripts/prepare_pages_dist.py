#!/usr/bin/env python3
"""Rewrite lustre_dev_tools root-absolute asset URLs to relative paths for GitHub Pages."""

from pathlib import Path


def main() -> None:
    dist = Path("dist")
    index = dist / "index.html"
    html = index.read_text(encoding="utf-8")
    html = html.replace('src="/lustre_damus.js"', 'src="./lustre_damus.js"')
    html = html.replace('href="/app.css"', 'href="./app.css"')
    index.write_text(html, encoding="utf-8")
    (dist / ".nojekyll").write_text("", encoding="utf-8")
    print(index.read_text(encoding="utf-8"))


if __name__ == "__main__":
    main()
