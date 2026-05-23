import 'package:flutter/material.dart';

import '../models/game_keyword.dart';

// Renders a string containing [Keyword] patterns as rich text.
// Known keywords become inline coloured chips with an icon.
// Unknown bracket-words are rendered in italic white.
class KeywordText extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const KeywordText(this.text, {this.style, super.key});

  static final _pattern = RegExp(r'\[([^\]]+)\]');

  List<InlineSpan> _buildSpans(TextStyle base) {
    final spans = <InlineSpan>[];
    int cursor = 0;

    for (final match in _pattern.allMatches(text)) {
      // Plain text before this match.
      if (match.start > cursor) {
        spans.add(TextSpan(
          text: text.substring(cursor, match.start),
          style: base,
        ));
      }

      final word = match.group(1)!;
      final kw = kKeywordMap[word];

      if (kw != null) {
        spans.add(WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: _KeywordChip(keyword: kw),
        ));
      } else {
        // Unknown keyword — render as styled text so nothing is lost.
        spans.add(TextSpan(
          text: '[$word]',
          style: base.copyWith(
            fontStyle: FontStyle.italic,
            color: (base.color ?? Colors.white).withValues(alpha: 0.65),
          ),
        ));
      }

      cursor = match.end;
    }

    // Remaining text after last match.
    if (cursor < text.length) {
      spans.add(TextSpan(text: text.substring(cursor), style: base));
    }

    return spans;
  }

  @override
  Widget build(BuildContext context) {
    final base = style ??
        DefaultTextStyle.of(context).style.copyWith(color: Colors.white70);
    return RichText(text: TextSpan(children: _buildSpans(base)));
  }
}

class _KeywordChip extends StatelessWidget {
  final GameKeyword keyword;

  const _KeywordChip({required this.keyword});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            keyword.imagePath,
            width: 20,
            height: 20,
            filterQuality: FilterQuality.medium,
          ),
          const SizedBox(width: 3),
          Text(
            keyword.keyword,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
