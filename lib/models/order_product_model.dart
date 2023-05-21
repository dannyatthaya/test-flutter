import 'package:mini_project_flutter/main.dart';
import 'package:mini_project_flutter/models/customer_model.dart';
import 'package:mini_project_flutter/models/product_model.dart';

class OrderProductModel {
  final int id;
  final ProductModel product;
  final int quantity;
  final DateTime createdAt;
  final DateTime updatedAt;

  OrderProductModel({
    required this.id,
    required this.product,
    required this.quantity,
    required this.createdAt,
    required this.updatedAt,
  });

  OrderProductModel.form({
    int? id,
    required this.product,
    required this.quantity,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : id = id ?? 0,
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  factory OrderProductModel.fromJson(Map<String, dynamic> json) {
    return OrderProductModel(
      id: json['id'],
      product: json['product'],
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
      'product': product.toJson(),
      'quantity': quantity.toString(),
      'createdAt': createdAt.toString(),
      'updatedAt': updatedAt.toString(),
    };
  }

  Map<String, dynamic> toRequest() {
    return {
      'id': id,
      'product': product.toJson(),
      'quantity': quantity.toString(),
    };
  }
}
