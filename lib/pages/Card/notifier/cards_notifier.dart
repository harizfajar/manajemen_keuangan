import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duitKu/common/model/cards.dart';
import 'package:duitKu/common/services/storage.dart';
import 'package:duitKu/common/utils/constans.dart';
import 'package:duitKu/global.dart';

// Provider untuk mendapatkan daftar kartu dari user tertentu
final cardsProvider = StreamProvider.family<List<CardModel>, String>((
  ref,
  userId,
) {
  return FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('cards')
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map(
        (snapshot) =>
            snapshot.docs.map((doc) => CardModel.fromFirestore(doc)).toList(),
      );
});
// Provider untuk mendapatkan informasi kartu
final cardProvider = StreamProvider.family<CardModel, String>((ref, cardId) {
  final userId = Global.storageService.getUserId();

  return FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('cards')
      .doc(cardId)
      .snapshots()
      .map((snapshot) => CardModel.fromFirestore(snapshot));
});

class SelectedCardNotifier extends StateNotifier<String?> {
  SelectedCardNotifier() : super(null) {
    _loadSelectedCard();
  }

  final StorageService storage = Global.storageService;

  Future<void> _loadSelectedCard() async {
    state = storage.getCard();
  }

  Future<void> selectCard(String cardId) async {
    state = cardId;
    await storage.setString(key: AppConstants.STORAGE_CARDS_KEY, value: cardId);
  }

  Future<void> resetToFirstCard(String firstCardId) async {
    state = firstCardId;
    await storage.setString(
      key: AppConstants.STORAGE_CARDS_KEY,
      value: firstCardId,
    );
  }

  Future<void> setFirstCardAfterLogin(String userId) async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance
              .collection("users")
              .doc(userId)
              .collection("cards")
              .orderBy('createdAt', descending: true)
              .limit(1)
              .get();

      if (snapshot.docs.isNotEmpty) {
        String firstCardId = snapshot.docs.first.id;
        state = firstCardId;
        await storage.setString(
          key: AppConstants.STORAGE_CARDS_KEY,
          value: firstCardId,
        );
        print(" Kartu pertama setelah login: $firstCardId");
      } else {
        print(" Tidak ada kartu yang tersedia untuk user ini.");
        state = null;
        await storage.remove(AppConstants.STORAGE_CARDS_KEY);
      }
    } catch (e) {
      print(" Error saat mengatur kartu pertama setelah login: $e");
    }
  }
}

final selectedCardProvider =
    StateNotifierProvider<SelectedCardNotifier, String?>(
      (ref) => SelectedCardNotifier(),
    );
