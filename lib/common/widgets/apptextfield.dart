import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:duitKu/common/widgets/color.dart';
import 'package:sizer/sizer.dart';

Widget apptextfield({
  String? text,
  String? asset,
  double? height,
  double? width,
  double? fontSize,
  double? widthSizebox,
  bool? obscureText,
  bool showSuffixIcon = false,
  bool logo = false,
  Color? color,
  Color? colorHintT,
  TextEditingController? controller,
  TextInputType? keyboardType,
  List<TextInputFormatter>? inputFormatters,
  void Function()? onPressed,
  void Function(String value)? func,
}) {
  return Container(
    height: height ?? 50,
    width: width,
    decoration: BoxDecoration(
      color: color ?? Colors.white,
      borderRadius: BorderRadius.circular(10),
    ),
    child:
        logo
            ? Row(
              children: [
                SizedBox(width: widthSizebox ?? 10),
                SizedBox(
                  width: 30,
                  child: SvgPicture.asset(
                    asset ?? "assets/logo/card2.svg",
                    width: asset == "assets/logo/Rp.svg" ? 22 : null,
                  ),
                ),
                SizedBox(
                  width: 80.w,
                  height: 50,
                  child: TextField(
                    onChanged: func,
                    obscureText: obscureText ?? false,
                    keyboardType: keyboardType,
                    inputFormatters: inputFormatters,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: fontSize ?? 14,
                      fontFamily: "Capriola",
                    ),
                    decoration: InputDecoration(
                      hintText: text ?? "Masukkin email kamu",
                      hintStyle: TextStyle(
                        fontSize: fontSize ?? 14,
                        fontFamily: "Capriola",
                      ),
                      suffixIcon:
                          showSuffixIcon
                              ? IconButton(
                                onPressed: onPressed,

                                icon: Icon(
                                  color: AppColors.primary,
                                  obscureText == false
                                      ? Icons.remove_red_eye
                                      : Icons.visibility_off,
                                ),
                              )
                              : null,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                    ),
                  ),
                ),
              ],
            )
            : TextField(
              controller: controller,
              onChanged: func,
              obscureText: obscureText ?? false,
              keyboardType: keyboardType,
              inputFormatters: inputFormatters,
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: fontSize ?? 14,
                fontFamily: "Capriola",
                color: colorHintT,
              ),
              decoration: InputDecoration(
                hintText: text ?? "Masukkin email kamu",
                hintStyle: TextStyle(
                  fontSize: fontSize ?? 14,
                  color: colorHintT,
                  fontFamily: "Capriola",
                ),
                suffixIcon:
                    showSuffixIcon
                        ? IconButton(
                          onPressed: onPressed,

                          icon: Icon(
                            color: AppColors.primary,
                            obscureText == false
                                ? Icons.remove_red_eye
                                : Icons.visibility_off,
                          ),
                        )
                        : null,
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                ),
              ),
            ),
  );
}
