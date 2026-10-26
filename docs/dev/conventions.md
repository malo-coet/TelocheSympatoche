# Conventions

The contribution workflow (issues, branches, commits, pull requests, definition of done) is in
[CONTRIBUTING.md](https://github.com/malo-coet/TelocheSympatoche/blob/main/CONTRIBUTING.md). This page
covers the technical conventions.

## Naming

- Rust crates are named `teloche-<area>` and live in `crates/<area>`.
- Dart packages are named `teloche_<area>`.
- The short name `teloche` is used in identifiers: the full brand name is too long for some of them
  (DNS-SD service names are limited to 15 characters).

## Rust

- Errors: `thiserror` in libraries, `anyhow` in binaries and `xtask`.
- No `unsafe` (forbidden workspace-wide).
- Logging with `tracing`; the level is set with `RUST_LOG`.
- New dependencies go in `[workspace.dependencies]`, and must pass `just deny` (permissive licenses only).

## Dart and Flutter

- One `analysis_options.yaml` at the root applies to every package.
- Widgets that can take focus are built from `packages/design_system` components, which handle the
  visible focus and the semantics.
- Every screen has a widget test running the accessibility guidelines (contrast, labelled and sized tap
  targets).

## Versions

- Toolchains are pinned in `mise.toml` and `rust-toolchain.toml`; change them in a dedicated pull request.
- Dependencies are locked (`Cargo.lock`, `pubspec.lock`) and updated weekly by Dependabot.
