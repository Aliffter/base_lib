import 'package:intl/intl.dart';

/// 日期格式定义
class DateFormatType {
  static const String date = 'yyyy-MM-dd';
  static const String dateTime = 'yyyy-MM-dd HH:mm:ss';
  static const String dateSlash = 'yyyy/MM/dd';
}

/// DateTime 格式化扩展
extension DateTimeFormatExt on DateTime {
  /// 按指定格式转字符串
  /// DateTime.now().format(DateFormatType.dateSlash);
  ///
  String format([String? pattern = DateFormatType.dateTime]) {
    return DateFormat(pattern).format(this);
  }

  DateTime toStartOfDay() {
    return DateTime(year, month, day, 0, 0, 0);
  }

  DateTime toEndOfDay() {
    return DateTime(year, month, day, 23, 59, 59);
  }

  /// 获取本周一的日期
  DateTime get monday {
    final difference = weekday - DateTime.monday;
    return DateTime(year, month, day - difference);
  }

  // 获取上周的时间范围
  List<DateTime> get lastWeekRange {
    final thisMonday = monday;
    final lastMonday = thisMonday.subtract(const Duration(days: 7));
    final lastSunday = lastMonday.add(const Duration(days: 6, hours: 23, minutes: 59, seconds: 59));
    
    return [
      DateTime(lastMonday.year, lastMonday.month, lastMonday.day, 0, 0, 0),
      DateTime(lastSunday.year, lastSunday.month, lastSunday.day, 23, 59, 59),
    ];
  }

}
