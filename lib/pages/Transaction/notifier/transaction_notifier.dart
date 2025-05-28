import 'dart:async';
import 'package:duitKu/common/services/firebase.dart';
import 'package:duitKu/common/widgets/popup_messages.dart';
import 'package:duitKu/global.dart';
import 'package:duitKu/main.dart';
import 'package:duitKu/pages/beranda/notifier/beranda_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duitKu/common/model/transactions.dart';
import 'package:duitKu/pages/Card/notifier/cards_notifier.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timezone/timezone.dart' as tz;
part 'transaction_notifier.g.dart';

@riverpod
class TransactionNotifier extends _$TransactionNotifier {
  @override
  AsyncValue<TransactionModel> build() => AsyncValue.data(TransactionModel());

  List<String> categories = [
    'Makanan',
    'Transportasi',
    'Hiburan',
    'Belanja',
    'Gaji',
    'Lainnya',
  ];
  List<String> types = ['expense', 'income'];

  String selectedType = 'expense';
  String selectedCategory = 'Makanan';
  DateTime selectedDateTime = DateTime.now();

  void changeDescription(String deskripsi) {
    state = state.whenData((data) => data.copyWith(description: deskripsi));
  }

  void changeAmount(double amount) {
    state = state.whenData((data) => data.copyWith(amount: amount));
  }

  void changeCategory(String category) {
    selectedCategory = category;
    state = state.whenData((data) => data.copyWith(category: category));
  }

  void changeType(String type) {
    selectedType = type;
    state = state.whenData((data) => data.copyWith(type: type));
  }

  void changeDateTime(DateTime newDateTime) {
    selectedDateTime = newDateTime;
    state = state.whenData(
      (data) => data.copyWith(date: Timestamp.fromDate(newDateTime)),
    );
  }

  // Fungsi untuk memeriksa koneksi internet tanpa plugin tambahan
  Future<bool> cekInternet() async {
    bool result = await InternetConnectionChecker().hasConnection;
    if (!result) {
      print("Tidak ada koneksi internet");
    }
    return result;
  }

  void addTransaction({
    required String cardId,
    required String description,
    required String amountController,
  }) async {
    if (state.isLoading) return;

    state = const AsyncValue.loading();
    bool isConnected = await cekInternet();
    if (!isConnected) {
      toastInfo("Tidak ada koneksi internet.");
      state = AsyncValue.data(TransactionModel()); // Kembalikan state normal
      return;
    }
    try {
      final firebase = FirebaseService();
      final userId = Global.storageService.getUserId();
      final double transactionAmount = double.parse(amountController);
      final double currentBalance = await firebase.getCardBalance(
        userId,
        cardId,
      );

      if (transactionAmount < 0) {
        toastInfo("Jumlah tidak boleh negatif");
        state = AsyncValue.data(TransactionModel());
        return;
      }

      if (selectedType == "expense" && currentBalance < transactionAmount) {
        toastInfo("Saldo tidak cukup!");
        state = AsyncValue.data(TransactionModel()); // reset state
        return;
      }

      await firebase.addTransaction(
        userId: userId,
        cardId: cardId,
        amount: transactionAmount,
        category: selectedCategory,
        description: description,
        type: selectedType,
      );

      final double updatedBalance =
          selectedType == "income"
              ? currentBalance + transactionAmount
              : currentBalance - transactionAmount;

      await firebase.updateCardBalanceTransaksi(
        userId: userId,
        cardId: cardId,
        updatedBalance: updatedBalance,
      );
      ref.invalidate(monthlyCostTotalProvider);
      ref.invalidate(monthlyCostByCategoryProvider);
      navKey.currentState!.pop();
      toastInfo(
        "Transaksi berhasil ditambahkan!",
        bgColor: Colors.blue,
        icon: Icons.check_circle,
      );

      state = AsyncValue.data(TransactionModel()); // reset state
    } catch (e, st) {
      toastInfo("Terjadi kesalahan: $e");
      state = AsyncValue.error(e, st); // reset state
    }
  }

