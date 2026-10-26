import 'package:teloche_protocol/teloche_protocol.dart';
import 'package:test/test.dart';

void main() {
  group('RpcRequest', () {
    test('encodes a call with its id and params', () {
      const request = RpcRequest(id: 7, method: 'player.seek', params: {'position_ms': 1000});
      expect(request.toJson(), {
        'jsonrpc': '2.0',
        'id': 7,
        'method': 'player.seek',
        'params': {'position_ms': 1000},
      });
    });

    test('omits the id of a notification', () {
      expect(const RpcRequest(method: 'input.key').toJson(), {'jsonrpc': '2.0', 'method': 'input.key'});
    });
  });

  group('RpcResponse', () {
    test('decodes a success', () {
      final response = RpcResponse.fromJson({
        'jsonrpc': '2.0',
        'id': 1,
        'result': {'server_version': '0.0.1', 'api_version': '1'},
      });
      final result = (response as RpcSuccess).result! as Map<String, Object?>;
      expect(PingResult.fromJson(result).apiVersion, '1');
    });

    test('decodes a failure', () {
      final response = RpcResponse.fromJson({
        'jsonrpc': '2.0',
        'id': 'a',
        'error': {'code': -32601, 'message': 'Method not found: nope'},
      });
      expect((response as RpcFailure).error.code, RpcError.methodNotFound);
      expect(response.id, 'a');
    });

    test('rejects a response without result or error', () {
      expect(() => RpcResponse.fromJson({'jsonrpc': '2.0', 'id': 1}), throwsFormatException);
    });
  });
}
