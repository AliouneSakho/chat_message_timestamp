library chat_message_timestamp;

import 'dart:math';
import 'package:chat_message_timestamp/extensions/textpainter_copywith_extension.dart';
import 'package:chat_message_timestamp/extensions/textspan_copywith_extension.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class TimestampedChatMessage extends LeafRenderObjectWidget {
  const TimestampedChatMessage({
    super.key,
    required this.text,
    required this.sentAt,
    this.sendingStatusIcon,
    this.style,
    this.sentAtStyle,
    this.showMoreTextStyle,
    this.maxLines,
    this.delimiter = '\u2026',
    this.viewMoreText = 'showMore',
  });
  final String text;
  final String sentAt;
  final String delimiter;
  final Icon? sendingStatusIcon;
  final TextStyle? style;
  final TextStyle? showMoreTextStyle;
  final TextStyle? sentAtStyle;
  final int? maxLines;
  final String viewMoreText;

  @override
  RenderObject createRenderObject(BuildContext context) {
    final DefaultTextStyle defaultTextStyle = DefaultTextStyle.of(context);
    TextStyle? effectiveTextStyle = style;
    late TextStyle iconTextStyle;
    TextStyle? showTextStyle = showMoreTextStyle;

    if (style == null || style!.inherit) {
      effectiveTextStyle = defaultTextStyle.style.merge(style);

      showTextStyle = defaultTextStyle.style
          .copyWith(
            color: Colors.blue.shade700,
            fontWeight: FontWeight.w500,
          )
          .merge(showMoreTextStyle);

      if (sendingStatusIcon != null) {
        iconTextStyle = defaultTextStyle.style.merge(
          TextStyle(
            color: sendingStatusIcon!.color ??
                effectiveTextStyle.color!.withAlpha(180),
            shadows: sendingStatusIcon!.shadows,
            fontSize: sendingStatusIcon!.size ?? 17,
            fontFamily: sendingStatusIcon!.icon!.fontFamily,
            package: sendingStatusIcon!.icon!.fontPackage,
          ),
        );
      }
    }

    return TimestampedChatMessageRenderObject(
      text: text,
      sentAt: sentAt,
      delimiter: delimiter,
      textDirection: Directionality.of(context),
      textStyle: effectiveTextStyle!,
      sentAtStyle: effectiveTextStyle
          .copyWith(
            color: style!.color!.withAlpha(180),
            fontSize: 13,
          )
          .merge(sentAtStyle),
      maxLines: maxLines,
      showMoreText: viewMoreText,
      showsTextStyle: showTextStyle!,
      sendingStatusIcon: sendingStatusIcon != null
          ? String.fromCharCode(sendingStatusIcon!.icon!.codePoint)
          : null,
      sendingStatusIconStyle: sendingStatusIcon != null ? iconTextStyle : null,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    TimestampedChatMessageRenderObject renderObject,
  ) {
    final DefaultTextStyle defaultTextStyle = DefaultTextStyle.of(context);
    TextStyle? effectiveTextStyle = style;
    TextStyle? showTextStyle = showMoreTextStyle;
    if (style == null || style!.inherit) {
      effectiveTextStyle = defaultTextStyle.style.merge(style);
      showTextStyle = defaultTextStyle.style
          .copyWith(
            color: Colors.blue.shade700,
            fontWeight: FontWeight.w500,
          )
          .merge(showMoreTextStyle);
    }
    renderObject.text = text;
    renderObject.textStyle = effectiveTextStyle!;

    renderObject.showMore = viewMoreText;
    renderObject.showsTextStyle = showTextStyle!;
    renderObject.delimter = delimiter;

    renderObject.sentAtStyle = effectiveTextStyle
        .copyWith(
          color: style!.color!.withAlpha(180),
          fontSize: 13,
        )
        .merge(sentAtStyle);

    if (sendingStatusIcon != null) {
      renderObject.sendingIcon =
          String.fromCharCode(sendingStatusIcon!.icon!.codePoint);
      renderObject.sendingIconStyle = defaultTextStyle.style.copyWith(
        color: sendingStatusIcon!.color != null
            ? sendingStatusIcon!.color!
            : effectiveTextStyle.color!.withAlpha(180),
        shadows: sendingStatusIcon!.shadows,
        fontSize: sendingStatusIcon!.size ?? 17,
        fontFamily: sendingStatusIcon!.icon!.fontFamily,
        package: sendingStatusIcon!.icon!.fontPackage,
      );
    }
    renderObject.maxLines = maxLines;

    renderObject.textDirection = Directionality.of(context);
  }
}

