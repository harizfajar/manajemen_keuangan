import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget textCapriola({
  String? text,
  FontWeight? fontWeight,
  Color? color,
  TextAlign? textAlign,
  double? fontSize,
}) {
  return Text(
    text ?? "",
    textAlign: textAlign ?? TextAlign.start,
    style: GoogleFonts.capriola(
      fontSize: fontSize ?? 14,
      fontWeight: fontWeight ?? FontWeight.normal,
      color: color ?? Colors.white,
    ),
  );
}

Widget textPoppins({
  String? text,
  FontWeight? fontWeight,
  Color? color,
  TextAlign? textAlign,
  double? fontSize,
}) {
  return Text(
    text ?? "",
    textAlign: textAlign ?? TextAlign.start,
    style: GoogleFonts.poppins(
      fontSize: fontSize ?? 14,
      fontWeight: fontWeight ?? FontWeight.normal,
      color: color ?? Colors.white,
    ),
  );
}
