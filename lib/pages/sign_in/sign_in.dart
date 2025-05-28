import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:duitKu/common/widgets/apptextfield.dart';
import 'package:duitKu/common/widgets/button.dart';
import 'package:duitKu/common/widgets/color.dart';
import 'package:duitKu/common/widgets/text.dart';
import 'package:duitKu/pages/register/register.dart';
import 'package:duitKu/pages/sign_in/notifier/user_notifier.dart';
import 'package:sizer/sizer.dart';

class SignIn extends ConsumerWidget {
  const SignIn({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Stack(
                  children: [
                    Container(
                      height: 100,
                      decoration: BoxDecoration(
                        gradient: AppColors.verticalGradient,
                      ),
                    ),
                    Positioned(
                      top: 50,
                      left: 20,
                      right: 20,
                      child: textCapriola(
                        fontSize: 24,
                        text: "Selamat Datang di uangQ",
                        color: Color(0xFF184666),
                      ),
                    ),
                    Positioned(
                      top: 86,
                      left: 20,
                      right: 20,
                      child: textCapriola(
                        text: "Masukkan data kamu untuk melanjutkan",
                        color: Color(0xFF184666),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      height: 77.h,
                      width: 100.w,
                      child: TabBarView(children: [Login(), Register()]),
                    ),
                    Positioned(
                      top: 20.h,
                      left: 60,
                      right: 60,
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: AppColors.primary,
                            width: 3,
                          ),
                        ),
                        child: TabBar(
                          indicatorPadding: EdgeInsets.only(bottom: 10),
                          dividerHeight: 0,
                          indicatorColor: AppColors.primary,
                          labelColor: Colors.black,
                          labelStyle: TextStyle(
                            fontSize: 18,
                            fontFamily: "Capriola",
                            fontWeight: FontWeight.bold,
                          ),
                          tabs: [Tab(text: "Login"), Tab(text: "Daftar")],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Login extends ConsumerWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final obsuretext = ref.watch(obscureTextProvider);
    final login = ref.watch(userNotifierProvider);
    final loginNotifier = ref.read(userNotifierProvider.notifier);
    return Container(
      color: AppColors.secondary,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10.h),
            textCapriola(text: "Email"),
            SizedBox(height: 1.h),
            apptextfield(
              text: "Masukkan Email kamu",
              func: (value) => loginNotifier.changeEmail(value),
            ),
            SizedBox(height: 2.h),
            textCapriola(text: "Password"),
            SizedBox(height: 1.h),
            apptextfield(
              text: "Masukkan Password kamu",
              showSuffixIcon: true,
              obscureText: obsuretext,
              onPressed: () {
                ref.read(obscureTextProvider.notifier).change(obsuretext);
                print("obsuretext: $obsuretext");
              },
              func: (value) => loginNotifier.changePassword(value),
            ),
            SizedBox(height: 6.h),
            buttonCust(
              height: 50,
              width: 100.w,
              text: login.isLoading ? "Tunggu..." : "Masuk",
              colorText: Colors.black,
              colorBorder: Colors.transparent,
              func: () {
                login.isLoading ? null : loginNotifier.login();
              },
            ),
          ],
        ),
      ),
    );
  }
}
