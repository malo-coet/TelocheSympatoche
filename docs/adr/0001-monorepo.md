# 0001. One monorepo

- **Status:** Accepted
- **Date:** 2026-10-26

## Context

The product has several parts that evolve together: the Rust core, the TV app, the Android remote,
shared Dart packages, extensions, themes and documentation. The API contract between the core and its
clients changes often in the first iterations. The team has three members and must keep the repository
easy to join (a new contributor runs everything in under 15 minutes).

## Options

1. **One repository per part:** independent histories and releases, but every contract change needs
   coordinated pull requests across repositories, and onboarding means cloning and wiring several.
2. **One monorepo:** a single clone, atomic changes across the core and its clients, one CI and one
   issue tracker; CI must avoid rebuilding everything on every change.

## Decision

One monorepo, with a Cargo workspace for Rust and a pub workspace for Dart. CI filters jobs by path so a
change only runs the checks it can affect.

## Consequences

- A protocol change, its Rust implementation and its Dart clients land in one pull request.
- One version and one changelog for the whole product.
- CI path filters must be maintained when directories are added.
