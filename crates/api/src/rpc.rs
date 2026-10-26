//! JSON-RPC dispatch: decodes a text frame, routes it to its method, encodes the reply.

use serde::Serialize;
use teloche_protocol::API_VERSION;
use teloche_protocol::jsonrpc::{self, ErrorObject, Request, RequestId, Response};
use teloche_protocol::system::{self, PingResult};

use crate::AppState;

/// Handles one text frame. Returns the encoded response, or `None` for a notification.
pub(crate) fn handle_text(text: &str, state: &AppState) -> Option<String> {
    let response = match serde_json::from_str::<Request>(text) {
        Ok(request) => dispatch(request, state)?,
        Err(_) => Response::error(None, ErrorObject::parse_error()),
    };
    match serde_json::to_string(&response) {
        Ok(encoded) => Some(encoded),
        Err(error) => {
            tracing::error!(%error, "cannot encode JSON-RPC response");
            None
        }
    }
}

fn dispatch(request: Request, state: &AppState) -> Option<Response> {
    if request.jsonrpc != jsonrpc::VERSION {
        return Some(Response::error(
            request.id,
            ErrorObject::invalid_request("jsonrpc must be \"2.0\""),
        ));
    }
    let id = request.id?;
    Some(match request.method.as_str() {
        system::PING => success(
            id,
            PingResult {
                server_version: state.server_version.clone(),
                api_version: API_VERSION.to_owned(),
            },
        ),
        method => Response::error(Some(id), ErrorObject::method_not_found(method)),
    })
}

fn success(id: RequestId, result: impl Serialize) -> Response {
    match serde_json::to_value(result) {
        Ok(value) => Response::success(id, value),
        Err(_) => Response::error(Some(id), ErrorObject::internal_error()),
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use serde_json::{Value, json};

    fn state() -> AppState {
        AppState {
            server_version: "1.2.3".to_owned(),
        }
    }

    fn call(frame: &str) -> Option<Value> {
        handle_text(frame, &state()).map(|reply| serde_json::from_str(&reply).unwrap())
    }

    #[test]
    fn ping_returns_versions() {
        let reply = call(r#"{"jsonrpc":"2.0","id":1,"method":"system.ping"}"#).unwrap();
        assert_eq!(
            reply,
            json!({"jsonrpc": "2.0", "id": 1, "result": {"server_version": "1.2.3", "api_version": "1"}})
        );
    }

    #[test]
    fn unknown_method_is_reported() {
        let reply = call(r#"{"jsonrpc":"2.0","id":"a","method":"nope"}"#).unwrap();
        assert_eq!(reply["error"]["code"], ErrorObject::METHOD_NOT_FOUND);
        assert_eq!(reply["id"], "a");
    }

    #[test]
    fn invalid_json_is_a_parse_error() {
        let reply = call("{not json").unwrap();
        assert_eq!(reply["error"]["code"], ErrorObject::PARSE_ERROR);
        assert_eq!(reply["id"], Value::Null);
    }

    #[test]
    fn wrong_version_is_an_invalid_request() {
        let reply = call(r#"{"jsonrpc":"1.0","id":2,"method":"system.ping"}"#).unwrap();
        assert_eq!(reply["error"]["code"], ErrorObject::INVALID_REQUEST);
    }

    #[test]
    fn notifications_get_no_reply() {
        assert_eq!(call(r#"{"jsonrpc":"2.0","method":"system.ping"}"#), None);
    }
}
