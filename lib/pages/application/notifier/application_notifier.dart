import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'application_notifier.g.dart';

@riverpod
class ObscureBalanceNotifier extends _$ObscureBalanceNotifier {
  @override
  bool build() => false;

  void changeValue(bool newBool) {
    state = newBool;
  }
}

@riverpod
class BottombarIndex extends _$BottombarIndex {
  @override
  int build() => 0;
  void changeValue(int value) {
    state = value;
  }
}

// class BalanceObscure extends StateNotifier<bool> {
//   BalanceObscure() : super(false); // Default state = false
//   void changeValue(bool newBool) {
//     state = newBool;
//   }
// }
// // Provider untuk mengakses LoaderNotifier
// final balanceObscureProvider = StateNotifierProvider.autoDispose<BalanceObscure, bool>(
//   (ref) => BalanceObscure(),
// );
// Provider untuk mengakses LoaderNotifier
class SelectTab extends StateNotifier<int> {
  SelectTab() : super(0); // Default state = false

  void changeValue(int value) {
    state = value;
  }
}

final selectTabProvider = StateNotifierProvider<SelectTab, int>(
  (ref) => SelectTab(),
);
