# LustreDamus

A [Lustre](https://hexdocs.pm/lustre/) (Gleam) app for reading and displaying Markdown tables, built as a static SPA that can be published to [GitHub Pages](https://pages.github.com/).

## Purpose

LustreDamus turns Markdown table source into a readable table view. The app is compiled to static HTML/JS so it can run as a GitHub Pages site (or any static host), with no backend required.

It supports two ways of getting content in:

1. **Local / bundled Markdown** — load tables from a Markdown file included with the deploy (useful when developing locally or shipping a known document with the site).
2. **Paste-in** — visitors open the GitHub Pages SPA, paste Markdown that contains tables, and see them rendered in the browser.

The goal is a small, focused static tool: parse Markdown tables, show them clearly, and ship as a single-page app anyone can open from GitHub Pages or run locally.

## Setup

Requires [Gleam](https://gleam.run/getting-started/installing/), Erlang/OTP on `PATH`, and [rebar3](https://rebar3.org/docs/getting-started/) (needed by `lustre_dev_tools`).

On Windows after `winget install -e --id Gleam.Gleam`, add `C:\Program Files\Erlang OTP\bin` to your user `PATH`, then install rebar3 per its docs (`rebar3` escript + `rebar3.cmd` wrapper).

```sh
gleam deps download
```

## Develop

```sh
gleam run -m lustre/dev start
```

This starts the Lustre dev server with live reload. Open the URL it prints (usually `http://localhost:1234`).

## Build (static SPA)

```sh
gleam run -m lustre/dev build --minify
python scripts/prepare_pages_dist.py
```

Output lands in `dist/` (`index.html`, JS bundle, and assets). The prepare script rewrites Lustre’s root-absolute `/lustre_damus.js` to a relative path so the app works under `https://<user>.github.io/LustreDamus/`.

## GitHub Pages

Deploy is automated by [`.github/workflows/deploy-pages.yml`](.github/workflows/deploy-pages.yml) on pushes to `master`.

1. Push these changes to `master`.
2. In the repo on GitHub: **Settings → Pages → Build and deployment → Source: GitHub Actions**.
3. After the workflow succeeds, the site is at:
   `https://ImaginaryDevelopment.github.io/LustreDamus/`

You can also run the workflow manually from the **Actions** tab (`workflow_dispatch`).
