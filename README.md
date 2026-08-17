# gfrt0.github.io

Personal academic website for Giuseppe Forte, built with [Hugo][hugo] and
deployed to GitHub Pages on push to `master`.

Structurally it follows [gautamrao.github.io][rao]: the [academimal][academimal]
theme (MIT, by Lei Yang), papers as YAML data files, one page with anchor
navigation. Two deliberate departures:

- **The theme is vendored, not a submodule.** The pinned commit (`acf9ebb`) is
  not reachable from any upstream branch — `yangl1996/academimal` was later
  rewritten into a different theme with incompatible publication layouts — so it
  is fetchable by raw SHA only, which makes for a fragile submodule.
  Local modifications are marked in the theme files.
- **Sections are self-registering.** A section and its nav link render only if
  the corresponding `data/<section>/list.yaml` exists, so adding or dropping a
  paper category is a matter of adding or deleting one file.

Local preview: `hugo server` (requires the **extended** build).

[hugo]: https://gohugo.io/
[academimal]: https://github.com/yangl1996/academimal
[rao]: https://github.com/gautamrao/gautamrao.github.io
