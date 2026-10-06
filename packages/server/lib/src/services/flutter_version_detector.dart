import 'dart:convert';
import 'dart:io';

/// Deterministic Flutter-version detection for a freshly cloned repo.
/// Only trusts an explicit FVM pin -- never guesses from the Dart SDK
/// constraint in pubspec.yaml, since that doesn't determine a Flutter
/// version on its own.
class FlutterVersionDetector {
  const FlutterVersionDetector();

  Future<String?> detect(String repoPath) async {
    final fvmrc = File('$repoPath/.fvmrc');
    if (await fvmrc.exists()) {
      final version = _readFlutterKey(await fvmrc.readAsString());
      if (version != null) return version;
    }

    final fvmConfig = File('$repoPath/.fvm/fvm_config.json');
    if (await fvmConfig.exists()) {
      final version = _readFlutterSdkVersionKey(await fvmConfig.readAsString());
      if (version != null) return version;
    }

    return null;
  }

  String? _readFlutterKey(String contents) {
    try {
      final json = jsonDecode(contents) as Map<String, Object?>;
      return json['flutter'] as String?;
    } on FormatException {
      return null;
    }
  }

  String? _readFlutterSdkVersionKey(String contents) {
    try {
      final json = jsonDecode(contents) as Map<String, Object?>;
      return json['flutterSdkVersion'] as String?;
    } on FormatException {
      return null;
    }
  }
}
