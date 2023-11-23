import 'package:flutter/material.dart' show TextPainter, TextSpan;

extension TextPainterCopyWithExtension on TextPainter {
  TextPainter copyWith({
    TextSpan? newTextSpan,
    int? lines,
    required double maxWidth,
  }) {
    final copiedPainter = TextPainter(
      text: newTextSpan ?? text,
      textDirection: textDirection,
      maxLines: lines ?? maxLines,
      ellipsis: ellipsis,
      textAlign: textAlign,
    );
    copiedPainter.layout(maxWidth: maxWidth);

    return copiedPainter;
  }
}
