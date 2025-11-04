import 'dart:convert';

class SalesModel {
  int? id;
  String name;
  int quantity;
  int price;

  SalesModel({
    this.id,
    required this.name,
    required this.quantity,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'quantity': quantity,
      'price': price,
    };
  }

  factory SalesModel.fromMap(Map<String, dynamic> map) {
    return SalesModel(
      id: map['id'] as int,
      name: map['name'] as String,
      quantity: map['quantity'] as int,
      price: map['price'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory SalesModel.fromJson(String source) =>
      SalesModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
