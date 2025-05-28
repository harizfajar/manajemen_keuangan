import 'package:cloud_firestore/cloud_firestore.dart';

class CardModel {
  final String id;
  final String cardName;
  final double balance;
  final Timestamp? createdAt;

  CardModel({
    this.id = "",
    required this.cardName,
    required this.balance,
    this.createdAt,
  });

  factory CardModel.fromFirestore(DocumentSnapshot doc) {
    final rawData = doc.data();
    if (rawData == null) {
      print("Data kartu kosong");
      return CardModel.empty();
    }

    final data = rawData as Map<String, dynamic>;
    return CardModel(
      id: doc.id,
      cardName: data['cardName'],
      balance: data['balance'],
      createdAt: data['createdAt'],
    );
  }

  static CardModel empty() {
    return CardModel(
      id: "",
      cardName: "",
      balance: 0.0,
      createdAt: Timestamp.now(),
    );
  }

  CardModel copyWith({
    String? id,
    String? cardName,
    double? balance,
    Timestamp? createdAt,
  }) {
    return CardModel(
      id: id ?? this.id,
      cardName: cardName ?? this.cardName,
      balance: balance ?? this.balance,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
