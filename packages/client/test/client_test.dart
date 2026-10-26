import 'dart:convert';

import 'package:stream_channel/stream_channel.dart';
import 'package:teloche_client/teloche_client.dart';
import 'package:teloche_protocol/teloche_protocol.dart';
import 'package:test/test.dart';

/// A fake core on the other end of an in-memory channel.
TelocheClient clientAnswering(Map<String, Object?> Function(Map<String, Object?> request) answer) {
  final controller = StreamChannelController<dynamic>();
  controller.foreign.stream.listen((frame) {
    final request = jsonDecode(frame as String) as Map<String, Object?>;
    controller.foreign.sink.add(jsonEncode({'jsonrpc': '2.0', 'id': request['id'], ...answer(request)}));
  });
  return TelocheClient(controller.local);
}

void main() {
  test('ping returns the core versions', () async {
    final client = clientAnswering(
      (request) => {
        'result': {'server_version': '0.0.1', 'api_version': '1'},
      },
    );
    final ping = await client.ping();
    expect(ping.serverVersion, '0.0.1');
    expect(ping.apiVersion, '1');
  });

  test('a JSON-RPC error becomes an RpcException', () async {
    final client = clientAnswering(
      (request) => {
        'error': {'code': RpcError.methodNotFound, 'message': 'Method not found'},
      },
    );
    await expectLater(
      client.call('nope'),
      throwsA(isA<RpcException>().having((e) => e.error.code, 'code', RpcError.methodNotFound)),
    );
  });

  test('pending calls fail when the client is closed', () async {
    final controller = StreamChannelController<dynamic>();
    controller.foreign.stream.listen((_) {});
    final client = TelocheClient(controller.local);
    final expectation = expectLater(client.call(systemPing), throwsStateError);
    await client.close();
    await expectation;
  });
}
