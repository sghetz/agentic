import 'dart:io';

import 'package:core/core.dart' as core;

typedef SystemCheckProcessRunner =
    Future<ProcessResult> Function(String executable, List<String> args);

Future<ProcessResult> _defaultSystemCheckProcessRunner(
  String executable,
  List<String> args,
) => Process.run(executable, args);

/// Checks that `git`, `flutter` (or `fvm`, which shells out to the pinned
/// Flutter version itself), and `claude` are present and runnable --
/// deterministic, no LLM involvement. Run on first launch (and whenever the
/// owner re-checks) so a missing external dependency surfaces as a clear
/// message instead of a confusing failure deep inside a Health check or an
/// agent's first real run.
class SystemCheckService {
  const SystemCheckService({
    SystemCheckProcessRunner runner = _defaultSystemCheckProcessRunner,
  }) : _runner = runner;

  final SystemCheckProcessRunner _runner;

  static const _tools = ['git', 'flutter', 'claude'];

  Future<List<core.DependencyCheck>> checkAll() async {
    final results = <core.DependencyCheck>[];
    for (final tool in _tools) {
      results.add(await _check(tool));
    }
    return results;
  }

  Future<core.DependencyCheck> _check(String tool) async {
    try {
      final result = await _runner(tool, ['--version']);
      if (result.exitCode != 0) {
        return core.DependencyCheck(
          name: tool,
          found: false,
          error: (result.stderr as String).trim(),
        );
      }
      final output = (result.stdout as String).trim();
      final firstLine = output.isEmpty ? null : output.split('\n').first;
      return core.DependencyCheck(name: tool, found: true, version: firstLine);
    } on ProcessException catch (e) {
      return core.DependencyCheck(name: tool, found: false, error: e.message);
    }
  }
}
