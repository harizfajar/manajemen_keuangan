import 'package:flutter/material.dart';

class AppColors {
  static Color primary = const Color(0xFF920090);
  static Color secondary = const Color(0xFFC719C4);

  // Linear gradient definitions
  static LinearGradient primaryGradient = LinearGradient(
    colors: [secondary.withOpacity(1), primary.withOpacity(1)],
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
  );

  // You can define multiple gradients with different directions
  static LinearGradient verticalGradient = LinearGradient(
    colors: [Colors.white, primary],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );
}
