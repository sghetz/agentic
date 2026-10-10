import 'dart:io';

class KeychainException implements Exception {
  KeychainException(this.message);

  final String message;

  @override
  String toString() => 'KeychainException: $message';
}

typedef SecurityProcessRunner =
    Future<ProcessResult> Function(String executable, List<String> args);

Future<ProcessResult> _defaultSecurityProcessRunner(
  String executable,
  List<String> args,
) => Process.run(executable, args);

/// Thin wrapper over the macOS `security` CLI for storing connector
/// credentials (owner-supplied client id/secret, issued access/refresh
/// tokens) in the user's login Keychain -- never the database, per the
/// project's secrets rule. One Keychain item per (service, account) pair;
/// callers namespace `service` per (org, connector) and `account` per
/// credential name (e.g. `clientSecret`, `accessToken`).
class KeychainService {
  const KeychainService({
    SecurityProcessRunner runner = _defaultSecurityProcessRunner,
  }) : _runner = runner;

  final SecurityProcessRunner _runner;

  /// Creates or overwrites the item. `-U` updates an existing item in place
  /// instead of failing with "already exists".
  Future<void> setValue({
    required String service,
    required String account,
    required String value,
  }) async {
    final result = await _runner('security', [
      'add-generic-password',
      '-a',
      account,
      '-s',
      service,
      '-w',
      value,
      '-U',
    ]);
    if (result.exitCode != 0) {
      throw KeychainException(
        'security add-generic-password failed: ${result.stderr}',
      );
    }
  }

  /// `null` if no such item exists -- not an error, since "not connected
  /// yet" is an expected, common state.
  Future<String?> getValue({
    required String service,
    required String account,
  }) async {
    final result = await _runner('security', [
      'find-generic-password',
      '-a',
      account,
      '-s',
      service,
      '-w',
    ]);
    if (result.exitCode != 0) return null;
    return (result.stdout as String).trim();
  }

  /// A no-op if the item doesn't exist -- deleting something that's already
  /// gone isn't an error condition callers need to handle.
  Future<void> deleteValue({
    required String service,
    required String account,
  }) async {
    await _runner('security', [
      'delete-generic-password',
      '-a',
      account,
      '-s',
      service,
    ]);
  }
}
