# Every developer task, in one place. Run `just` to list them.

set dotenv-load
set windows-shell := ["pwsh.exe", "-NoLogo", "-NoProfile", "-Command"]

# List the available recipes
default:
    @just --list --unsorted

# Install the toolchain, the git hooks and the dependencies (run this first)
setup:
    mise install
    lefthook install
    flutter pub get
    cargo fetch --locked

# Run the core (control API on 127.0.0.1:7531 by default)
core:
    cargo run -p teloche-core

# Run the TV app on this desktop
tv:
    cd apps/tv && flutter run -d {{ os() }}

# Run the remote on the connected Android device or emulator
remote:
    cd apps/remote && flutter run

# Format all the code
fmt:
    cargo fmt --all
    dart format .

# Check formatting and lints, without modifying anything
lint: lint-rust lint-flutter

lint-rust:
    cargo fmt --all --check
    cargo clippy --workspace --all-targets --locked -- -D warnings

lint-flutter:
    dart format --output=none --set-exit-if-changed .
    flutter analyze

# Run every test suite
test: test-rust test-flutter

test-rust:
    cargo nextest run --workspace --locked

test-flutter:
    cd packages/protocol && dart test
    cd packages/client && dart test
    cd packages/design_system && flutter test
    cd apps/tv && flutter test
    cd apps/remote && flutter test

# Check dependency licenses, security advisories and sources
deny:
    cargo deny --locked check

# Regenerate the protocol JSON Schema from crates/protocol
codegen:
    cargo xtask codegen

# Scan the git history for committed secrets
secrets:
    gitleaks git --no-banner --redact

# Run everything CI runs
ci: lint test deny secrets
    cargo xtask codegen --check
    just docs-build

# Serve the documentation with live reload on http://127.0.0.1:8000
docs:
    uv run --no-project --with-requirements docs/requirements.txt mkdocs serve

# Build the documentation, failing on any warning
docs-build:
    uv run --no-project --with-requirements docs/requirements.txt mkdocs build --strict

# Start a local SMB share for testing network sources (needs Docker)
samba:
    docker compose -f docker/samba/compose.yaml up -d