class CustomColumnParentData extends ContainerBoxParentData<RenderBox> {
  int? flex;
}

/// Simplified variant of [RenderParagraph] which supports the
/// [TimestampedChatMessage] widget.
///
/// Like the [Text] widget and its inner [RenderParagraph], the
/// [TimestampedChatMessageRenderObject] makes heavy use of the [TextPainter]
/// class.
class TimestampedChatMessageRenderObject extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, CustomColumnParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, CustomColumnParentData> {
  TimestampedChatMessageRenderObject({
    required String sentAt,
    required String text,
    required TextStyle sentAtStyle,
    required TextStyle textStyle,
    required TextDirection textDirection,
    String? sendingStatusIcon,
    TextStyle? sendingStatusIconStyle,
    required String showMoreText,
    required TextStyle showsTextStyle,
    required int? maxLines,
    required String delimiter,
  }) {
    _text = text;
    _sentAt = sentAt;
    _delimiter = delimiter;
    _showMore = showMoreText;
    _sendingIconShareCode = sendingStatusIcon;
    _textStyle = textStyle;
    _sentAtStyle = sentAtStyle;
    _showsTextStyle = showsTextStyle;
    _sendingIconStyle = sendingStatusIconStyle;
    _textDirection = textDirection;
    _maxLines = maxLines;
    lines = maxLines;

    _textPainter = TextPainter(
      text: textTextSpan,
      maxLines: _maxLines,
      textDirection: _textDirection,
    );
    _sentAtTextPainter = TextPainter(
      text: sentAtTextSpan,
      textDirection: _textDirection,
    );
    _showsTextPainter = TextPainter(
      text: showsTextSpan,
      textDirection: _textDirection,
    );

    _sendingIconTextPainter = _sendingIconShareCode != null
        ? TextPainter(
            text: sendingIconTextSpan,
            textDirection: _textDirection,
          )
        : null;
    _delimiterTextPainter = TextPainter(
      text: delimiterSpan,
      textDirection: _textDirection,
    );
    _tap = TapGestureRecognizer(debugOwner: this)..onTap = onTap;
  }

  late final TapGestureRecognizer _tap;
  late String? _sendingIconShareCode;
  late TextDirection _textDirection;
  late String _text;
  late String _sentAt;
  late String _delimiter;
  late String _showMore;
  late TextPainter _textPainter;
  late TextPainter _sentAtTextPainter;
  late TextPainter _delimiterTextPainter;
  late TextPainter _showsTextPainter;
  late TextPainter _mainTextPainter;
  late TextPainter? _sendingIconTextPainter;
  late TextStyle _sentAtStyle;
  late TextStyle _textStyle;
  late TextStyle? _showsTextStyle;
  late TextStyle? _sendingIconStyle;
  late bool _sentAtAndIconFitOnLastLine;
  late bool _shouldPaintShows;
  late double _lineHeight;
  late double _lastMessageLineWidth;
  late double _showsLineWidth;
  late double _delimiterLineWidth;
  double _longestLineWidth = 0;
  late int? lines;
  late double _iconLineWidth = 0;
  late double _sentAtLineWidth;
  late int _numMessageLines;
  late int? _maxLines;
  late Offset showsOffset;

  TextSpan get textTextSpan => TextSpan(
        text: _text,
        style: _textStyle,
      );
  TextSpan get sentAtTextSpan => TextSpan(
        text: _sentAt,
        style: _sentAtStyle,
      );
  TextSpan get showsTextSpan => TextSpan(
        text: _showMore,
        style: _showsTextStyle,
      );

  TextSpan get delimiterSpan => TextSpan(
        text: _delimiter,
        style: _textStyle,
      );

  TextSpan? get sendingIconTextSpan => _sendingIconShareCode != null
      ? TextSpan(
          text: _sendingIconShareCode!,
          style: _sendingIconStyle,
        )
      : null;

  int? get maxLines => _maxLines;

  set maxLines(int? lines) {
    if (lines == _maxLines) {
      return;
    }
    _maxLines = lines;
    _textPainter.maxLines = _maxLines;

    markNeedsLayout();
    markNeedsSemanticsUpdate();
  }

