//! End-to-end checks of the control API over real HTTP and WebSocket connections.

use axum::body::{Body, to_bytes};
use axum::http::{Request, StatusCode};
use futures_util::{SinkExt, StreamExt};
use serde_json::{Value, json};
use teloche_api::{AppState, router};
use tokio_tungstenite::tungstenite::Message;
use tower::ServiceExt;

fn app() -> axum::Router {
    router(AppState {
        server_version: "0.0.0-test".to_owned(),
    })
}

#[tokio::test]
async fn health_reports_ok() {
    let response = app()
        .oneshot(Request::get("/health").body(Body::empty()).unwrap())
        .await
        .unwrap();

    assert_eq!(response.status(), StatusCode::OK);
    let body: Value =
        serde_json::from_slice(&to_bytes(response.into_body(), usize::MAX).await.unwrap()).unwrap();
    assert_eq!(
        body,
        json!({"status": "ok", "server_version": "0.0.0-test"})
    );
}

#[tokio::test]
async fn websocket_answers_ping() {
    let listener = tokio::net::TcpListener::bind("127.0.0.1:0").await.unwrap();
    let address = listener.local_addr().unwrap();
    tokio::spawn(async move { axum::serve(listener, app()).await.unwrap() });

    let (mut socket, _) = tokio_tungstenite::connect_async(format!("ws://{address}/api/v1/ws"))
        .await
        .unwrap();
    socket
        .send(Message::text(
            r#"{"jsonrpc":"2.0","id":1,"method":"system.ping"}"#,
        ))
        .await
        .unwrap();

    let reply = socket.next().await.unwrap().unwrap();
    let reply: Value = serde_json::from_str(reply.to_text().unwrap()).unwrap();
    assert_eq!(reply["result"]["server_version"], "0.0.0-test");
}
