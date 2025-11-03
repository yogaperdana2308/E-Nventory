import 'dart:convert';

class ItemModel {
  int? id;
  String name;
  int stock;
  int price;

  ItemModel({
    this.id,
    required this.name,
    required this.stock,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'stock': stock,
      'price': price,
    };
  }

  factory ItemModel.fromMap(Map<String, dynamic> map) {
    return ItemModel(
      id: map['id'] as int,
      name: map['name'] as String,
      stock: map['stock'] as int,
      price: map['price'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory ItemModel.fromJson(String source) =>
      ItemModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
