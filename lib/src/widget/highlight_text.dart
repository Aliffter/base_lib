import 'package:flutter/material.dart';

enum HighlightMatchMode { first, all }

class HighlightText extends StatelessWidget {
  const HighlightText({
    super.key,
    required this.text,
    required this.keyword,
    this.style,
    this.highlightStyle,
    this.matchMode = HighlightMatchMode.all,
    this.maxLines,
    this.overflow,
    this.textAlign,
  });

  final String text;
  final String keyword;
  final TextStyle? style;
  final TextStyle? highlightStyle;
  final HighlightMatchMode matchMode;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    final normalizedKeyword = keyword.trim();
    final textOverflow = overflow ??
        (maxLines == null ? TextOverflow.visible : TextOverflow.ellipsis);

    if (normalizedKeyword.isEmpty || text.isEmpty) {
      return Text(
        text,
        style: style,
        maxLines: maxLines,
        overflow: textOverflow,
        textAlign: textAlign,
      );
    }

    final baseStyle = style ?? DefaultTextStyle.of(context).style;
    final activeHighlightStyle =
        highlightStyle ??
        baseStyle.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.w600,
        );

    final lowerText = text.toLowerCase();
    final lowerKeyword = normalizedKeyword.toLowerCase();
    final spans = <TextSpan>[];
    var start = 0;

    while (start < text.length) {
      final matchIndex = lowerText.indexOf(lowerKeyword, start);
      if (matchIndex == -1) {
        spans.add(TextSpan(text: text.substring(start), style: baseStyle));
        break;
      }

      if (matchIndex > start) {
        spans.add(
          TextSpan(
            text: text.substring(start, matchIndex),
            style: baseStyle,
          ),
        );
      }

      spans.add(
        TextSpan(
          text: text.substring(
            matchIndex,
            matchIndex + normalizedKeyword.length,
          ),
          style: activeHighlightStyle,
        ),
      );

      start = matchIndex + normalizedKeyword.length;
      if (matchMode == HighlightMatchMode.first) {
        if (start < text.length) {
          spans.add(TextSpan(text: text.substring(start), style: baseStyle));
        }
        break;
      }
    }

    return RichText(
      maxLines: maxLines,
      overflow: textOverflow,
      textAlign: textAlign ?? TextAlign.start,
      text: TextSpan(style: baseStyle, children: spans),
    );
  }
}
