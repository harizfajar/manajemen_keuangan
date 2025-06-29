import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duitKu/common/utils/constans.dart';
import 'package:duitKu/global.dart';

class FirebaseService {
  Future<void> addUser({String? userId, String? name, String? email}) async {
    await FirebaseFirestore.instance.collection('users').doc(userId).set({
      'name': name,
      'email': email,
      'createdAt': Timestamp.now(),
    });

    print("User berhasil ditambahkan!");
  }

  Future<void> addCard({
    String? userId,
    String? cardName,
    double? balance,
  }) async {
    CollectionReference cardsRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('cards');

    await cardsRef.add({
      'cardName': cardName,
      'balance': balance,
      'createdAt': Timestamp.now(),
    });

    print("Kartu berhasil ditambahkan!");
  }

  Future<void> addTransaction({
    String? userId,
    String? cardId,
    double? amount,
    String? category,
    String? description,
    String? type,
  }) async {
    CollectionReference transactionsRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('cards')
        .doc(cardId)
        .collection('transactions');

    await transactionsRef.add({
      'amount': amount,
      'category': category,
      'description': description,
      'type': type, // "expense" atau "income"
      'date': Timestamp.now(),
      'createAt': Timestamp.now(),
    });

    print("Transaksi berhasil ditambahkan!");
  }

  Stream<QuerySnapshot> getCards(String userId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('cards')
        .snapshots();
  }

  Future<QuerySnapshot> totalCards(String userId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('cards')
        .get();
  }

  Stream<QuerySnapshot> getTransactions(String userId, String cardId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('cards')
        .doc(cardId)
        .collection('transactions')
        .orderBy('date', descending: true)
        .snapshots();
  }

  Future<Map<String, dynamic>?> getTransactionById({
    required String userId,
    required String cardId,
    required String transactionId,
  }) async {
    final doc =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('cards')
            .doc(cardId)
            .collection('transactions')
            .doc(transactionId)
            .get();

    if (doc.exists) {
      return doc.data(); // langsung return data
    } else {
      return null; // kalau dokumen tidak ada
    }
  }

  // 🔹 Ambil saldo kartu dari Firestore
  Future<double> getCardBalance(String userId, String cardId) async {
    DocumentSnapshot doc =
        await FirebaseFirestore.instance
            .collection("users")
            .doc(userId)
            .collection("cards")
            .doc(cardId)
            .get();

    return ((doc.data() as Map<String, dynamic>?)?["balance"] ?? 0).toDouble();
  }

  Future<void> updateCard({
    String? userId,
    String? cardId,
    String? cardName,
    double? balance,
    String? transactionId,
  }) async {
    final cardRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('cards')
        .doc(cardId);
    await cardRef.update({'cardName': cardName, 'balance': balance});

    final transactionRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('cards')
        .doc(cardId)
        .collection('transactions')
        .doc(transactionId);

    await transactionRef.update({
      'amount': balance,
      'type': "income",
      'description': "Saldo Awal",
      'category': "Gaji",
      'date': Timestamp.now(),
      'updateAt': Timestamp.now(),
    });
  }

  Future<void> updateCardBalance(
    String userId,
    String cardId,
    double amount,
  ) async {
    final cardRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('cards')
        .doc(cardId);
    final snapshot = await cardRef.get();
    if (snapshot.exists) {
      final currentBalance = snapshot.data()?['balance'] ?? 0.0;
      await cardRef.update({'balance': currentBalance + amount});
    }
    print("Saldo kartu berhasil diperbarui!");
  }

  Future<void> updateCardBalanceTransaksi({
    String? userId,
    String? cardId,
    double? updatedBalance,
  }) async {
    final cardRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('cards')
        .doc(cardId);
    final snapshot = await cardRef.get();
    if (snapshot.exists) {
      await cardRef.update({'balance': updatedBalance});
    }
    print("Saldo kartu berhasil diperbarui!");
  }