  Future<void> editTransaction({
    required String cardId,
    required String transactionId,
    String? amountC,
    String? description,
  }) async {
    if (state.isLoading) return;

    state = const AsyncValue.loading();
    bool isConnected = await cekInternet();
    if (!isConnected) {
      toastInfo("Tidak ada koneksi internet.");
      state = AsyncValue.data(TransactionModel()); // Kembalikan state normal
      return;
    }
    try {
      final userId = Global.storageService.getUserId();
      final firebase = FirebaseService();
      double currentBalance = await firebase.getCardBalance(userId, cardId);

      String cleaned = amountC!.replaceAll('.', '');
      double amount = double.parse(cleaned);
      if (amount < 0) {
        toastInfo("Jumlah tidak boleh negatif");
        state = AsyncValue.data(TransactionModel());
        return;
      }

      final oldTransaction = await firebase.getTransactionById(
        userId: userId,
        cardId: cardId,
        transactionId: transactionId,
      );

      // Ambil nilai sebelumnya
      if (oldTransaction == null) {
        toastInfo("Data transaksi lama tidak ditemukan.");
        state = AsyncValue.data(TransactionModel());
        return;
      }

      final double oldAmount = oldTransaction['amount'] ?? 0.toDouble();
      final String oldType = oldTransaction['type'] ?? 'expense';

      // 1. Pulihkan dampak transaksi lama
      if (oldType == 'income') {
        currentBalance -= oldAmount;
      } else {
        currentBalance += oldAmount;
      }

      // 2. Hitung dampak transaksi baru
      if (selectedType == 'expense' && currentBalance < amount) {
        toastInfo("Saldo tidak cukup.");
        state = AsyncValue.data(TransactionModel());
        return;
      }
      await firebase.updateTransaction(
        userId: userId,
        cardId: cardId,
        transactionId: transactionId,
        description: description!,
        newAmount: amount,
        category: selectedCategory,
        newType: selectedType,
        date: Timestamp.fromDate(selectedDateTime),
      );
      ref.invalidate(monthlyCostByCategoryProvider); // refresh data
      ref.invalidate(monthlyCostTotalProvider);
      navKey.currentState!.pop();
      toastInfo(
        "Transaksi berhasil diubah!",
        bgColor: Colors.blue,
        icon: Icons.check_circle,
      );
      state = AsyncValue.data(TransactionModel()); // reset state
    } catch (e, st) {
      toastInfo("Terjadi kesalahan: $e");
      state = AsyncValue.error(e, st); // reset state
    }
  }

  Future<void> deleteTransaction({required TransactionModel data}) async {
    if (state.isLoading) {
      return;
    }

    state = const AsyncValue.loading();
    bool isConnected = await cekInternet();
    if (!isConnected) {
      toastInfo("Tidak ada koneksi internet.");
      state = AsyncValue.data(TransactionModel()); // Kembalikan state normal
      navKey.currentState!.pop();
      return;
    }
    try {
      final firebase = FirebaseService();
      final cardId = ref.watch(selectedCardProvider);
      final userId = Global.storageService.getUserId();

      await firebase.deleteTransaction(userId, cardId!, data.id);
      ref.invalidate(monthlyCostByCategoryProvider); // refresh data
      ref.invalidate(monthlyCostTotalProvider); // refresh data

      navKey.currentState!.pop();
      toastInfo(
        "Transaksi berhasil dihapus!",
        bgColor: Colors.blue,
        icon: Icons.check_circle,
      );
      state = AsyncValue.data(TransactionModel()); // reset
    } catch (e, st) {
      toastInfo("Gagal menghapus transaksi: $e");
      state = AsyncValue.error(e, st);
    }
  }
}

// Provider untuk transaksi
final transactionProvider =
    StreamProvider.family<List<TransactionModel>, String>((ref, cardId) {
      final filtered = ref.watch(transactionFilterNotifierProvider);

      Query query = FirebaseFirestore.instance
          .collection('users')
          .doc(Global.storageService.getUserId()) // Ganti dengan UID user
          .collection('cards')
          .doc(cardId)
          .collection('transactions')
          .orderBy("date", descending: filtered.date == Date.terbaru);
      if (filtered.category != null && filtered.category != 'Semua Kategori') {
        query = query.where("category", isEqualTo: filtered.category);
      }
      if (filtered.type != FilterType.all) {
        query = query.where("type", isEqualTo: filtered.type.name);
      }

      if (filtered.descriptionQuery != null) {
        query = query.where(
          "description",
          isEqualTo: filtered.descriptionQuery!.trim(),
        );
      }
      return query.snapshots().map((snapshot) {
        if (snapshot.docs.isEmpty) return <TransactionModel>[];
        return snapshot.docs
            .map((doc) => TransactionModel.fromFirestore(doc))
            .toList();
      });
    });

// Provider total pemasukan
final totalIncomeProvider = Provider.family<double, String>((ref, cardId) {
  final transactions =
      ref.watch(transactionProvider(cardId)).asData?.value ?? [];
  return transactions
      .where((data) => data.type == "income")
      .fold(0.0, (total, data) => total + data.amount);
});

// Provider total pengeluaran
final totalExpenseProvider = Provider.family<double, String>((ref, cardId) {
  final transactions =
      ref.watch(transactionProvider(cardId)).asData?.value ?? [];
  return transactions
      .where((data) => data.type == "expense")
      .fold(0.0, (total, data) => total + data.amount);
});

