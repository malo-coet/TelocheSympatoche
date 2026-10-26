//! JSON-RPC 2.0 envelope, as carried over the control WebSocket.

use schemars::JsonSchema;
use serde::{Deserialize, Serialize};
use serde_json::Value;

/// Value of the `jsonrpc` member of every message.
pub const VERSION: &str = "2.0";

/// Identifier chosen by the client to match a response to its request.
#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize, JsonSchema)]
#[serde(untagged)]
pub enum RequestId {
    Number(i64),
    String(String),
}

/// A call from a client. Without `id` it is a notification and gets no response.
#[derive(Debug, Clone, PartialEq, Serialize, Deserialize, JsonSchema)]
pub struct Request {
    pub jsonrpc: String,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub id: Option<RequestId>,
    pub method: String,
    #[serde(default, skip_serializing_if = "Value::is_null")]
    pub params: Value,
}

/// The answer to a request: either a result or an error.
#[derive(Debug, Clone, PartialEq, Serialize, Deserialize, JsonSchema)]
pub struct Response {
    pub jsonrpc: String,
    /// `None` only when the request id could not be read (parse error).
    pub id: Option<RequestId>,
    #[serde(flatten)]
    pub outcome: Outcome,
}

#[derive(Debug, Clone, PartialEq, Serialize, Deserialize, JsonSchema)]
#[serde(rename_all = "lowercase")]
pub enum Outcome {
    Result(Value),
    Error(ErrorObject),
}

impl Response {
    pub fn success(id: RequestId, result: Value) -> Self {
        Self {
            jsonrpc: VERSION.to_owned(),
            id: Some(id),
            outcome: Outcome::Result(result),
        }
    }

    pub fn error(id: Option<RequestId>, error: ErrorObject) -> Self {
        Self {
            jsonrpc: VERSION.to_owned(),
            id,
            outcome: Outcome::Error(error),
        }
    }
}

#[derive(Debug, Clone, PartialEq, Serialize, Deserialize, JsonSchema)]
pub struct ErrorObject {
    pub code: i32,
    pub message: String,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub data: Option<Value>,
}

impl ErrorObject {
    pub const PARSE_ERROR: i32 = -32700;
    pub const INVALID_REQUEST: i32 = -32600;
    pub const METHOD_NOT_FOUND: i32 = -32601;
    pub const INVALID_PARAMS: i32 = -32602;
    pub const INTERNAL_ERROR: i32 = -32603;

    pub fn new(code: i32, message: impl Into<String>) -> Self {
        Self {
            code,
            message: message.into(),
            data: None,
        }
    }

    pub fn parse_error() -> Self {
        Self::new(Self::PARSE_ERROR, "Parse error")
    }

    pub fn invalid_request(reason: impl Into<String>) -> Self {
        Self::new(Self::INVALID_REQUEST, reason)
    }

    pub fn method_not_found(method: &str) -> Self {
        Self::new(
            Self::METHOD_NOT_FOUND,
            format!("Method not found: {method}"),
        )
    }

    pub fn internal_error() -> Self {
        Self::new(Self::INTERNAL_ERROR, "Internal error")
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use serde_json::json;

    #[test]
    fn success_serializes_with_result_member() {
        let response = Response::success(RequestId::Number(7), json!({"ok": true}));
        assert_eq!(
            serde_json::to_value(&response).unwrap(),
            json!({"jsonrpc": "2.0", "id": 7, "result": {"ok": true}})
        );
    }

    #[test]
    fn error_serializes_with_error_member_and_null_id() {
        let response = Response::error(None, ErrorObject::parse_error());
        assert_eq!(
            serde_json::to_value(&response).unwrap(),
            json!({"jsonrpc": "2.0", "id": null, "error": {"code": -32700, "message": "Parse error"}})
        );
    }

    #[test]
    fn request_without_id_is_a_notification() {
        let request: Request =
            serde_json::from_value(json!({"jsonrpc": "2.0", "method": "input.key"})).unwrap();
        assert_eq!(request.id, None);
        assert!(request.params.is_null());
    }
}