  set sendingIcon(String iconSharCode) {
    if (_sendingIconShareCode == null ||
        iconSharCode == _sendingIconShareCode) {
      return;
    }
    _sendingIconShareCode = iconSharCode;
    _sendingIconTextPainter?.text = sendingIconTextSpan;

    markNeedsLayout();
    markNeedsSemanticsUpdate();
  }

  set sendingIconStyle(TextStyle val) {
    if (_sendingIconStyle == null || val == _sendingIconStyle) return;
    _sendingIconStyle = val;
    _sendingIconTextPainter!.text = sendingIconTextSpan;

    markNeedsLayout();
  }

  String get showMore => _showMore;
  set showMore(String val) {
    if (val == _showMore) return;
    _showMore = val;
    _showsTextPainter.text = showsTextSpan;

    markNeedsLayout();
    markNeedsSemanticsUpdate();
  }

  set showsTextStyle(TextStyle val) {
    if (val == _showsTextStyle) return;
    _showsTextStyle = val;
    _showsTextPainter.text = showsTextSpan;

    markNeedsLayout();
  }

  set delimter(String val) {
    if (val == _delimiter) return;
    _delimiter = val;
    _delimiterTextPainter.text = delimiterSpan;

    markNeedsLayout();
    markNeedsSemanticsUpdate();
  }

  set delimiterStyle(TextStyle val) {
    if (val == _sentAtStyle) return;
    _textStyle = val;
    _delimiterTextPainter.text = delimiterSpan;

    markNeedsLayout();
  }

  set sentAt(String val) {
    if (val == _sentAt) return;
    _sentAt = val;

    _sentAtTextPainter.text = sentAtTextSpan;
    markNeedsLayout();

    // Because changing any text in our widget will definitely change the
    // semantic meaning of this piece of our UI, we need to call
    markNeedsSemanticsUpdate();
  }

  set sentAtStyle(TextStyle val) {
    if (val == _sentAtStyle) return;
    _sentAtStyle = val;
    _sentAtTextPainter.text = sentAtTextSpan;

    markNeedsLayout();
  }

  String get text => _text;
  set text(String val) {
    if (val == _text) return;
    _text = val;
    // `textTextSpan` is a computed property that incorporates both the raw
    // string value and the [TextStyle], so we have to update the whole [TextSpan]
    // any time either value is updated.
    _textPainter.text = textTextSpan;
    markNeedsLayout();

    // Because changing any text in our widget will definitely change the
    // semantic meaning of this piece of our UI, we need to call
    markNeedsSemanticsUpdate();
  }

  TextStyle get textStyle => _textStyle;
  set textStyle(TextStyle val) {
    if (val == _textStyle) return;
    _textStyle = val;
    _textPainter.text = textTextSpan;

    // If we knew that the new [TextStyle] had only changed in certain ways (e.g.
    // color) then we could be more performant and call `markNeedsPaint()` instead.
    // However, without carefully making that assessment, it is safer to call
    // the more generic method, `markNeedsLayout()` instead (which also implies
    // a repaint).
    markNeedsLayout();
  }

  set textDirection(TextDirection val) {
    if (_textDirection == val) {
      return;
    }
    _textPainter.textDirection = val;
    _sentAtTextPainter.textDirection = val;
    markNeedsSemanticsUpdate();
  }

  @override
  void describeSemanticsConfiguration(SemanticsConfiguration config) {
    super.describeSemanticsConfiguration(config);
    // Set this to `true` because individual chat bubbles are perfectly
    // self-contained semantic objects.
    config.isSemanticBoundary = true;

    config.label = '$_text, sent $_sentAt';

    config.textDirection = _textDirection;
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    // Ignore `height` parameter because chat bubbles' height grows as a
    // function of available width and text length.

    _layoutText(double.infinity);
    return _longestLineWidth;
  }

  @override
  double computeMinIntrinsicHeight(double width) =>
      computeMaxIntrinsicHeight(width);

  @override
  double computeMaxIntrinsicHeight(double width) {
    final computedSize = _layoutText(width);
    return computedSize.height;
  }

  @override
  void performLayout() {
    final unconstrainedSize = _layoutText(constraints.maxWidth);

    size = constraints.constrain(
      Size(unconstrainedSize.width, unconstrainedSize.height),
    );
  }

