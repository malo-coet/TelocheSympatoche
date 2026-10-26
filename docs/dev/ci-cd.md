# CI/CD

All workflows live in `.github/workflows/`. Every check CI runs can be run locally with `just ci`.

| Workflow | Trigger | What it does |
|---|---|---|
| `ci.yml` | Pull requests, pushes on `main` | Lint and test Rust and Flutter, supply-chain checks, secret scan, schema drift, docs build, Linux build |
| `build.yml` | Called by the others | Builds the core, the TV app and the Android remote |
| `cd.yml` | Pushes on `main` | Builds every platform and uploads the archives as artifacts |
| `release.yml` | Pushes on `main` | Maintains the release pull request; once merged, tags and publishes a GitHub release with the builds |
| `docs.yml` | Docs changes on `main` | Publishes this documentation to GitHub Pages |
| `pr-title.yml` | Pull requests | Checks the title follows Conventional Commits |

## Required check

Jobs only run when their files change. The `CI OK` job aggregates them: skipped jobs pass, failed or
cancelled ones fail it. It is the single required status check on `main`.

## Artifacts

| Platform | Artifact |
|---|---|
| Linux | `teloche-core-linux-x64.tar.gz`, `teloche-tv-linux-x64.tar.gz` |
| macOS | `teloche-core-macos-arm64.tar.gz`, `teloche-tv-macos.zip` |
| Windows | `teloche-core-windows-x64.zip`, `teloche-tv-windows-x64.zip` |
| Android | `teloche-remote-android.apk` |

Installable packages (AppImage and .deb, .dmg, Windows installer) and a signed APK replace these archives
during iteration 4. Signing keys will be stored as GitHub secrets, never in the repository.

## Secrets

The pipeline currently needs no secret. Any future one (signing keys, API keys) goes in the repository's
GitHub secrets and is documented here.
