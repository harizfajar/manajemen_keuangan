import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:duitKu/common/widgets/color.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: SizedBox(
              height: 250,
              child: SvgPicture.asset("assets/logo/logo.svg"),
            ),
          ),
        ],
      ),
    );
  }
}
