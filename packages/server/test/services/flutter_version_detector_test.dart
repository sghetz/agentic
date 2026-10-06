import 'dart:io';

import 'package:server/src/services/flutter_version_detector.dart';
import 'package:test/test.dart';

void main() {
  late Directory repo;
  const detector = FlutterVersionDetector();

  setUp(() async {
    repo = await Directory.systemTemp.createTemp('agentic_detector_test_');
  });

  tearDown(() async {
    await repo.delete(recursive: true);
  });

  test('reads the version from .fvmrc', () async {
    await File('${repo.path}/.fvmrc').writeAsString('{"flutter": "3.29.0"}');
    expect(await detector.detect(repo.path), '3.29.0');
  });

  test('falls back to .fvm/fvm_config.json when there is no .fvmrc', () async {
    final fvmDir = Directory('${repo.path}/.fvm')..createSync();
    await File(
      '${fvmDir.path}/fvm_config.json',
    ).writeAsString('{"flutterSdkVersion": "3.27.1"}');
    expect(await detector.detect(repo.path), '3.27.1');
  });

  test('.fvmrc wins over .fvm/fvm_config.json when both exist', () async {
    final fvmDir = Directory('${repo.path}/.fvm')..createSync();
    await File(
      '${fvmDir.path}/fvm_config.json',
    ).writeAsString('{"flutterSdkVersion": "3.27.1"}');
    await File('${repo.path}/.fvmrc').writeAsString('{"flutter": "3.29.0"}');
    expect(await detector.detect(repo.path), '3.29.0');
  });

  test('returns null when nothing is pinned', () async {
    expect(await detector.detect(repo.path), isNull);
  });

  test('returns null for malformed JSON rather than throwing', () async {
    await File('${repo.path}/.fvmrc').writeAsString('not json');
    expect(await detector.detect(repo.path), isNull);
  });
}