  Future<void> updateTransaction({
    required String userId,
    required String cardId,
    required String transactionId,
    required double newAmount,
    required String category,
    required String description,
    required String newType, // income / expense
    required Timestamp date,
  }) async {
    final transactionRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('cards')
        .doc(cardId)
        .collection('transactions')
        .doc(transactionId);

    final trxSnapshot = await transactionRef.get();

    if (trxSnapshot.exists) {
      final data = trxSnapshot.data();
      final oldAmount = (data?['amount'] ?? 0.0);
      final oldType = data?['type'];

      // 🔁 Update data transaksi
      await transactionRef.update({
        'amount': newAmount,
        'type': newType,
        'description': description,
        'category': category,
        'date': date,
        'updateAt': Timestamp.now(),
      });

      //  Hitung perubahan pada saldo
      double balanceChange = 0.0;

      if (oldType == newType) {
        // 🔹 Kalau tipe transaksi tidak berubah (income  income atau expense expense)
        if (newType == 'income') {
          balanceChange = newAmount - oldAmount;
        } else if (newType == 'expense') {
          balanceChange = oldAmount - newAmount;
        }
      } else {
        //  Kalau tipe transaksi berubah (income ke expense)
        if (oldType == 'income' && newType == 'expense') {
          balanceChange = -oldAmount - newAmount;
        } else if (oldType == 'expense' && newType == 'income') {
          balanceChange = oldAmount + newAmount;
        }
      }

      // 💰 Update saldo kartu
      await updateCardBalance(userId, cardId, balanceChange);

      print("Transaksi berhasil diperbarui!");
    } else {
      print(" Transaksi tidak ditemukan!");
    }
  }

  Future<void> deleteCard(String userId, String cardId) async {
    final cardRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('cards')
        .doc(cardId);

    final transactionsRef = cardRef.collection('transactions');
    final transactionsSnapshot = await transactionsRef.get();

    for (final doc in transactionsSnapshot.docs) {
      await transactionsRef.doc(doc.id).delete();
    }

    await cardRef.delete();

    print("Kartu dan transaksi berhasil dihapus!");
  }

  Future<void> deleteTransaction(
    String userId,
    String cardId,
    String transactionId,
  ) async {
    final transactionRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('cards')
        .doc(cardId)
        .collection('transactions')
        .doc(transactionId);

    final transactionSnapshot = await transactionRef.get();
    if (transactionSnapshot.exists) {
      final data = transactionSnapshot.data();
      final type = data?['type'];
      final amount = data?['amount'] ?? 0.0;
      await transactionRef.delete();

      if (type == 'income') {
        // Jika transaksi adalah pemasukan, kurangi saldo kartu
        await updateCardBalance(userId, cardId, -amount);
      } else if (type == 'expense') {
        // Jika transaksi adalah pengeluaran, tambahkan saldo kartu
        await updateCardBalance(userId, cardId, amount);
      }
    }
    print("Transaksi berhasil dihapus!!!");
  }

  // Cek apakah user punya kartu di Firestore
  Future<bool> checkUserHasCards(String userId) async {
    var cardsSnapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('cards')
            .get();

    bool hasCards = cardsSnapshot.docs.isNotEmpty;
    // Simpan status hasCards ke storage agar bisa digunakan kembali
    Global.storageService.setBool(AppConstants.STORAGE_DEVICE_SETUP, hasCards);
    return hasCards;
  }

  Future<String?> getFirstCardId({String? userId}) async {
    final cardSnapsot =
        await FirebaseFirestore.instance
            .collection("users")
            .doc(userId)
            .collection('cards')
            .orderBy('createdAt', descending: true)
            .limit(1)
            .get();

    if (cardSnapsot.docs.isNotEmpty) {
      return cardSnapsot.docs.first.id;
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>?> getLatestTrx({
    String? userId,
    String? cardId,
  }) async {
    try {
      final snapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .collection('cards')
              .doc(cardId)
              .collection('transactions')
              .orderBy(
                'createAt',
                descending: false,
              ) // urut dari yang paling lama
              .limit(1)
              .get();

      if (snapshot.docs.isNotEmpty) {
        final doc = snapshot.docs.first;
        print("Oldest transaction ID: ${doc.id}");
        return {'id': doc.id, 'data': doc.data()};
      } else {
        print("Tidak ada transaksi ditemukan.");
        return null;
      }
    } catch (e) {
      print("Error mengambil transaksi tertua: $e");
      return null;
    }
  }
}
