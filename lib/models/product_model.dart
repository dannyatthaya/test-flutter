import 'package:mini_project_flutter/main.dart';

class ProductModel {
  final int id;
  final String name;
  final String displayName;
  final String category;
  final double price;
  final String color;
  final int? quantity;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProductModel({
    required this.id,
    required this.name,
    required this.displayName,
    required this.category,
    required this.price,
    required this.color,
    this.quantity,
    required this.createdAt,
    required this.updatedAt,
  });

  ProductModel.form({
    int? id,
    required this.name,
    required this.displayName,
    required this.category,
    required this.price,
    required this.color,
    int? quantity,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : id = id ?? 0,
        quantity = quantity ?? 0,
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      displayName: json['displayName'],
      category: json['category'],
      price: json.containsKey('price')
          ? double.parse(json['price'].toString())
          : 0.0,
      color: json['color'],
      quantity: json.containsKey('quantity')
          ? int.parse(json['quantity'].toString())
          : 0,
      createdAt: dateFormat.parse(json['createdAt']),
      updatedAt: dateFormat.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'displayName': displayName,
      'category': category,
      'price': price,
      'color': color,
      'quantity': quantity,
      'createdAt': createdAt.toString(),
      'updatedAt': updatedAt.toString(),
    };
  }

  Map<String, dynamic> toRequest() {
    return {
      'id': id,
      'name': name,
      'display_name': displayName,
      'category': category,
      'price': price,
      'color': color,
      'quantity': quantity,
    };
  }
}