  /// Lays out the text within a given width constraint and returns its [Size].
  ///
  /// Because [_layoutText] is called from multiple places with multiple concerns,
  /// like intrinsics which could have different width parameters than a typical
  /// layout, this logic is moved out of `performLayout` and into a dedicated
  /// method which accepts and works with any width constraint.
  Size _layoutText(double maxWidth) {
    // Draw nothing (requiring no size) if the string doesn't exist. This is one
    // of many opinionated choices we could make here if the text is empty.
    if (_textPainter.text?.toPlainText() == '') {
      return Size.zero;
    }
    assert(
      maxWidth > 0,
      'You must allocate SOME space to layout a TimestampedChatMessageRenderObject. Received a '
      '`maxWidth` value of $maxWidth.',
    );

    // Layout the raw message, which saves expected high-level sizing values
    // to the painter itself.
    _mainTextPainter = _textPainter.copyWith(maxWidth: maxWidth);

    _textPainter.layout(maxWidth: maxWidth);
    final textLines = _textPainter.computeLineMetrics();

    // Now make similar calculations for `sentAt`.
    _sentAtTextPainter.layout(maxWidth: maxWidth);
    _sentAtLineWidth = _sentAtTextPainter.computeLineMetrics().first.width;

    _shouldPaintShows = _textPainter.didExceedMaxLines;

    if (_shouldPaintShows) {
      _showsTextPainter.layout(maxWidth: maxWidth);
      _delimiterTextPainter.layout(maxWidth: maxWidth);
      _showsLineWidth = _showsTextPainter.computeLineMetrics().first.width;
      _delimiterLineWidth =
          _delimiterTextPainter.computeLineMetrics().first.width;

      int endIndex;

      final readMoreSize =
          _showsTextPainter.width + _delimiterTextPainter.width;
      final pos = _textPainter.getPositionForOffset(Offset(
        _textPainter.width - readMoreSize,
        _textPainter.height,
      ));

      endIndex = _textPainter.getOffsetBefore(pos.offset) ?? 0;
      final newText = _text.substring(0, endIndex);
      final newTextSpan = textTextSpan.copyWith(newText: newText);

      _mainTextPainter = _textPainter.copyWith(
        newTextSpan: newTextSpan,
        maxWidth: maxWidth,
      );
    }

    // Now make similar calculations for `sendingIcon`.
    if (_sendingIconTextPainter != null) {
      _sendingIconTextPainter?.layout(maxWidth: maxWidth);
      _iconLineWidth =
          _sendingIconTextPainter!.computeLineMetrics().first.width;
    }
    // Reset cached values from the last frame if they're assumed to start at 0.
    // (Because this is used in `max`, if it opens a new frame still holding the
    // value from a previous frame, we could fail to accurately calculate the
    // longest line.)
    _longestLineWidth = 0;

    // Next, we calculate a few metrics for the height and width of the message.

    // First, chat messages don't actually grow to their full available width
    // if their longest line does not require it. Thus, we need to note the
    // longest line in the message.
    for (final line in textLines) {
      _longestLineWidth = max(_longestLineWidth, line.width);
    }
    // If the message is very short, it's possible that the longest line is
    // is actually the date.
    final double iconWidth =
        _sendingIconTextPainter != null ? _sendingIconTextPainter!.width : 0;

    _longestLineWidth =
        max(_longestLineWidth, (_sentAtTextPainter.width + iconWidth));

    // Because [_textPainter.width] can be the maximum width we passed to it,
    // even if the longest line is shorter, we use this logic to determine its
    // real size, for our purposes.
    final sizeOfMessage = Size(_longestLineWidth, _mainTextPainter.height);

    // Cache additional variables used both in the rest of this method and in
    // `paint` later on.
    _lastMessageLineWidth = textLines.last.width;
    _lineHeight = textLines.last.height;
    _numMessageLines = textLines.length;

    // Determine whether the message's last line and the date can share a
    // horizontal row together.
    final lastLineWithDateAndIcon = _lastMessageLineWidth +
        (_sentAtLineWidth * 1.3) +
        (_iconLineWidth * 1.3);
    if (textLines.length == 1) {
      _sentAtAndIconFitOnLastLine = lastLineWithDateAndIcon < maxWidth;
    } else {
      _sentAtAndIconFitOnLastLine =
          lastLineWithDateAndIcon < min(_longestLineWidth, maxWidth);
    }

    late Size computedSize;
    if (!_sentAtAndIconFitOnLastLine) {
      computedSize = Size(
        // If `sentAt` does not fit on the longest line, then we know the
        // message contains a long line, making this a safe value for `width`.
        sizeOfMessage.width,
        // And similarly, if `sentAt` does not fit, we know to add its height
        // to the overall size of just-the-message.
        sizeOfMessage.height + _sentAtTextPainter.height,
      );
    } else {
      // Moving forward, of course, we know that `sentAt` DOES fit into the last
      // line.

      if (textLines.length == 1) {
        computedSize = Size(
          // When there is only 1 line, our width calculations are in a special
          // case of needing as many pixels as our line plus the date, as opposed
          // to the full size of the longest line.
          lastLineWithDateAndIcon,
          sizeOfMessage.height,
        );
      } else {
        computedSize = Size(
          // But when there's more than 1 line, our width should be equal to the
          // longest line.
          _longestLineWidth,
          sizeOfMessage.height,
        );
      }
    }
    return computedSize;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    // Draw nothing (requiring no paint calls) if the string doesn't exist. This
    // is one of many opinionated choices we could make here if the text is empty.
    if (_mainTextPainter.text?.toPlainText() == '') {
      return;
    }

    // This line writes the actual message to the screen. Because we use the
    // same offset we were passed, the text will appear in the upper-left corner
    // of our available space.

    _mainTextPainter.paint(context.canvas, offset);

    late Offset delimiterOffset;

    if (_shouldPaintShows) {
      delimiterOffset = Offset(
        offset.dx +
            (size.width - (_showsLineWidth * 1.1) - _delimiterLineWidth),
        offset.dy + (_lineHeight * (_numMessageLines - 1)),
      );
      showsOffset = Offset(
        offset.dx + (size.width - (_showsLineWidth * 1.08)),
        offset.dy + (_lineHeight * (_numMessageLines - 0.87)),
      );

      _delimiterTextPainter.paint(context.canvas, delimiterOffset);
      _showsTextPainter.paint(context.canvas, showsOffset);
    }

    late Offset sentAtOffset;
    if (_sentAtAndIconFitOnLastLine) {
      sentAtOffset = Offset(
        offset.dx + (size.width - (_sentAtLineWidth + _iconLineWidth * 1.2)),
        offset.dy + (_lineHeight * (_numMessageLines - 0.68)),
      );
    } else {
      sentAtOffset = Offset(
        offset.dx + (size.width - (_sentAtLineWidth + _iconLineWidth * 1.2)),
        offset.dy + _lineHeight * _numMessageLines,
      );
    }

    // Finally, place the `sentAt` value accordingly.
    _sentAtTextPainter.paint(context.canvas, sentAtOffset);
    if (_sendingIconTextPainter != null) {
      late Offset iconOffset;

      if (_sentAtAndIconFitOnLastLine) {
        iconOffset = Offset(
          offset.dx + (size.width - _iconLineWidth),
          offset.dy + (_lineHeight * (_numMessageLines - 0.7)),
        );
      } else {
        iconOffset = Offset(
          offset.dx + (size.width - _iconLineWidth),
          offset.dy + _lineHeight * _numMessageLines,
        );
      }
      _sendingIconTextPainter!.paint(context.canvas, iconOffset);
    }
  }

  @override
  void detach() {
    _tap.dispose();
    super.detach();
  }

  void onTap() {
    lines = lines! + _maxLines!;

    _textPainter = _textPainter.copyWith(
      maxWidth: size.width,
      lines: lines,
    );
    markNeedsLayout();
  }

  @override
  bool hitTestSelf(Offset position) {
    late Offset offset;
    late Offset localShowsOffet;
    if (_shouldPaintShows) {
      localShowsOffet = Offset(
        (size.width - _showsLineWidth),
        (_lineHeight * (_numMessageLines - 0.92)),
      );

      offset = Offset(
          position.dx - localShowsOffet.dx, position.dy - localShowsOffet.dy);
      return _showsTextPainter.size.contains(offset);
    } else {
      return false;
    }
  }

  @override
  void handleEvent(
      PointerEvent event, covariant HitTestEntry<HitTestTarget> entry) {
    assert(debugHandleEvent(event, entry));
    if (event is PointerDownEvent) {
      _tap.addPointer(event);
    }
  }
}
