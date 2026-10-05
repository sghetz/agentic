import 'package:server/src/app_context.dart';
import 'package:server/src/config.dart';
import 'package:server/src/server.dart';

Future<void> main(List<String> arguments) async {
  final paths = AgenticPaths.standard();
  final ctx = AppContext.standard(paths);
  await serve(ctx);
}
