import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:duitKu/common/widgets/button.dart';
import 'package:duitKu/common/widgets/color.dart';
import 'package:duitKu/common/widgets/onboarding.dart';
import 'package:duitKu/pages/welcome/notifier/welcome_notifier.dart';
import 'package:sizer/sizer.dart';

class Welcome extends ConsumerWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final welcome = ref.watch(welcomeNotifierProvider);
    final welcomeNotifier = ref.watch(welcomeNotifierProvider.notifier);
    final pageController = PageController();
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.primaryGradient),
        child: Stack(
          children: [
            PageView(
              controller: pageController,
              onPageChanged: (value) => welcomeNotifier.changeIndex(value),
              children: [
                Onboarding(),
                Onboarding(
                  text:
                      "Stabilitas finansial dimulai dengan pencatatan keuangan yang rapih.",
                ),
                Onboarding(
                  text:
                      "Buat masa depan mu menjadi indah dengan finansial yang stabil.",
                ),
              ],
            ),
            Positioned(
              left: 18.w,
              bottom: 5.h,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: button(
                  width: 65.w,
                  height: 50,
                  color: Colors.transparent,
                  colorBorder: Colors.white,
                  borderWidth: 2,
                  borderRadius: 50,
                  text: welcome < 2 ? "Lanjut" : "Mulai",
                  func:
                      () => {
                        welcomeNotifier.nextPage(
                          context: context,
                          pageController: pageController,
                        ),
                      },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
