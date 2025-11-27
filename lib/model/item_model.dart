// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ItemModel {
  int? id;
  String name;
  int stock;
  int modal;
  int price;
  String? date;

  ItemModel({
    this.id,
    required this.name,
    required this.stock,
    required this.modal,
    required this.price,
    this.date,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'stock': stock,
      'modal': modal,
      'price': price,
      'date': date,
    };
  }

  factory ItemModel.fromMap(Map<String, dynamic> map) {
    return ItemModel(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] as String,
      stock: map['stock'] as int,
      modal: map['modal'] as int,
      price: map['price'] as int,
      date: map['date'] != null ? map['date'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ItemModel.fromJson(String source) =>
      ItemModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
