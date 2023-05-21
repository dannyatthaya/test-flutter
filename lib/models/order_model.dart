import 'package:mini_project_flutter/main.dart';
import 'package:mini_project_flutter/models/customer_model.dart';
import 'package:mini_project_flutter/models/order_product_model.dart';
import 'package:mini_project_flutter/models/product_model.dart';

class OrderModel {
  final int id;
  final String name;
  final CustomerModel? customer;
  final List<ProductModel>? products;
  final List<OrderProductModel>? orderProducts;
  final double subtotal;
  final DateTime createdAt;
  final DateTime updatedAt;

  OrderModel({
    required this.id,
    required this.name,
    this.customer,
    this.products,
    this.orderProducts,
    required this.subtotal,
    required this.createdAt,
    required this.updatedAt,
  });

  OrderModel.form({
    int? id,
    String? name,
    required this.customer,
    List<ProductModel>? products,
    required this.orderProducts,
    double? subtotal,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : id = id ?? 0,
        name = name ?? '',
        products = [],
        subtotal = subtotal ?? 0.0,
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      name: json['name'],
      customer: json.containsKey('customer')
          ? CustomerModel.fromJson(json['customer'])
          : null,
      products: json.containsKey('products')
          ? List.from(json['products'])
              .map((e) => ProductModel.fromJson(e))
              .toList()
          : null,
      subtotal: json.containsKey('subtotal')
          ? double.parse(json['subtotal'].toString())
          : 0.0,
      createdAt: dateFormat.parse(json['createdAt']),
      updatedAt: dateFormat.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'customer': customer?.toJson(),
      'products': products?.map((e) => e.toJson()).toList(),
      'orderProducts': orderProducts?.map((e) => e.toJson()).toList(),
      'subtotal': subtotal.toString(),
      'createdAt': createdAt.toString(),
      'updatedAt': updatedAt.toString(),
    };
  }

  Map<String, dynamic> toRequest() {
    return {
      'id': id,
      'name': name,
      'customer': customer?.toJson(),
      'products': orderProducts?.map((e) => e.toJson()).toList(),
      'subtotal': subtotal.toString(),
    };
  }
}
