import 'package:flutter/material.dart';
import 'package:duitKu/common/widgets/text.dart';
import 'package:sizer/sizer.dart';

Widget button({
  String? text,
  double? borderRadius,
  double? width,
  double? height,
  double? borderWidth,
  Color? color,
  Color? colorText,
  Color? colorBorder,
  void Function()? func,
}) {
  return GestureDetector(
    onTap: func,
    child: Container(
      height: height ?? double.infinity,
      width: width ?? 50,
      decoration: boxDekor(
        color: color,
        borderWidth: borderWidth,
        colorBorder: colorBorder,
        borderRadius: borderRadius,
      ),
      child: Center(
        child: textCapriola(fontSize: 14, text: text, color: colorText),
      ),
    ),
  );
}

Widget buttonCust({
  String? text,
  double? borderRadius,
  double? width,
  double? height,
  Color? color,
  Color? colorText,
  Color? colorBorder,
  void Function()? func,
}) {
  return SizedBox(
    height: height ?? 50,
    width: width ?? 100.h,

    child: ElevatedButton(
      onPressed: func,
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Center(
        child: textCapriola(fontSize: 14, text: text, color: colorText),
      ),
    ),
  );
}

BoxDecoration boxDekor({
  double? borderWidth,
  Color? color,
  Color? colorBorder,
  double? borderRadius,
}) {
  return BoxDecoration(
    color: color ?? Colors.white,
    borderRadius: BorderRadius.circular(borderRadius ?? 10),
    border: Border.all(
      color: colorBorder ?? Colors.black,
      width: borderWidth ?? 1,
    ),
  );
}
