import 'dart:async';
import 'dart:convert';

import 'package:stream_channel/stream_channel.dart';
import 'package:teloche_protocol/teloche_protocol.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// Thrown when the core answers a call with a JSON-RPC error.
final class RpcException implements Exception {
  const RpcException(this.error);

  final RpcError error;

  @override
  String toString() => 'RpcException: $error';
}

/// Connection to the control API. Calls are matched to responses by id, so
/// several can be in flight at once.
final class TelocheClient {
  TelocheClient(this._channel) {
    _subscription = _channel.stream.listen(_onFrame, onDone: _onDone, onError: _onError);
  }

  /// Opens a connection to `ws://<host>:<port>/api/v1/ws`.
  static Future<TelocheClient> connect(Uri uri) async {
    final channel = WebSocketChannel.connect(uri);
    await channel.ready;
    return TelocheClient(channel);
  }

  final StreamChannel<dynamic> _channel;
  late final StreamSubscription<dynamic> _subscription;
  final _pending = <int, Completer<Object?>>{};
  var _nextId = 1;

  Future<PingResult> ping() async {
    final result = await call(systemPing);
    return PingResult.fromJson(result! as Map<String, Object?>);
  }

  /// Sends [method] and completes with its result, or fails with an [RpcException].
  Future<Object?> call(String method, [Map<String, Object?>? params]) {
    final id = _nextId++;
    final completer = Completer<Object?>();
    _pending[id] = completer;
    _channel.sink.add(jsonEncode(RpcRequest(id: id, method: method, params: params).toJson()));
    return completer.future;
  }

  Future<void> close() async {
    _failPending(StateError('Client closed'));
    await _subscription.cancel();
    await _channel.sink.close();
  }

  void _onFrame(dynamic frame) {
    final response = RpcResponse.fromJson(jsonDecode(frame as String) as Map<String, Object?>);
    final completer = _pending.remove(response.id);
    if (completer == null) return;
    switch (response) {
      case RpcSuccess(:final result):
        completer.complete(result);
      case RpcFailure(:final error):
        completer.completeError(RpcException(error));
    }
  }

  void _onDone() => _failPending(StateError('Connection closed by the core'));

  void _onError(Object error) => _failPending(error);

  void _failPending(Object error) {
    for (final completer in _pending.values) {
      completer.completeError(error);
    }
    _pending.clear();
  }
}
