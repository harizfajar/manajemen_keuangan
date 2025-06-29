import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duitKu/common/routes/app_routes_name.dart';
import 'package:duitKu/common/services/firebase.dart';
import 'package:duitKu/pages/beranda/notifier/beranda_notifier.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:duitKu/common/model/cards.dart';
import 'package:duitKu/common/services/firebase.dart';
import 'package:duitKu/common/widgets/popup_messages.dart';
import 'package:duitKu/global.dart';
import 'package:duitKu/main.dart';
import 'package:duitKu/pages/Card/notifier/cards_notifier.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'card_notifier.g.dart';

@riverpod
class CardNotifier extends _$CardNotifier {
  @override
  CardModel build() {
    return CardModel.empty();
  }

  void changeName(String newvalue) {
    state = state.copyWith(cardName: newvalue);
  }

  void changeSaldo(double newvalue) {
    state = state.copyWith(balance: newvalue);
  }

  Future<bool> cekInternet() async {
    final result = await InternetConnectionChecker().hasConnection;
    result ? print("Ada internet") : print(" Tidak Ada Internet");
    return result;
  }

  final firebase = FirebaseService();

  Future<void> addCard() async {
    String nama = state.cardName;
    double saldo = state.balance;

    if (nama.length > 8 || nama.length < 3) {
      toastInfo("Nama Kartu Minimal 3 Karakter dan Maksimal 8 Karakter");
      return;
    }
    if (saldo < 0) {
      toastInfo("Saldo Kurang dari 0");
      return;
    }
    bool connected = await cekInternet();
    if (!connected) {
      toastInfo("Tidak ada koneksi internet.");
      return;
    }
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String userId = user.uid;
        print("user id : $userId");
        firebase.addCard(userId: userId, cardName: nama, balance: saldo);
        navKey.currentState!.pushNamedAndRemoveUntil(
          AppRoutesName.APPLICATION,
          (route) => false,
        );
        String? firstCardId = await firebase.getFirstCardId(userId: userId);

        firebase.addTransaction(
          amount: saldo,
          userId: userId,
          cardId: firstCardId,
          description: "Saldo Awal",
          category: "Gaji",
          type: "income",
        );
        toastInfo(
          "Kartu Berhasil Dibuat",
          bgColor: Colors.blueAccent,
          icon: Icons.check_circle,
        );
        ref
            .read(selectedCardProvider.notifier)
            .setFirstCardAfterLogin(Global.storageService.getUserId());
      } else {
        print("gagal setup card");
      }
    } catch (e) {
      print("Error setup card: $e");
    }
  }

  void updateCard({String? nama, double? saldo, String? cardId}) async {
    final conection = await cekInternet();
    if (!conection) {
      toastInfo("Tidak ada koneksi internet.");
      return;
    }
    try {
      User? user = FirebaseAuth.instance.currentUser;
      String userId = user!.uid;
      print("user id : $userId");

      final firstTrxId = await firebase.getLatestTrx(
        userId: userId,
        cardId: cardId,
      );
      print("idtrx awal $firstTrxId");
      print("cardId $cardId");
      if (firstTrxId != null) {
        String idTrx = firstTrxId['id'];
        Map<String, dynamic> trxData = firstTrxId['data'];
        print("ID: trx awal $idTrx");
        print("Data: $trxData");
        firebase.updateCard(
          userId: userId,
          cardId: cardId,
          cardName: nama,
          balance: saldo,
          transactionId: idTrx,
        );
      }
      ref.invalidate(monthlyCostByCategoryProvider);
      ref.invalidate(monthlyCostTotalProvider);

      navKey.currentState!.pop();

      toastInfo(
        "Kartu Berhasil Diubah",
        bgColor: Colors.blueAccent,
        icon: Icons.check_circle,
      );
    } catch (e) {
      print("Error setup card: $e");
    }
  }

  void deleteCard({
    String? cardName,
    required String cardId,
    required String userId,
  }) async {
    bool connected = await cekInternet();
    if (!connected) {
      toastInfo("Tidak ada koneksi internet.");
      navKey.currentState!.pop();
      return;
    }
    final firebase = FirebaseService();
    await firebase.deleteCard(userId, cardId);
    // Tutup dialog dulu
    navKey.currentState!.pop();
    toastInfo(
      "Kartu $cardName Berhasil dihapus",
      bgColor: Colors.blue,
      icon: Icons.check_circle,
    );
    // Ambil semua kartu yang tersisa
    final totalCards = await firebase.totalCards(userId);
    print("total kartu ${totalCards.docs.length}");
    if (totalCards.docs.isEmpty) {
      // Jika tidak ada kartu tersisa, arahkan ke halaman setup kartu
      navKey.currentState!.pushNamedAndRemoveUntil("/setup", (route) => false);
    } else {
      // Kalau masih ada kartu, atur salah satu sebagai selected
      ref.read(selectedCardProvider.notifier).setFirstCardAfterLogin(userId);
    }
  }
}
