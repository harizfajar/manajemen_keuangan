// import 'package:cloud_firestore/cloud_firestore.dart';

// class TransactionModel {
//   final String id;
//   final double amount;
//   final String category;
//   final String description;
//   final String type; // "income" atau "expense"
//   final Timestamp date;

//   TransactionModel({
//     required this.id,
//     required this.amount,
//     required this.category,
//     required this.description,
//     required this.type,
//     required this.date,
//   });

//   factory TransactionModel.fromFirestore(DocumentSnapshot doc) {
//     final data = doc.data() as Map<String, dynamic>;
//     return TransactionModel(
//       id: doc.id,
//       amount: data['amount'].toDouble(),
//       category: data['category'],
//       description: data['description'],
//       type: data['type'], // harus "income" atau "expense"
//       date: data['date'],
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel {
  final String id;
  final String description;
  final double amount;
  final String type; // "income" atau "expense"
  final String category;
  final Timestamp date;

  TransactionModel({
    this.id = "",
    this.description = "",
    this.amount = 0,
    this.type = "",
    this.category = "",
    Timestamp? date,
  }) : date = date ?? Timestamp.now();

  TransactionModel copyWith({
    final String? id,
    final String? description,
    final double? amount,
    final String? type, // "income" atau "expense"
    final String? category,
    final Timestamp? date,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      category: category ?? this.category,
      date: date ?? this.date,
    );
  }

  factory TransactionModel.fromMap(Map<String, dynamic> data) {
    return TransactionModel(
      amount: (data['amount'] ?? 0).toDouble(),
      category: data['category'] ?? 'Uncategorized',
      date: data['date'] as Timestamp,
    );
  }

  // Konversi dari Firestore ke Model
  factory TransactionModel.fromFirestore(DocumentSnapshot doc) {
    final rawData = doc.data();
    if (rawData == null) {
      print("Data transaksi kosong");
      return TransactionModel.empty();
    }

    final data = rawData as Map<String, dynamic>;

    return TransactionModel(
      id: doc.id,
      description: data['description'],
      amount: data['amount'],
      type: data['type'],
      category: data['category'],
      date: data['date'],
    );
  }
  static TransactionModel empty() {
    return TransactionModel(
      id: '',
      amount: 0.0,
      category: '',
      description: '',
      type: '',
      date: Timestamp.now(),
    );
  }

  // Konversi dari Model ke Firestore
  // Map<String, dynamic> toFirestore() {
  //   return {
  //     'description': description,
  //     'amount': amount,
  //     'type': type,
  //     'category': category,
  //     'date': date,
  //   };
  // }
}
