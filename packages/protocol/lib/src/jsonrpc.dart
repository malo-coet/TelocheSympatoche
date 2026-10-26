/// Value of the `jsonrpc` member of every message.
const jsonRpcVersion = '2.0';

/// A call to the core. Without [id] it is a notification and gets no response.
final class RpcRequest {
  const RpcRequest({required this.method, this.id, this.params});

  /// An `int` or a `String`, chosen by the caller to match the response.
  final Object? id;
  final String method;
  final Map<String, Object?>? params;

  Map<String, Object?> toJson() => {
    'jsonrpc': jsonRpcVersion,
    if (id != null) 'id': id,
    'method': method,
    if (params != null) 'params': params,
  };
}

/// The answer to an [RpcRequest]: either an [RpcSuccess] or an [RpcFailure].
sealed class RpcResponse {
  const RpcResponse(this.id);

  factory RpcResponse.fromJson(Map<String, Object?> json) {
    final id = json['id'];
    final error = json['error'];
    if (error is Map<String, Object?>) {
      return RpcFailure(id, RpcError.fromJson(error));
    }
    if (!json.containsKey('result')) {
      throw const FormatException('JSON-RPC response without result or error');
    }
    return RpcSuccess(id, json['result']);
  }

  /// `null` only when the core could not read the request id.
  final Object? id;
}

final class RpcSuccess extends RpcResponse {
  const RpcSuccess(super.id, this.result);

  final Object? result;
}

final class RpcFailure extends RpcResponse {
  const RpcFailure(super.id, this.error);

  final RpcError error;
}

final class RpcError {
  const RpcError({required this.code, required this.message, this.data});

  factory RpcError.fromJson(Map<String, Object?> json) =>
      RpcError(code: json['code']! as int, message: json['message']! as String, data: json['data']);

  static const parseError = -32700;
  static const invalidRequest = -32600;
  static const methodNotFound = -32601;
  static const invalidParams = -32602;
  static const internalError = -32603;

  final int code;
  final String message;
  final Object? data;

  @override
  String toString() => 'RpcError($code): $message';
}
