import 'package:duitKu/common/routes/app_routes_name.dart';
import 'package:duitKu/common/widgets/color.dart';
import 'package:duitKu/common/widgets/text.dart';
import 'package:duitKu/global.dart';
import 'package:duitKu/pages/history/user_info.dart';
import 'package:duitKu/pages/sign_in/notifier/user_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';

class Lainnya extends ConsumerWidget {
  const Lainnya({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = Global.storageService.getUserId();
    final UserNotifier = ref.read(userNotifierProvider.notifier);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        spacing: 10,
        children: [
          Stack(
            children: [
              Container(
                height: 150,
                decoration: BoxDecoration(gradient: AppColors.verticalGradient),
              ),
              Positioned(
                left: 20,
                top: 40,
                child: Row(
                  children: [
                    SvgPicture.asset("assets/logo/logo.svg", width: 25),
                    SizedBox(width: 1.h),
                    textCapriola(fontSize: 16, text: "uangQ"),
                  ],
                ),
              ),
              Positioned(
                right: 20,
                top: 40,
                child: UserInfoWidget(userId: userId),
              ),
            ],
          ),
          menuButton(
            icon: Icons.calculate,
            label: "Kalkulator",
            onTap: () {
              Navigator.pushNamed(context, AppRoutesName.KALKULATOR);
            },
          ),
          menuButton(
            icon: Icons.logout,
            label: "Keluar",
            onTap: () {
              UserNotifier.logout();
            },
          ),
        ],
      ),
    );
  }
}

Widget menuButton({
  required IconData icon,
  required String label,
  required VoidCallback onTap,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 14),
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        height: 55,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.secondary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            SizedBox(width: 15),
            Icon(icon, color: Colors.white, size: 32),
            SizedBox(width: 15),
            textPoppins(
              text: label,
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ],
        ),
      ),
    ),
  );
}
