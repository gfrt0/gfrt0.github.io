# gfrt0.github.io

Personal academic website for Giuseppe Forte. Built with [Hugo][hugo] and
deployed to GitHub Pages by `.github/workflows/hugo.yml` on push to `master`.

## Theme

`themes/academimal/` is a vendored copy of [academimal][academimal] by Lei Yang
(MIT), a Hugo port of GitHub's Jekyll *Minimal* theme, at commit
`acf9ebb05fbc0e7dc4bbfa7219e6d86a934654d2` (2019-03-22) — the same revision
[gautamrao.github.io][rao] pins.

It is vendored rather than used as a submodule because that commit is not
reachable from any branch upstream: `yangl1996/academimal` was later rewritten
into a different theme whose publication layouts and data schema do not match.
The commit is currently fetchable by raw SHA only, which is not a safe base for
a submodule. Local modifications are marked in the files.

## Editing

| what | where |
| --- | --- |
| site title, bio line, photo, CV link, analytics | `config.toml` |
| bio / contact / other prose | `content/sections/*.md` |
| papers | `data/{job_market_paper,working_papers,work_in_progress,publications}/list.yaml` |
| section order and headings | `themes/academimal/layouts/index.html` |
| sidebar nav | `themes/academimal/layouts/partials/sidebar.html` |

Sections and data files are self-registering: the nav entry and the section both
appear only when the corresponding file exists, so deleting
`data/work_in_progress/list.yaml` removes the Work in Progress section and its
nav link. Adding a section means adding it to `index.html` and `sidebar.html`.

Paper entry fields: `title`, `pdflink`, `coauthors`, `book`, `note`,
`links: [{url, text, note}]`, `abstract`. `coauthors`, `book`, `note` and
`abstract` accept inline HTML. Only `title` is required.

## Local preview

```bash
hugo server        # http://localhost:1313
hugo --gc --minify # writes public/
```

Requires the **extended** Hugo build (see `HUGO_VERSION` in the workflow for the
version CI uses).

## History

Through 2026-08 the site was a Jekyll fork of [no-style-please][nsp] — dark,
monospace, with separate `/research` and `/projects` pages. That version is
preserved on the `legacy/no-style-please` branch and the `jekyll-final` tag.
`/research` and `/projects` now redirect to the single page via Hugo aliases.

[hugo]: https://gohugo.io/
[academimal]: https://github.com/yangl1996/academimal
[rao]: https://github.com/gautamrao/gautamrao.github.io
[nsp]: https://github.com/riggraz/no-style-please
