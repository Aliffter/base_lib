import 'dart:math';

import 'package:intl/intl.dart';

/// 小数处理方式
enum DecimalRoundType {
  /// 四舍五入
  round,

  /// 直接截取（不进位）
  truncate,

  /// 向上取整（ceil）
  ceil,

  /// 向下取整（floor）
  floor,
}

extension NumSafeExt on num? {
  /// 小于等于0 或 null 时，返回默认值
  double safeNum({double defaultValue = 0.01}) {
    final value = this;
    if (value == null || value <= 0) {
      return defaultValue;
    }
    return value.toDouble();
  }
} 


extension NumFormatExt on num {
  /// 返回 double，支持是否四舍五入
  /// [digits] 保留小数位数
  /// [round] 是否四舍五入（false = truncate截断）
  double toRound([int digits = 2, bool round = true]) {
    if (round) {
      return double.parse(toStringAsFixed(digits));
    } else {
      double multiplier = pow(10, digits).toDouble();
      return (this * multiplier).truncate() / multiplier;
    }
  }

  /// 保留指定小数位数
  /// [digits] 保留的小数位数
  /// [roundType] 小数处理方式
  /// 返回 double 类型
  double toDecimal([
    int digits = 2, 
    DecimalRoundType roundType = DecimalRoundType.round,
  ]) {
    // 防止负数
    digits = max(0, digits);

    final factor = pow(10, digits);

    switch (roundType) {
      case DecimalRoundType.round:
        return (this * factor).round() / factor;

      case DecimalRoundType.truncate:
        return (this * factor).truncate() / factor;

      case DecimalRoundType.ceil:
        return (this * factor).ceil() / factor;

      case DecimalRoundType.floor:
        return (this * factor).floor() / factor;
    }
  }

  /// 格式化小数：
  /// [digits] 保留的小数位数（超过则四舍五入截取，不足不补0）
  /// [trimTrailingZeros] 是否去除末尾无意义的0
  String formatDecimalStr([int digits = 2, bool trimTrailingZeros = false]) {
    String result = toStringAsFixed(digits);
    if (trimTrailingZeros) {
      // 正则移除多余的0和末尾的小数点
      result = result.replaceAll(RegExp(r'([.]*0+)(?!.*\d)'), '');
    }

    return result;
  }

 /// 金额千分位处理
  ///
  /// [digits] 小数位数
  /// [roundType] 小数处理方式（默认四舍五入）
  ///
  /// 示例：
  /// 1234.567.formatCurrency()                             -> 1,234.57
  /// 1234.567.formatCurrency(2, DecimalRoundType.truncate) -> 1,234.56
  /// 1234.561.formatCurrency(2, DecimalRoundType.ceil)     -> 1,234.57
  String formatCurrency([
    int digits = 2,
    DecimalRoundType roundType = DecimalRoundType.round,
  ]) {
    // 防止负数
    digits = max(0, digits);

    final factor = pow(10, digits);

    num value;

    switch (roundType) {
      case DecimalRoundType.round:
        value = (this * factor).round() / factor;
        break;

      case DecimalRoundType.truncate:
        value = (this * factor).truncate() / factor;
        break;

      case DecimalRoundType.ceil:
        value = (this * factor).ceil() / factor;
        break;

      case DecimalRoundType.floor:
        value = (this * factor).floor() / factor;
        break;
    }

    String pattern = "#,##0";
    if (digits > 0) {
      pattern += ".${"0" * digits}";
    }

    return NumberFormat(pattern).format(value);
  }
}
