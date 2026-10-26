# Getting started

From a fresh clone to a running media center and green tests.

## 1. Install the toolchain

Every tool version is pinned in `mise.toml` (and `rust-toolchain.toml`), so everyone builds with the
same versions as CI.

1. Install [mise](https://mise.jdx.dev/getting-started.html) and activate it in your shell.
2. Install the platform tools Flutter needs for desktop apps:
    - **macOS:** Xcode (from the App Store), then `sudo xcodebuild -runFirstLaunch`.
    - **Linux:** `sudo apt install clang cmake ninja-build pkg-config libgtk-3-dev liblzma-dev`.
    - **Windows:** Visual Studio with the "Desktop development with C++" workload.
3. For the remote, install Android Studio (Android SDK and an emulator).

```bash
mise install    # Rust, Flutter, just, lefthook, cargo-nextest, cargo-deny, gitleaks, uv
just setup      # git hooks, Dart and Rust dependencies
```

`flutter doctor` tells you what is still missing for each platform.

## 2. Run it

```bash
just core       # the core; the control API listens on 127.0.0.1:7531
just tv         # the TV app on this desktop
just remote     # the remote, on a connected Android device or emulator
```

Check the core from another terminal:

```bash
curl http://127.0.0.1:7531/health
```

Configuration comes from environment variables; copy `.env.example` to `.env` to change them.

## 3. Test it

```bash
just test       # all suites
just test-rust  # Rust only (cargo nextest)
just ci         # everything CI checks: lint, tests, supply chain, secrets, schema, docs
```

To run a single test:

```bash
cargo nextest run -p teloche-api ping_returns_versions
cd apps/tv && flutter test --plain-name "arrow keys"
```

External APIs are always mocked in tests: the suites pass offline.

## Where things are

| You want to change... | Look in |
|---|---|
| The API messages (requests, results, events) | `crates/protocol`, then `just codegen` |
| How a request is handled | `crates/api` |
| How the core starts and is configured | `crates/core` |
| File name recognition | `crates/recognizer` |
| The TV interface | `apps/tv/lib` |
| Colors, spacing, focus style, shared widgets | `packages/design_system` |
| The remote | `apps/remote/lib` |
| A developer task | `justfile` |
| CI/CD | `.github/workflows`, described in [CI/CD](ci-cd.md) |

## Troubleshooting

- **`just: command not found`:** mise is not activated in your shell (see its getting started guide).
- **Flutter cannot build for this desktop:** run `flutter doctor` and install what it reports.
- **Port 7531 already in use:** set `TELOCHE_BIND=127.0.0.1:<port>` in `.env`.
