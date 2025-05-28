import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:duitKu/common/widgets/apptextfield.dart';
import 'package:duitKu/common/widgets/button.dart';
import 'package:duitKu/common/widgets/color.dart';
import 'package:duitKu/common/widgets/text.dart';
import 'package:duitKu/pages/sign_in/notifier/user_notifier.dart';
import 'package:sizer/sizer.dart';

class Register extends ConsumerWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final obsuretext = ref.watch(obscureTextProvider);
    final register = ref.watch(userNotifierProvider);
    final registerNotifier = ref.read(userNotifierProvider.notifier);
    return Container(
      color: AppColors.secondary,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10.h),
            textCapriola(text: "Nama"),
            SizedBox(height: 1.h),
            apptextfield(
              text: "Masukkan nama kamu",
              func: (value) => registerNotifier.changeUser(value),
            ),
            SizedBox(height: 2.h),
            textCapriola(text: "Email"),
            SizedBox(height: 1.h),
            apptextfield(func: (value) => registerNotifier.changeEmail(value)),
            SizedBox(height: 2.h),
            textCapriola(text: "Password"),
            SizedBox(height: 1.h),
            apptextfield(
              text: "Masukkan Password kamu",
              showSuffixIcon: true,
              obscureText: obsuretext,
              onPressed: () {
                ref.read(obscureTextProvider.notifier).change(obsuretext);
                print(obsuretext);
              },
              func: (value) => registerNotifier.changePassword(value),
            ),
            SizedBox(height: 2.h),
            textCapriola(text: "Konfirmasi Password"),
            SizedBox(height: 1.h),
            apptextfield(
              text: "Masukkan Passowrd kamu",
              showSuffixIcon: true,
              obscureText: obsuretext,
              onPressed: () {
                ref.read(obscureTextProvider.notifier).change(obsuretext);
                print(obsuretext);
              },
              func: (value) => registerNotifier.changeConfirmPassword(value),
            ),
            SizedBox(height: 6.h),
            buttonCust(
              height: 50,
              width: 100.w,
              text: register.isLoading ? "Tunggu..." : "Daftar",
              colorText: Colors.black,
              colorBorder: Colors.transparent,
              func: () {
                print("Register");
                registerNotifier.register(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
