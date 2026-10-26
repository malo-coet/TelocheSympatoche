# Architecture decision records

Each significant decision is recorded as an ADR: its context, the options considered, the choice and its
consequences. Copy [the template](0000-template.md) to propose one; it is accepted when its pull request is
merged. ADRs are never edited after acceptance: a new ADR supersedes an old one.

| # | Decision | Status |
|---|---|---|
| [0001](0001-monorepo.md) | One monorepo for the core, the apps, the extensions and the docs | Accepted |
| [0002](0002-rust-core-flutter-clients-single-api.md) | Rust core as a sidecar, Flutter clients, one control API | Accepted |

Planned during Sprint 0, each closing a spike or a choice: playback backend, SQLite and sqlx, extension
sandbox, protocol and code generation, pairing and transport security, network share protocol, remote
platform, theme format, branching and releases.