// Provider total saldo akhir
final totalBalanceProvider = Provider.family<double, String>((ref, cardId) {
  final card = ref.watch(cardProvider(cardId)).asData?.value;
  final totalIncome = ref.watch(totalIncomeProvider(cardId));
  final totalExpense = ref.watch(totalExpenseProvider(cardId));

  if (card == null) return 0.0; // Jika data kartu belum tersedia

  return card.balance + (totalIncome - totalExpense);
});

// Provider transaksi harian
final dailyTransactionProvider =
    Provider.family<List<TransactionModel>, String>((ref, cardId) {
      final transactions =
          ref.watch(transactionProvider(cardId)).asData?.value ?? [];
      final today = tz.TZDateTime.now(tz.local);
      return transactions.where((data) {
        final dataDate = data.date.toDate();
        return dataDate.year == today.year &&
            dataDate.month == today.month &&
            dataDate.day == today.day;
      }).toList();
    });

// Provider transaksi mingguan
final weeklyTransactionProvider =
    Provider.family<List<TransactionModel>, String>((ref, cardId) {
      final transactions =
          ref.watch(transactionProvider(cardId)).asData?.value ?? [];
      final today = tz.TZDateTime.now(tz.local);
      final startOfWeek = tz.TZDateTime(
        tz.local,
        today.year,
        today.month,
        today.day - (today.weekday - 1),
      );

      return transactions.where((data) {
        final dataDate = data.date.toDate();
        return dataDate.isAfter(startOfWeek.subtract(Duration(days: 1))) &&
            dataDate.isBefore(today.add(Duration(days: 1)));
      }).toList();
    });

// Provider transaksi bulanan
final monthlyTransactionProvider =
    Provider.family<List<TransactionModel>, String>((ref, cardId) {
      final transactions =
          ref.watch(transactionProvider(cardId)).asData?.value ?? [];
      final today = DateTime.now();

      return transactions.where((data) {
        final dataDate = data.date.toDate();
        return dataDate.year == today.year && dataDate.month == today.month;
      }).toList();
    });

// Provider transaksi seumur hidup (lifetime)
final lifetimeTransactionProvider =
    Provider.family<List<TransactionModel>, String>((ref, cardId) {
      final transactions =
          ref.watch(transactionProvider(cardId)).asData?.value ?? [];

      return transactions; // Mengembalikan semua transaksi tanpa filter tanggal
    });

// Provider Income Harian
final dailyIncomeProvider = Provider.family<double, String>((ref, cardId) {
  final transactions =
      ref.watch(transactionProvider(cardId)).asData?.value ?? [];
  final today = DateTime.now();

  return transactions
      .where(
        (tx) =>
            tx.type == "income" &&
            tx.date.toDate().year == today.year &&
            tx.date.toDate().month == today.month &&
            tx.date.toDate().day == today.day,
      )
      .fold(0.0, (total, tx) => total + tx.amount);
});

// Provider Income Mingguan
final weeklyIncomeProvider = Provider.family<double, String>((ref, cardId) {
  final transactions =
      ref.watch(transactionProvider(cardId)).asData?.value ?? [];
  final today = DateTime.now();
  final startOfWeek = today.subtract(Duration(days: today.weekday - 1));

  return transactions
      .where(
        (tx) =>
            tx.type == "income" &&
            tx.date.toDate().isAfter(startOfWeek.subtract(Duration(days: 1))) &&
            tx.date.toDate().isBefore(today.add(Duration(days: 1))),
      )
      .fold(0.0, (total, tx) => total + tx.amount);
});

// Provider Income Bulanan
final monthlyIncomeProvider = Provider.family<double, String>((ref, cardId) {
  final transactions =
      ref.watch(transactionProvider(cardId)).asData?.value ?? [];
  final today = DateTime.now();
  return transactions
      .where(
        (tx) =>
            tx.type == "income" &&
            tx.date.toDate().year == today.year &&
            tx.date.toDate().month == today.month,
      )
      .fold(0.0, (total, tx) => total + tx.amount);
});

// Provider Income Seumur Hidup
final lifetimeIncomeProvider = Provider.family<double, String>((ref, cardId) {
  final transactions =
      ref.watch(transactionProvider(cardId)).asData?.value ?? [];

  return transactions
      .where((tx) => tx.type == "income")
      .fold(0.0, (total, tx) => total + tx.amount);
});

// Provider Expense Harian
final dailyExpenseProvider = Provider.family<double, String>((ref, cardId) {
  final transactions =
      ref.watch(transactionProvider(cardId)).asData?.value ?? [];
  final today = DateTime.now();

  return transactions
      .where(
        (tx) =>
            tx.type == "expense" &&
            tx.date.toDate().year == today.year &&
            tx.date.toDate().month == today.month &&
            tx.date.toDate().day == today.day,
      )
      .fold(0.0, (total, tx) => total + tx.amount);
});

