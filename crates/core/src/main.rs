//! `teloche-core`: composition root of the media center core.
//!
//! Reads its configuration from the environment, wires the crates together and
//! serves the control API until it receives Ctrl+C.

use std::net::SocketAddr;

use anyhow::Context;
use teloche_api::AppState;
use tracing_subscriber::EnvFilter;

const DEFAULT_BIND: &str = "127.0.0.1:7531";

#[tokio::main]
async fn main() -> anyhow::Result<()> {
    tracing_subscriber::fmt()
        .with_env_filter(
            EnvFilter::try_from_default_env().unwrap_or_else(|_| EnvFilter::new("info")),
        )
        .init();

    let bind: SocketAddr = std::env::var("TELOCHE_BIND")
        .unwrap_or_else(|_| DEFAULT_BIND.to_owned())
        .parse()
        .context("TELOCHE_BIND must be a socket address such as 127.0.0.1:7531")?;
    let listener = tokio::net::TcpListener::bind(bind)
        .await
        .with_context(|| format!("cannot listen on {bind}"))?;
    tracing::info!(address = %listener.local_addr()?, "control API listening");

    let state = AppState {
        server_version: env!("CARGO_PKG_VERSION").to_owned(),
    };
    axum::serve(listener, teloche_api::router(state))
        .with_graceful_shutdown(shutdown_signal())
        .await
        .context("control API stopped unexpectedly")
}

async fn shutdown_signal() {
    if let Err(error) = tokio::signal::ctrl_c().await {
        tracing::error!(%error, "cannot listen for Ctrl+C");
    }
    tracing::info!("shutting down");
}
