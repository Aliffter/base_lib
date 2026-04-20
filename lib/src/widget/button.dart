import 'package:flutter/material.dart';
import 'package:flutter_auto_size_text/flutter_auto_size_text.dart';

/// 按钮类型
enum ButtonType {
  /// 实心按钮（主按钮）
  primary,

  /// 边框按钮
  border,

  /// 浅灰按钮
  lightGray,
}

/// 图标位置
enum IconPosition { left, right, top, bottom }

/// 文本适配优先级
enum TextFitPriority {
  /// 行数优先
  linesFirst,

  /// 缩放优先
  sizeFirst,
}

/// 通用按钮组件
class ButtonWidget extends StatelessWidget {
  final String text; // 按钮文字
  final VoidCallback? onTap; // 点击事件
  final ButtonType type; // 按钮类型
  final Widget? icon; // 可选图标
  final IconPosition iconPosition; // 图标位置
  final double iconSpacing; // 图标与文字的间距
  final double? borderRadius; // 圆角
  final EdgeInsetsGeometry padding; // 内边距
  final EdgeInsetsGeometry? margin; // 外边距

  final double? width; // 宽度
  final double? height; // 高度   默认自适应，通过padding调整设置
  final Color? color; // 自定义背景色（可选）
  final Color? borderColor;
  final Color? textColor; // 自定义文字颜色（可选）
  final TextStyle? textStyle;
  final TextAlign? textAlign;
  final double? fontSize; // 默认14
  final FontWeight? fontWeight; // 默认normal
  final int maxLines; // 最大行数
  final bool? autoSize; // 是否自动适配文字 最小10px

  final bool? disabled; // 是否禁用
  final TextFitPriority textFitPriority; // 文本适配优先级

  const ButtonWidget({
    super.key,
    required this.text,
    this.onTap,
    this.type = ButtonType.primary,
    this.icon,
    this.iconPosition = IconPosition.left,
    this.iconSpacing = 2.0,
    this.borderRadius,
    this.margin,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
    this.width,
    this.height,
    this.color,
    this.borderColor,
    this.textColor,
    this.fontSize,
    this.fontWeight = FontWeight.w600,
    this.textAlign = TextAlign.center,
    this.textStyle,
    this.maxLines = 2,
    this.autoSize,
    this.disabled,
    this.textFitPriority = TextFitPriority.sizeFirst,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasIcon = icon != null;

    // 按钮样式配置
  // 按钮样式配置
    Color _backgroundColor;
    Color _borderColor;
    Color _textColor;

    Color _themeColor = const Color(0xFFA52933);
    Color _grayColor = const Color(0xFFF7F7F7);

    switch (type) {
      case ButtonType.primary:
        _backgroundColor = color ?? _themeColor;
        _borderColor = Colors.transparent;
        _textColor = textColor ?? Colors.white;
        break;
      case ButtonType.border:
        _backgroundColor = Colors.transparent;
        _borderColor = borderColor ?? _themeColor;
        _textColor = textColor ?? _themeColor;
        break;
      case ButtonType.lightGray:
        _backgroundColor = color ?? _grayColor;
        _borderColor = Colors.transparent;
        _textColor = textColor ?? Colors.black;
        break;
    }

    if (disabled == true) {
      Color _disableColor = const Color(0xfff2f2f2);
      Color _disableTextColor = const Color(0x3d000000);
      _backgroundColor = _disableColor;
      _textColor = _disableTextColor;
      _borderColor = _disableColor;
    }

    // 构建图标 + 文本组合
    Widget content = _buildContent(hasIcon, _textColor);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (disabled == true) {
          return;
        }
        onTap?.call();
      },
      child: Container(
        padding: padding,
        margin: margin,
        width: width,
        height: height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _backgroundColor,
          border: Border.all(color: _borderColor),
          borderRadius: BorderRadius.circular(borderRadius ?? 999),
        ),
        child: content,
      ),
    );
  }

  /// 根据图标位置动态布局
  Widget _buildContent(bool hasIcon, Color textColor) {
    final Widget textWidget;
    if (autoSize == true) {
      final resolvedStyle =
          textStyle ??
          TextStyle(
            color: textColor,
            fontSize: fontSize ?? 14,
            fontWeight: fontWeight,
          );

      if (textFitPriority == TextFitPriority.sizeFirst) {
        textWidget = AutoSizeText(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: textAlign,
          wrapWords: true,
          style: resolvedStyle,
          minFontSize: 10,
          overflowReplacement: AutoSizeText(
            text,
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
            textAlign: textAlign,
            wrapWords: true,
            style: resolvedStyle,
            minFontSize: 10,
          ),
        );
      } else {
        textWidget = AutoSizeText(
          text,
          maxLines: maxLines,
          overflow: TextOverflow.ellipsis,
          textAlign: textAlign,
          wrapWords: true,
          style: resolvedStyle,
          minFontSize: 10,
        );
      }
    } else {
      textWidget = Text(
        text,
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
        textAlign: textAlign,
        style:
            textStyle ??
            TextStyle(
              color: textColor,
              fontSize: fontSize ?? 14,
              fontWeight: fontWeight ?? FontWeight.w600,
            ),
      );
    }

    if (!hasIcon) return textWidget;

    final iconWidget = icon!;

    switch (iconPosition) {
      case IconPosition.left:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            iconWidget,
            SizedBox(width: iconSpacing),
            Flexible(child: textWidget),
          ],
        );
      case IconPosition.right:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(child: textWidget),
            SizedBox(width: iconSpacing),
            iconWidget,
          ],
        );
      case IconPosition.top:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            iconWidget,
            SizedBox(height: iconSpacing),
            Flexible(child: textWidget),
          ],
        );
      case IconPosition.bottom:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            textWidget,
            SizedBox(height: iconSpacing),
            Flexible(child: iconWidget),
          ],
        );
    }
  }
}
