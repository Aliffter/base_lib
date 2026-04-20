import 'package:flutter/material.dart';

class TipText extends StatelessWidget {
  const TipText({
    super.key,
    required this.message,
    required this.child,
    this.preferBelow = false,
    this.showTip = true,
  });
  final String message;
  final Widget child;
  final bool? preferBelow;
  final bool showTip;

  @override
  Widget build(BuildContext context) {
    if (!showTip) return child;

    return LayoutBuilder(
      builder: (context, constraints) {
        if (!_shouldShowTooltip(context, constraints)) {
          return child;
        }
        return Tooltip(
          message: message,
          triggerMode: TooltipTriggerMode.tap,
          preferBelow: preferBelow ?? false,
          verticalOffset: 8,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          textStyle: const TextStyle(
            fontSize: 12,
            color:Colors.white,
          ),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.75),
            borderRadius: BorderRadius.circular(6),
          ),
          child: child,
        );
      },
    );
  }

  bool _shouldShowTooltip(BuildContext context, BoxConstraints constraints) {
    if (message.isEmpty || !constraints.hasBoundedWidth) {
      return false;
    }

    if (child is! Text) {
      // 非 Text 子组件无法精确判断是否省略，保持原有提示能力。
      return true;
    }

    final textWidget = child as Text;
    if (textWidget.overflow != TextOverflow.ellipsis) {
      return false;
    }

    final maxLines = textWidget.maxLines;
    if (maxLines == null || maxLines <= 0) {
      return false;
    }

    final textPainter = TextPainter(
      text: TextSpan(
        text: message,
        style: textWidget.style ?? DefaultTextStyle.of(context).style,
      ),
      textAlign: textWidget.textAlign ?? TextAlign.start,
      textDirection: textWidget.textDirection ?? Directionality.of(context),
      locale: textWidget.locale ?? Localizations.maybeLocaleOf(context),
      maxLines: maxLines,
      strutStyle: textWidget.strutStyle,
      textWidthBasis: textWidget.textWidthBasis ?? TextWidthBasis.parent,
      textHeightBehavior: textWidget.textHeightBehavior,
      textScaler: textWidget.textScaler ?? MediaQuery.textScalerOf(context),
    )..layout(maxWidth: constraints.maxWidth);

    return textPainter.didExceedMaxLines;
  }
}
