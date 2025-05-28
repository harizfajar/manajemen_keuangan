import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:duitKu/common/widgets/text.dart';
import 'package:sizer/sizer.dart';

Widget Onboarding({String? text}) {
  return Padding(
    padding: const EdgeInsets.all(10),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset('assets/logo/logo.svg', width: 141),
        SizedBox(height: 2.h),
        textCapriola(fontSize: 24, text: "uangQ"),
        SizedBox(height: 5.h),
        textCapriola(
          fontSize: 16,
          text: text ?? "Kelola keuangan pribadimu dengan lebih efisien.",
          fontWeight: FontWeight.bold,
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}
