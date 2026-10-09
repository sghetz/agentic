import 'package:app/src/ui/common/mermaid_view.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('escapeMermaidSource', () {
    test('escapes angle brackets and ampersands', () {
      expect(
        escapeMermaidSource('A["x < y & z > w"]'),
        'A["x &lt; y &amp; z &gt; w"]',
      );
    });

    test('escapes the arrow syntax mermaid flowcharts use for edges', () {
      // '>' is escaped too, not just '<' -- correct per the HTML spec even
      // though most browsers tolerate a raw '>' in text content.
      expect(
        escapeMermaidSource('flowchart TD\n  A --> B'),
        'flowchart TD\n  A --&gt; B',
      );
    });

    test('leaves text with no special characters untouched', () {
      const source = 'flowchart TD\n  A --- B';
      expect(escapeMermaidSource(source), source);
    });
  });

  group('composeMermaidHtml', () {
    test('inlines the mermaid.js verbatim in a script tag', () {
      final html = composeMermaidHtml(
        mermaidJs: 'console.log("hi");',
        source: 'flowchart TD\n  A --> B',
        theme: 'default',
      );

      expect(html, contains('<script>console.log("hi");</script>'));
    });

    test('puts the (escaped) diagram source inside a pre.mermaid element', () {
      final html = composeMermaidHtml(
        mermaidJs: '',
        source: 'A["x < y"]',
        theme: 'default',
      );

      expect(html, contains('<pre class="mermaid">A["x &lt; y"]</pre>'));
    });

    test('passes the given theme to mermaid.initialize', () {
      final html = composeMermaidHtml(
        mermaidJs: '',
        source: 'flowchart TD',
        theme: 'dark',
      );

      expect(html, contains("theme: 'dark'"));
    });

    test('sets startOnLoad so mermaid renders without extra JS calls', () {
      final html = composeMermaidHtml(
        mermaidJs: '',
        source: 'flowchart TD',
        theme: 'default',
      );

      expect(html, contains('startOnLoad: true'));
    });

    test('uses an explicit background color, never "transparent"', () {
      // Regression guard: WebViewController.setBackgroundColor(transparent)
      // throws "UnimplementedError: opaque is not implemented on macOS"
      // (confirmed live) -- the page must supply its own opaque background
      // instead of relying on platform-view transparency.
      for (final theme in ['default', 'dark']) {
        final html = composeMermaidHtml(
          mermaidJs: '',
          source: 'flowchart TD',
          theme: theme,
        );
        expect(html, isNot(contains('transparent')), reason: 'theme: $theme');
      }
    });

    test('dark theme gets a dark background, default gets a light one', () {
      final darkHtml = composeMermaidHtml(
        mermaidJs: '',
        source: 'flowchart TD',
        theme: 'dark',
      );
      final defaultHtml = composeMermaidHtml(
        mermaidJs: '',
        source: 'flowchart TD',
        theme: 'default',
      );

      expect(darkHtml, contains('#1e1e1e'));
      expect(defaultHtml, contains('#ffffff'));
    });
  });
}
