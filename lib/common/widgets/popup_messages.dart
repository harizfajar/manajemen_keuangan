import 'package:another_flushbar/flushbar.dart';
import 'package:duitKu/main.dart';
import 'package:flutter/material.dart';

void toastInfo(String msg, {Color? bgColor, IconData? icon}) {
  final context = navKey.currentContext;

  Flushbar(
    message: msg,
    duration: const Duration(seconds: 2),
    backgroundColor: bgColor ?? Colors.red,
    flushbarPosition: FlushbarPosition.TOP,
    margin: EdgeInsets.symmetric(horizontal: 16),
    borderRadius: BorderRadius.circular(8),
    animationDuration: const Duration(milliseconds: 500),
    icon: Icon(icon ?? Icons.info, color: Colors.white),
    isDismissible: true,
  ).show(context!);
}
