import 'package:duitKu/common/utils/constans.dart';
import 'package:duitKu/global.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'welcome_notifier.g.dart';

@riverpod
class WelcomeNotifier extends _$WelcomeNotifier {
  @override
  int build() {
    return 0;
  }

  void changeIndex(int newIndex) {
    state = newIndex;
  }

  void nextPage({BuildContext? context, PageController? pageController}) async {
    if (state < 2) {
      pageController!.animateToPage(
        state + 1,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeIn,
      );
    }
    if (state == 2) {
      Global.storageService.setBool(
        AppConstants.STORAGE_DEVICE_OPEN_FIRST_KEY,
        true,
      );
      Navigator.pushReplacementNamed(context!, "/signin");
    }
  }
}