// Provider Expense Mingguan
final weeklyExpenseProvider = Provider.family<double, String>((ref, cardId) {
  final transactions =
      ref.watch(transactionProvider(cardId)).asData?.value ?? [];
  final today = DateTime.now();
  final startOfWeek = today.subtract(Duration(days: today.weekday - 1));

  return transactions
      .where(
        (tx) =>
            tx.type == "expense" &&
            tx.date.toDate().isAfter(startOfWeek.subtract(Duration(days: 1))) &&
            tx.date.toDate().isBefore(today.add(Duration(days: 1))),
      )
      .fold(0.0, (total, tx) => total + tx.amount);
});

// Provider Expense Bulanan
final monthlyExpenseProvider = Provider.family<double, String>((ref, cardId) {
  final transactions =
      ref.watch(transactionProvider(cardId)).asData?.value ?? [];
  final today = DateTime.now();

  return transactions
      .where(
        (tx) =>
            tx.type == "expense" &&
            tx.date.toDate().year == today.year &&
            tx.date.toDate().month == today.month,
      )
      .fold(0.0, (total, tx) => total + tx.amount);
});

// Provider Expense Seumur Hidup
final lifetimeExpenseProvider = Provider.family<double, String>((ref, cardId) {
  final transactions =
      ref.watch(transactionProvider(cardId)).asData?.value ?? [];

  return transactions
      .where((tx) => tx.type == "expense")
      .fold(0.0, (total, tx) => total + tx.amount);
});

enum Date { terbaru, terlama }

enum FilterType { all, income, expense }

List<String> categoriesFilter = [
  'Makanan',
  'Transportasi',
  'Hiburan',
  'Belanja',
  'Gaji',
  'Lainnya',
  'Semua Kategori',
];
final selectedKategoriFilter = "Semua Kategori";

class TransactionFilter {
  late FilterType type;
  late String? category;
  late Date date;
  late String? descriptionQuery;

  TransactionFilter({
    this.type = FilterType.all,
    this.category,
    this.date = Date.terbaru,
    this.descriptionQuery,
  });

  TransactionFilter copyWith({
    FilterType? type,
    String? category,
    Date? date,
    String? descriptionQuery,
  }) {
    return TransactionFilter(
      type: type ?? this.type,
      category: category ?? this.category,
      date: date ?? this.date,
      descriptionQuery: descriptionQuery ?? null,
    );
  }
}

final filteredTransactionProvider = Provider.family<
  List<TransactionModel>,
  (String cardId, TransactionFilter filter)
>((ref, input) {
  final (cardId, filter) = input;
  final transactions =
      ref.watch(transactionProvider(cardId)).asData?.value ?? [];

  List<TransactionModel> filtered = [...transactions];

  // Filter berdasarkan tipe
  if (filter.type == FilterType.all) {
    filtered = filtered.where((data) => data.type == filter.type.name).toList();
  }

  // Filter berdasarkan kategori jika ada
  if (filter.category != null && filter.category != 'Semua Kategori') {
    filtered =
        filtered.where((data) => data.category == filter.category).toList();
  }

  // Filter berdasarkan deskripsi jika ada query
  final query = filter.descriptionQuery?.trim();
  if (query != null && query.isNotEmpty) {
    filtered =
        filtered
            .where(
              (tx) =>
                  tx.description.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
  }

  // Sorting
  switch (filter.date) {
    case Date.terbaru:
      filtered.sort((a, b) => a.date.compareTo(b.date));
      break;
    case Date.terlama:
      filtered.sort((a, b) => a.date.compareTo(b.date));
      break;
  }

  return filtered;
});

@riverpod
class TransactionFilterNotifier extends _$TransactionFilterNotifier {
  @override
  TransactionFilter build() {
    return TransactionFilter(
      type: FilterType.all,
      category: "Semua Kategori",
      date: Date.terbaru,
      descriptionQuery: null,
    );
  }

  void setType(FilterType type) {
    state = state.copyWith(type: type);
  }

  void setCategory(String? category) {
    state = state.copyWith(category: category);
  }

  void setDate(Date date) {
    state = state.copyWith(date: date);
  }

  void setDescriptionQuery(String? query) {
    state = state.copyWith(descriptionQuery: query);
  }

  void resetFilter() {
    state = TransactionFilter(
      type: FilterType.all,
      category: "Semua Kategori",
      date: Date.terbaru,
      descriptionQuery: null,
    );
  }

  void setFilter({
    final FilterType? type,
    final String? category,
    final Date? date,
    final String? descriptionQuery,
  }) {
    state = state.copyWith(
      type: type ?? state.type,
      category: category ?? state.category,
      date: date ?? state.date,
      descriptionQuery: descriptionQuery ?? null,
    );
  }
}
