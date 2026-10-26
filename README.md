# TelocheSympatoche

[![CI](https://github.com/malo-coet/TelocheSympatoche/actions/workflows/ci.yml/badge.svg)](https://github.com/malo-coet/TelocheSympatoche/actions/workflows/ci.yml)
[![CD](https://github.com/malo-coet/TelocheSympatoche/actions/workflows/cd.yml/badge.svg)](https://github.com/malo-coet/TelocheSympatoche/actions/workflows/cd.yml)
[![License: MIT OR Apache-2.0](https://img.shields.io/badge/license-MIT%20OR%20Apache--2.0-blue)](#license)

A living-room media center: it organizes your movies, series, music and podcasts,
enriches them with artwork and summaries, plays them with libmpv, accepts extensions,
and is driven from your phone.

> **Status: Sprint 0.** The repository skeleton, tooling and CI/CD are in place; the
> features arrive iteration by iteration (see the [roadmap](https://github.com/malo-coet/TelocheSympatoche/milestones)).

## Highlights (planned)

- **10-foot interface** readable from three meters, fully usable with the arrow keys, Enter and Back.
- **Library** from local folders and network shares (SMB), with incremental scans, file name
  recognition, automatic enrichment and an offline cache.
- **Playback** through libmpv: subtitles, audio tracks, resume per profile, next episode.
- **Profiles** with history, favorites and parental control.
- **Extensions** sandboxed in WebAssembly, with smartphone-like permissions.
- **Remote control** Android app: discovery, secure pairing, D-pad, library browsing, "send to TV".
- **Accessible** by design, targeting WCAG 2.2 AA.

## Architecture

```text
apps/tv (Flutter desktop)  ──WebSocket──►  teloche-core (Rust)  ◄──WSS──  apps/remote (Flutter Android)
UI + libmpv renderer                       library, playback,             remote control
                                           extensions, control API
```

Every client, including the TV app itself, talks to the core through the same JSON-RPC
API. Details in [docs/dev/architecture.md](docs/dev/architecture.md).

| Path | Content |
|---|---|
| `crates/` | Rust core: `domain`, `recognizer`, `vfs`, `library`, `metadata`, `storage`, `playback`, `extensions`, `api`, `protocol`, and the `core` binary |
| `apps/tv` | Flutter desktop app (Linux, macOS, Windows) |
| `apps/remote` | Flutter Android remote |
| `packages/` | Shared Dart packages: `protocol`, `client`, `design_system` |
| `xtask/` | Repository automation (`cargo xtask codegen`) |
| `docs/` | User, developer and extension documentation, architecture decisions |
| `docker/` | Local services for development (SMB share) |

## Getting started

Requirements: [git](https://git-scm.com/), [mise](https://mise.jdx.dev/getting-started.html), and the
platform tools Flutter needs to build desktop apps: Xcode on macOS, `clang cmake ninja-build pkg-config
libgtk-3-dev` on Linux, Visual Studio with "Desktop development with C++" on Windows. The remote also
needs the Android SDK (Android Studio).

```bash
git clone https://github.com/malo-coet/TelocheSympatoche.git
cd TelocheSympatoche
mise install        # installs the pinned toolchain (Rust, Flutter, just...)
just setup          # git hooks and dependencies
just core           # terminal 1: the core, on 127.0.0.1:7531
just tv             # terminal 2: the TV app
```

Then:

```bash
just test           # every test suite, Rust and Flutter
just ci             # everything CI checks
just                # list all the tasks
```

The full walkthrough is in [docs/dev/getting-started.md](docs/dev/getting-started.md).

## Documentation

- [Developer guide](docs/dev/getting-started.md): setup, layout, conventions, CI/CD.
- [Architecture](docs/dev/architecture.md) and [decision records](docs/adr/index.md).
- User guide and extension developer guide: written along the iterations.

## Contributing

Read [CONTRIBUTING.md](CONTRIBUTING.md). Issues labelled
[`good first issue`](https://github.com/malo-coet/TelocheSympatoche/labels/good%20first%20issue)
are a good place to start. Please follow the [code of conduct](CODE_OF_CONDUCT.md), and report
vulnerabilities as described in [SECURITY.md](SECURITY.md).

## License

Licensed under either of [Apache License, Version 2.0](LICENSE-APACHE) or [MIT license](LICENSE-MIT),
at your option. Unless you explicitly state otherwise, any contribution you submit is dual licensed as
above, without any additional terms or conditions.
