# Contributing

Thanks for helping! This guide covers the workflow; the technical walkthrough is in
[docs/dev/getting-started.md](docs/dev/getting-started.md).

## Setup

```bash
mise install && just setup
```

`just setup` installs the git hooks: formatting and secret scanning before each commit, and the commit
message check.

## Workflow

1. **Pick or open an issue.** Every change starts from an issue in the project board, with an owner, a
   label and a milestone.
2. **Branch from `main`**, named `<type>/<issue>-<short-description>`, e.g. `feat/42-incremental-scan`.
   Branches are short-lived: open the pull request early, as a draft if needed.
3. **Commit** using [Conventional Commits](https://www.conventionalcommits.org/):
   `<type>(<scope>): <description>`.
   - Types: `feat`, `fix`, `docs`, `test`, `refactor`, `perf`, `style`, `build`, `ci`, `chore`, `revert`.
   - Scopes: the area touched, e.g. `library`, `api`, `tv`, `remote`, `extensions`, `ci`.
   - Breaking changes: `feat(api)!: ...`.
4. **Open a pull request** linked to its issue (`Closes #42`) and fill in the template.
5. **Review:** at least one approval from another team member, and the `CI OK` check green. `main` is
   protected: nothing lands without both.
6. **Squash-merge.** The pull request title becomes the commit on `main`, so it must follow Conventional
   Commits too (checked automatically).

## Definition of done

- Tests cover the change; `just ci` passes locally.
- Documentation is updated: `docs/`, README, and an [ADR](docs/adr/index.md) when a decision is made.
- UI changes are usable with the arrow keys, Enter and Back only, keep a visible focus, meet contrast
  requirements and are checked with a screen reader.
- No secret, credential or media file is committed. Configuration goes in `.env` (see `.env.example`).

## Code style

Formatting and lints are enforced, not discussed: `just fmt` formats everything, `just lint` checks it.

- **Rust:** `rustfmt` and `clippy -D warnings`. Errors with `thiserror` in libraries and `anyhow` in
  binaries. No `unsafe`. Keep ownership simple: clone or `Arc` before reaching for lifetimes.
- **Dart:** `dart format` (120 columns) and the shared `analysis_options.yaml`.

## Releases

Releases are automated by release-please from the commits on `main`: it maintains a release pull
request, and merging it tags the version (semantic versioning), updates `CHANGELOG.md` and publishes a
GitHub release with the builds.
