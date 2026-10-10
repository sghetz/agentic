import 'dart:io';

import 'package:server/src/services/keychain_service.dart';
import 'package:test/test.dart';

typedef _Call = ({String executable, List<String> args});

void main() {
  late List<_Call> calls;
  late Map<String, String> store;

  KeychainService buildService() {
    calls = [];
    store = {};
    return KeychainService(
      runner: (executable, args) async {
        calls.add((executable: executable, args: args));
        final account = args[args.indexOf('-a') + 1];
        final service = args[args.indexOf('-s') + 1];
        final key = '$service|$account';
        switch (args.first) {
          case 'add-generic-password':
            store[key] = args[args.indexOf('-w') + 1];
            return ProcessResult(0, 0, '', '');
          case 'find-generic-password':
            final value = store[key];
            return value == null
                ? ProcessResult(0, 44, '', 'not found')
                : ProcessResult(0, 0, value, '');
          case 'delete-generic-password':
            store.remove(key);
            return ProcessResult(0, 0, '', '');
          default:
            return ProcessResult(0, 1, '', 'unknown');
        }
      },
    );
  }

  test('setValue then getValue round trips through the security CLI', () async {
    final service = buildService();

    await service.setValue(
      service: 'agentic.org-1.connector.outlook',
      account: 'clientSecret',
      value: 'super-secret',
    );
    final value = await service.getValue(
      service: 'agentic.org-1.connector.outlook',
      account: 'clientSecret',
    );

    expect(value, 'super-secret');
    expect(calls[0].executable, 'security');
    expect(calls[0].args, [
      'add-generic-password',
      '-a',
      'clientSecret',
      '-s',
      'agentic.org-1.connector.outlook',
      '-w',
      'super-secret',
      '-U',
    ]);
    expect(calls[1].args, [
      'find-generic-password',
      '-a',
      'clientSecret',
      '-s',
      'agentic.org-1.connector.outlook',
      '-w',
    ]);
  });

  test('getValue returns null for an item that was never set', () async {
    final service = buildService();

    final value = await service.getValue(
      service: 'agentic.org-1.connector.outlook',
      account: 'clientSecret',
    );

    expect(value, isNull);
  });

  test('setValue twice overwrites (uses -U, not a fresh add)', () async {
    final service = buildService();

    await service.setValue(service: 's', account: 'a', value: 'first');
    await service.setValue(service: 's', account: 'a', value: 'second');
    final value = await service.getValue(service: 's', account: 'a');

    expect(value, 'second');
  });

  test('deleteValue removes the item', () async {
    final service = buildService();
    await service.setValue(service: 's', account: 'a', value: 'x');

    await service.deleteValue(service: 's', account: 'a');

    expect(await service.getValue(service: 's', account: 'a'), isNull);
  });

  test('deleteValue on a nonexistent item is not an error', () async {
    final service = buildService();

    await service.deleteValue(service: 's', account: 'a');
  });

  test('setValue throws KeychainException when the CLI fails', () async {
    final service = KeychainService(
      runner: (executable, args) async => ProcessResult(0, 1, '', 'denied'),
    );

    expect(
      () => service.setValue(service: 's', account: 'a', value: 'x'),
      throwsA(isA<KeychainException>()),
    );
  });
}
