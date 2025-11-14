// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class SalesModel {
  int? id;
  int itemId;
  int quantity;
  int price;
  int? sales;
  String? date;

  SalesModel({
    this.id,
    required this.itemId,
    required this.quantity,
    required this.price,
    this.sales,
    this.date,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'item_id': itemId,
      'quantity': quantity,
      'price': price,
      'sales': sales,
      'date': date,
    };
  }

  factory SalesModel.fromMap(Map<String, dynamic> map) {
    return SalesModel(
      id: map['id'] != null ? map['id'] as int : null,
      itemId: map['item_id'] as int,
      quantity: map['quantity'] as int,
      price: map['price'] as int,
      sales: map['sales'] != null ? map['sales'] as int : null,
      date: map['date'] != null ? map['date'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SalesModel.fromJson(String source) =>
      SalesModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
