import 'dart:convert';

class SalesModelFirebase {
  final String? id; // Firestore document ID
  final String itemId; // ID item dari Firestore (string)
  final int quantity;
  final int price;
  final int sales; // total penjualan (price * qty)
  final String date; // simpan sebagai yyyy-MM-dd

  SalesModelFirebase({
    this.id,
    required this.itemId,
    required this.quantity,
    required this.price,
    required this.sales,
    required this.date,
  });

  // ---------------------------
  // Convert ke Map untuk Firebase
  // ---------------------------
  Map<String, dynamic> toMap() {
    return {
      'itemId': itemId,
      'quantity': quantity,
      'price': price,
      'sales': sales,
      'date': date,
    };
  }

  // ---------------------------
  // Buat Model dari Firebase Document
  // ---------------------------
  factory SalesModelFirebase.fromMap(String id, Map<String, dynamic> map) {
    return SalesModelFirebase(
      id: id,
      itemId: map['itemId'] ?? "",
      quantity: map['quantity'] ?? 0,
      price: map['price'] ?? 0,
      sales: map['sales'] ?? 0,
      date: map['date'] ?? "",
    );
  }

  String toJson() => json.encode(toMap());
}
