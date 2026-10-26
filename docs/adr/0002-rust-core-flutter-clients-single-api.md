# 0002. Rust core as a sidecar, Flutter clients, one control API

- **Status:** Accepted
- **Date:** 2026-10-26

## Context

The media center needs a robust core (library scans, metadata, extension sandbox, network API) and two
interfaces: a 10-foot desktop app on Linux and at least one of macOS or Windows, and an Android remote.
Playback must go through a real playback library (libmpv), not a browser player. The team knows C++/Qt
and web development, and wants to learn Rust and Flutter.

## Options

1. **Qt/QML in C++ with a native Kotlin remote:** proven with libmpv, but two UI stacks and slower
   development.
2. **Rust core embedded in the Flutter app through FFI (flutter_rust_bridge):** one process, but two API
   surfaces (FFI for the TV app, network for the remote) and coupled builds.
3. **Rust core as a separate process, Flutter for both apps, every client on the same network API.**
4. **Tauri or Electron with a web UI:** embedding libmpv video under a web view is fragile across OSes.

## Decision

Option 3. The core is a headless Rust binary (`teloche-core`) the TV app launches as a sidecar. The TV app
(Flutter desktop, libmpv through media_kit) and the remote (Flutter Android) are both clients of the same
JSON-RPC API over WebSocket. The TV app also acts as the playback renderer driven by the core.

## Consequences

- One API surface: the remote can do everything the TV can, and both share `packages/client`.
- Rust and Flutter developers work in parallel: Flutter work does not require building the core with
  every change, and the core is tested without any UI.
- The core can run headless for development, tests and CI, and the TV app can restart it if it crashes.
- Packaging ships two executables per desktop platform; the TV app manages the core's lifecycle.
- The local connection adds a serialization step; its latency (well under a millisecond) is negligible
  for remote control.
