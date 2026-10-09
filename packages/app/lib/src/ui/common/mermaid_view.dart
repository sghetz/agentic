import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Renders arbitrary Mermaid diagram source via a vendored `mermaid.js`
/// (see `assets/mermaid/`) in an embedded WebView -- not a native Dart
/// renderer. The two available native packages (`flutter_mermaid`,
/// `duskmoon_mermaid_renderer`) are both early-stage with narrow flowchart
/// support; a real `mermaid.js` gives full fidelity for whatever valid
/// Mermaid syntax an agent generates (see `docs/PHASE_4_SPEC.md`).
///
/// The whole page -- vendored JS and diagram source both -- is composed
/// into one self-contained HTML string and loaded via [loadHtmlString]
/// rather than [loadFlutterAsset] referencing a sibling JS file: relative
/// asset paths inside a loaded HTML page are unreliable across
/// `webview_flutter`'s platform implementations, so inlining avoids that
/// entirely. Mermaid's own built-in error rendering shows invalid syntax
/// inline (a red error box in the diagram area) rather than a blank page.
///
/// The page uses an explicit light/dark background color, not a
/// transparent one: `WebViewController.setBackgroundColor(transparent)`
/// throws `UnimplementedError: opaque is not implemented on macOS`
/// (confirmed live) -- macOS's platform-view embedding doesn't support the
/// hit-test-opaque semantics a translucent platform view needs.
class MermaidView extends StatefulWidget {
  const MermaidView({super.key, required this.source});

  final String source;

  @override
  State<MermaidView> createState() => _MermaidViewState();
}

class _MermaidViewState extends State<MermaidView> {
  late final WebViewController _controller;
  String? _mermaidJs;

  @override
  void initState() {
    super.initState();
    // setBackgroundColor(transparent) is deliberately not used here: it
    // triggers "UnimplementedError: opaque is not implemented on macOS"
    // (confirmed live) -- macOS's platform-view embedding doesn't support
    // the hit-test-opaque semantics a translucent platform view needs.
    // The HTML's own white/dark background (set in composeMermaidHtml)
    // handles theming instead.
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted);
    _load();
  }

  @override
  void didUpdateWidget(MermaidView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.source != widget.source) _load();
  }

  Future<void> _load() async {
    final mermaidJs = _mermaidJs ??= await rootBundle.loadString(
      'assets/mermaid/mermaid.min.js',
    );
    if (!mounted) return;
    final isDark =
        WidgetsBinding.instance.platformDispatcher.platformBrightness ==
        Brightness.dark;
    await _controller.loadHtmlString(
      composeMermaidHtml(
        mermaidJs: mermaidJs,
        source: widget.source,
        theme: isDark ? 'dark' : 'default',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: _controller);
  }
}

@visibleForTesting
String composeMermaidHtml({
  required String mermaidJs,
  required String source,
  required String theme,
}) {
  final backgroundColor = theme == 'dark' ? '#1e1e1e' : '#ffffff';
  return '''
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<style>
  html, body { margin: 0; padding: 8px; background: $backgroundColor; }
  .mermaid { display: flex; justify-content: center; }
</style>
</head>
<body>
<pre class="mermaid">${escapeMermaidSource(source)}</pre>
<script>$mermaidJs</script>
<script>
  mermaid.initialize({ startOnLoad: true, theme: '$theme' });
</script>
</body>
</html>
''';
}

@visibleForTesting
String escapeMermaidSource(String text) => text
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;');
