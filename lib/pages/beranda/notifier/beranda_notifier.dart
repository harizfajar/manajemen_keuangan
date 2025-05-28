import 'dart:math';

import 'package:duitKu/global.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tuple/tuple.dart';
part 'beranda_notifier.g.dart';

@riverpod
class SelectedMonthNotifier extends _$SelectedMonthNotifier {
  @override
  DateTime build() {
    return DateTime.now();
  }

  void changeMonth(DateTime newValue) {
    state = newValue;
  }
}

@riverpod
class IndexPageNotifer extends _$IndexPageNotifer {
  @override
  int build() {
    return 0;
  }

  void changeValue(int value) {
    state = value;
  }
}

// final selectedMonthProvider = StateProvider<DateTime>((ref) {
//   return DateTime.now();
// });

final monthlyCostByCategoryProvider = FutureProvider.family<
  Map<String, double>,
  Tuple2<String, String>
>((ref, tuple) async {
  final String cardId = tuple.item1;
  final String type = tuple.item2;
  final selectedMonth = ref.watch(selectedMonthNotifierProvider);

  final startOfMonth = DateTime(selectedMonth.year, selectedMonth.month, 1);
  final endOfMonth = DateTime(selectedMonth.year, selectedMonth.month + 1, 1);

  final firestore = FirebaseFirestore.instance;

  final query =
      await firestore
          .collection('users')
          .doc(Global.storageService.getUserId())
          .collection('cards')
          .doc(cardId)
          .collection('transactions')
          .where('type', isEqualTo: type)
          .where('date', isGreaterThanOrEqualTo: startOfMonth)
          .where('date', isLessThan: endOfMonth)
          .get();
  final Map<String, double> totalByCategory = {};
  for (var doc in query.docs) {
    final data = doc.data();
    final category = data['category'];
    final amount = (data['amount'] ?? 0).toDouble();
    totalByCategory[category] = (totalByCategory[category] ?? 0) + amount;
  }
  return totalByCategory;
});

final monthlyCostTotalProvider =
    FutureProvider.family<Map<String, double>, String>((ref, cardId) async {
      final selectedMonth = ref.watch(selectedMonthNotifierProvider);

      final startOfMonth = DateTime(selectedMonth.year, selectedMonth.month, 1);
      final endOfMonth = DateTime(selectedMonth.year, selectedMonth.month + 1);

      final firestore = FirebaseFirestore.instance;

      final queryTrx = await firestore
          .collection('users')
          .doc(Global.storageService.getUserId())
          .collection('cards')
          .doc(cardId)
          .collection('transactions');

      final income =
          await queryTrx
              .where('type', isEqualTo: "income")
              .where('date', isGreaterThanOrEqualTo: startOfMonth)
              .where('date', isLessThan: endOfMonth)
              .get();
      final expense =
          await queryTrx
              .where('type', isEqualTo: "expense")
              .where('date', isGreaterThanOrEqualTo: startOfMonth)
              .where('date', isLessThan: endOfMonth)
              .get();
      double totalIncome = 0;
      for (var doc in income.docs) {
        final data = doc.data();
        totalIncome += (data['amount'] ?? 0).toDouble();
      }
      double totalExpense = 0;
      for (var doc in expense.docs) {
        final data = doc.data();
        totalExpense += (data['amount'] ?? 0).toDouble();
      }
      return {'Income': totalIncome, 'Expense': totalExpense};
    });
