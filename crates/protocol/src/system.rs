//! `system.*` methods and the health endpoint.

use schemars::JsonSchema;
use serde::{Deserialize, Serialize};

/// Checks that the core is reachable and returns its versions.
pub const PING: &str = "system.ping";

#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize, JsonSchema)]
pub struct PingResult {
    pub server_version: String,
    pub api_version: String,
}

/// Body of `GET /health`.
#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize, JsonSchema)]
pub struct Health {
    pub status: String,
    pub server_version: String,
}
