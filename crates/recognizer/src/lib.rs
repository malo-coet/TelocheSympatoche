//! Turns raw file names into structured guesses: movie title and year, series
//! season and episode (`Show.S01E02.mkv`, `1x02`...), artist and album.
//!
//! Recognition is a pure, ordered pipeline of rules. Every rule is covered by
//! table-driven cases, which makes this crate the entry point for new
//! contributors (see `docs/dev/getting-started.md`).
