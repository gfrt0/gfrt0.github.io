# gfrt0.github.io

Personal academic website for Giuseppe Forte. Hosted on GitHub Pages, auto-deploys on push to `master`.

## Stack
- Jekyll 3.9 with the **no-style-please** theme (dark/monospace, heavily customized)
- Sass in `_sass/no-style-please.scss`, served via `assets/css/main.scss`
- No gemspec — gems declared directly in `Gemfile`

## Structure
- `index.md` — home page (layout: `home`), profile photo + prose intro
- `research.md` — research page at `/research` (layout: `page`)
- `content/` — PDFs (CV, papers), images (ghost.webp)
- `assets/img/personal.jpeg` — profile photo
- `_includes/nav.html` — persistent nav bar (home / research / cv / github icon / obfuscated email)
- `_includes/goat_counter.html` — analytics (production only)
- `_layouts/default.html` — base layout, includes nav at top of `.w` div
- `_layouts/home.html` — flexbox photo + text header
- `_layouts/page.html` — simple title + content

## Key details
- **Contact email** is JS-obfuscated in `nav.html` to prevent scraping. Display text uses `[﹫]`, `mailto:` is assembled in JS only.
- **CV link** points to `/content/forte_cv.pdf` with `target="_blank"` (opens in browser, not download).
- **GitHub link** uses an inline SVG octocat icon.
- **CSS**: `.w` container is `width: 100%; max-width: 960px` for responsive fit. Profile photo is 240px (200px on mobile ≤600px).
- **No `_posts/` directory** — research was moved to a standalone page. No blog functionality.
- **License**: MIT (inherited from theme fork). Site content is the author's own.
