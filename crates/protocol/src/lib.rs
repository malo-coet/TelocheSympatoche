//! Wire contract between the core and its clients (TV app, remote, tests).
//!
//! Every type exchanged over the control API is defined here, once. The JSON
//! Schema in `packages/protocol/schema/` is generated from these types with
//! `cargo xtask codegen`, and CI fails when the committed schema drifts.

pub mod jsonrpc;
pub mod system;

use schemars::JsonSchema;

/// Version of the control API, exposed under `/api/v{API_VERSION}`.
pub const API_VERSION: &str = "1";

/// Every type of the contract, gathered so a single JSON Schema documents them all.
#[derive(JsonSchema)]
#[allow(dead_code)]
struct Contract {
    request: jsonrpc::Request,
    response: jsonrpc::Response,
    health: system::Health,
    ping_result: system::PingResult,
}

/// JSON Schema of the whole contract.
pub fn json_schema() -> schemars::Schema {
    schemars::schema_for!(Contract)
}
