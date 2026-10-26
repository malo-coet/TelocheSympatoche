//! Control API of the core, used by every client: the TV app, the remote and
//! the end-to-end tests.
//!
//! - `GET /health`: liveness probe.
//! - `GET /api/v1/ws`: WebSocket carrying JSON-RPC 2.0 calls and notifications.

mod rpc;

use std::sync::Arc;

use axum::Json;
use axum::Router;
use axum::extract::State;
use axum::extract::ws::{Message, WebSocket, WebSocketUpgrade};
use axum::response::Response;
use axum::routing::get;
use teloche_protocol::system::Health;

/// Shared state handed to every request handler.
#[derive(Debug)]
pub struct AppState {
    pub server_version: String,
}

pub fn router(state: AppState) -> Router {
    Router::new()
        .route("/health", get(health))
        .route("/api/v1/ws", get(ws_upgrade))
        .with_state(Arc::new(state))
}

async fn health(State(state): State<Arc<AppState>>) -> Json<Health> {
    Json(Health {
        status: "ok".to_owned(),
        server_version: state.server_version.clone(),
    })
}

async fn ws_upgrade(ws: WebSocketUpgrade, State(state): State<Arc<AppState>>) -> Response {
    ws.on_upgrade(move |socket| serve_socket(socket, state))
}

async fn serve_socket(mut socket: WebSocket, state: Arc<AppState>) {
    tracing::debug!("control client connected");
    while let Some(Ok(message)) = socket.recv().await {
        match message {
            Message::Text(text) => {
                if let Some(reply) = rpc::handle_text(text.as_str(), &state)
                    && socket.send(Message::Text(reply.into())).await.is_err()
                {
                    break;
                }
            }
            Message::Close(_) => break,
            _ => {}
        }
    }
    tracing::debug!("control client disconnected");
}
