import 'package:flutter/material.dart';
import 'package:budz/utils/color_library.dart';

class CustomTextStyles extends TextStyle {
  static TextStyle defaultText = const TextStyle(
    fontSize: 16,
    fontFamily: 'outfit',
    fontWeight: FontWeight.w400,
    color: ColorLibrary.textColor,
  );
  static TextStyle textSmall = const TextStyle(
    fontSize: 12,
    fontFamily: 'outfit',
    fontWeight: FontWeight.w400,
    color: ColorLibrary.labelTextColor,
  );
  static TextStyle labelSmall = const TextStyle(
    fontSize: 14,
    fontFamily: 'outfit',
    fontWeight: FontWeight.w400,
    color: ColorLibrary.labelTextColor,
  );
  static TextStyle boldText = const TextStyle(
    fontSize: 18,
    fontFamily: 'outfit',
    fontWeight: FontWeight.w700,
    color: ColorLibrary.textColor,
  );
  static TextStyle title = const TextStyle(
    fontSize: 20,
    fontFamily: 'outfit',
    fontWeight: FontWeight.w700,
    color: ColorLibrary.textColor,
  );
  static TextStyle labelButton = const TextStyle(
    fontSize: 16,
    fontFamily: 'outfit',
    fontWeight: FontWeight.w700,
    color: ColorLibrary.themeColor,
  );
  static TextStyle formText = const TextStyle(
    fontSize: 16,
    fontFamily: 'outfit',
    fontWeight: FontWeight.w600,
    color: ColorLibrary.textColor,
  );
  static TextStyle lightText = const TextStyle(
    fontSize: 16,
    fontFamily: 'outfit',
    fontWeight: FontWeight.w400,
    color: ColorLibrary.lightGray,
  );
}
