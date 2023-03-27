import 'package:cloud_firestore/cloud_firestore.dart';

class Inventory {
  final String title;
  final String quantity;
  final String price;
  final String totalValue;
  final String note;
  final String imageUrl;
  final String updatedAt;

  Inventory({
    required this.title,
    required this.quantity,
    required this.price,
    required this.totalValue,
    required this.note,
    required this.imageUrl,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'quantity': quantity,
      'price': price,
      'totalValue': totalValue,
      'note': note,
      'imageUrl': imageUrl,
      'updatedAt': updatedAt
    };
  }

  factory Inventory.fromQuerySnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> map) {
    return Inventory(
        title: map['title'],
        quantity: map['quantity'],
        price: map['price'],
        totalValue: map['totalValue'],
        note: map['note'],
        imageUrl: map['imageUrl'],
        updatedAt: map['updatedAt']);
  }

  factory Inventory.fromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> map) {
    return Inventory(
        title: map['title'],
        quantity: map['quantity'],
        price: map['price'],
        totalValue: map['totalValue'],
        note: map['note'],
        imageUrl: map['imageUrl'],
        updatedAt: map['updatedAt']);
  }
}
