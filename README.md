# LustreDamus

A [Lustre](https://hexdocs.pm/lustre/) (Gleam) app for reading and displaying Markdown tables, built as a static SPA that can be published to [GitHub Pages](https://pages.github.com/).

## Purpose

LustreDamus turns Markdown table source into a readable table view. The app is compiled to static HTML/JS so it can run as a GitHub Pages site (or any static host), with no backend required.

It supports two ways of getting content in:

1. **Local / bundled Markdown** — load tables from a Markdown file included with the deploy (useful when developing locally or shipping a known document with the site).
2. **Paste-in** — visitors open the GitHub Pages SPA, paste Markdown that contains tables, and see them rendered in the browser.

The goal is a small, focused static tool: parse Markdown tables, show them clearly, and ship as a single-page app anyone can open from GitHub Pages or run locally.
