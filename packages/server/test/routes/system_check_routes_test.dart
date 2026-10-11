import 'dart:io';

import 'package:server/src/server.dart';
import 'package:server/src/services/system_check_service.dart';
import 'package:test/test.dart';

import '../test_support/http_test_support.dart';

void main() {
  test('GET /system/check reports each dependency', () async {
    final ctx = buildTestContext(
      systemCheckService: SystemCheckService(
        runner: (executable, args) async =>
            ProcessResult(0, 0, '$executable 1.0.0', ''),
      ),
    );
    final handler = buildHandler(ctx);

    final (status, body) = await send(handler, 'GET', '/system/check');

    expect(status, 200);
    final list = body! as List;
    expect(list, hasLength(3));
    expect(list.map((e) => (e as Map)['name']), ['git', 'flutter', 'claude']);
    expect((list.first as Map)['found'], isTrue);
  });
}
