import 'dart:io';

import 'package:server/src/services/system_check_service.dart';
import 'package:test/test.dart';

void main() {
  test('reports git/flutter/claude as found with their version line', () async {
    final service = SystemCheckService(
      runner: (executable, args) async {
        return ProcessResult(0, 0, 'fake $executable version 1.2.3\nextra', '');
      },
    );

    final results = await service.checkAll();

    expect(results.map((r) => r.name), ['git', 'flutter', 'claude']);
    for (final result in results) {
      expect(result.found, isTrue);
      expect(result.version, contains('fake ${result.name} version 1.2.3'));
      expect(result.error, isNull);
    }
  });

  test('reports a tool as not found when the process exits nonzero', () async {
    final service = SystemCheckService(
      runner: (executable, args) async {
        if (executable == 'claude') {
          return ProcessResult(0, 127, '', 'command not found');
        }
        return ProcessResult(0, 0, 'ok', '');
      },
    );

    final results = await service.checkAll();
    final claude = results.firstWhere((r) => r.name == 'claude');

    expect(claude.found, isFalse);
    expect(claude.error, 'command not found');
    expect(claude.version, isNull);
  });

  test(
    'reports a tool as not found when the executable does not exist at all',
    () async {
      final service = SystemCheckService(
        runner: (executable, args) async {
          if (executable == 'flutter') {
            throw const ProcessException('flutter', [
              '--version',
            ], 'No such file');
          }
          return ProcessResult(0, 0, 'ok', '');
        },
      );

      final results = await service.checkAll();
      final flutter = results.firstWhere((r) => r.name == 'flutter');

      expect(flutter.found, isFalse);
      expect(flutter.error, contains('No such file'));
    },
  );
}
