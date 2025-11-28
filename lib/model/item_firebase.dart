import 'dart:convert';

class ItemFirebase {
  final String? id; // Firestore docId
  final String name;
  final int stock;
  final int modal;
  final int price;
  final String? date; // simpan sebagai string yyyy-MM-dd

  ItemFirebase({
    this.id,
    required this.name,
    required this.stock,
    required this.modal,
    required this.price,
    this.date,
  });

  // ----------------------------
  // Convert ke Map untuk Firebase
  // ----------------------------
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'stock': stock,
      'modal': modal,
      'price': price,
      'date': date,
    };
  }

  // ----------------------------
  // Buat Model dari Firebase Document
  // ----------------------------
  factory ItemFirebase.fromMap(String id, Map<String, dynamic> map) {
    return ItemFirebase(
      id: id, // Firestore docId disimpan di sini
      name: map['name'] ?? '',
      stock: map['stock'] ?? 0,
      modal: map['modal'] ?? 0,
      price: map['price'] ?? 0,
      date: map['date'],
    );
  }

  String toJson() => json.encode(toMap());
}
