import 'dart:io';

import 'package:server/src/services/git_service.dart';
import 'package:test/test.dart';

Future<void> _git(List<String> args, {String? cwd}) async {
  final result = await Process.run('git', args, workingDirectory: cwd);
  if (result.exitCode != 0) {
    fail('git ${args.join(' ')} failed: ${result.stderr}');
  }
}

void main() {
  late Directory tmp;
  late String remotePath;
  late String seedPath;
  const service = GitService();

  setUp(() async {
    tmp = await Directory.systemTemp.createTemp('agentic_git_test_');
    remotePath = '${tmp.path}/remote.git';
    await _git(['init', '--bare', remotePath]);

    seedPath = '${tmp.path}/seed';
    await _git(['clone', remotePath, seedPath]);
    await File('$seedPath/README.md').writeAsString('hello');
    await _git(['add', '.'], cwd: seedPath);
    await _git([
      '-c',
      'user.email=test@example.com',
      '-c',
      'user.name=Test',
      'commit',
      '-m',
      'initial',
    ], cwd: seedPath);
    await _git(['push', 'origin', 'HEAD:main'], cwd: seedPath);
  });

  tearDown(() async {
    await tmp.delete(recursive: true);
  });

  test('clones when the target does not exist yet', () async {
    final targetPath = '${tmp.path}/clone-target';
    final result = await service.cloneOrPull(
      repoUrl: remotePath,
      targetPath: targetPath,
      branch: 'main',
    );

    expect(result.pulled, isFalse);
    expect(await File('$targetPath/README.md').exists(), isTrue);
  });

  test('pulls when the target already has a clone', () async {
    final targetPath = '${tmp.path}/pull-target';
    await service.cloneOrPull(
      repoUrl: remotePath,
      targetPath: targetPath,
      branch: 'main',
    );

    await File('$seedPath/second.txt').writeAsString('more');
    await _git(['add', '.'], cwd: seedPath);
    await _git([
      '-c',
      'user.email=test@example.com',
      '-c',
      'user.name=Test',
      'commit',
      '-m',
      'second',
    ], cwd: seedPath);
    await _git(['push', 'origin', 'HEAD:main'], cwd: seedPath);

    final result = await service.cloneOrPull(
      repoUrl: remotePath,
      targetPath: targetPath,
      branch: 'main',
    );

    expect(result.pulled, isTrue);
    expect(await File('$targetPath/second.txt').exists(), isTrue);
  });

  test('throws GitOperationException for an invalid repo url', () async {
    expect(
      () => service.cloneOrPull(
        repoUrl: '${tmp.path}/does-not-exist',
        targetPath: '${tmp.path}/bad-target',
      ),
      throwsA(isA<GitOperationException>()),
    );
  });
}
