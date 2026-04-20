import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  /// ================= 基础颜色 =================

  static const white = Color(0xFFFFFFFF);

  static const red = Color(0xFFA52933);

  static const green = Color(0xFF29AF7A);

  static const gray100 = Color(0xFFF4F5F7);

  static const gray200 = Color(0xFFE1E6ED);

  static const gray300 = Color(0xFFEDEEF0);

  static const black80 = Color(0xCC000000);

  static const white80 = Color(0xCCFFFFFF);

  static const white8 = Color(0x14FFFFFF);

  /// ================= 语义颜色 =================

  /// App 主背景
  static const backgroundPrimary = gray100;

  /// 卡片 / 页面背景
  static const surface = white;

  /// Toast 背景
  static const toastBackground = black80;

  /// 主题主色
  static const primary = gray200;

  /// 成功 / 正向状态
  static const success = green;

  /// 危险 / 错误 / 删除
  static const danger = red;

  /// 单选按钮背景
  static const radioBackground = gray300;
}