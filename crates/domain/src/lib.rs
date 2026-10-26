//! Domain model of the media center: entities (movie, series, episode, track,
//! podcast, profile...), business rules, and the ports (traits) through which
//! the rest of the core reaches the outside world (`Vfs`, `MetadataProvider`,
//! `Renderer`, `SecretStore`, repositories).
//!
//! This crate performs no I/O and depends on no framework: adapters live in the
//! other crates and implement the ports defined here.
