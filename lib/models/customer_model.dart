import 'package:mini_project_flutter/main.dart';

class CustomerModel {
  final int id;
  final String name;
  final String displayName;
  final String location;
  final String gender;
  final DateTime createdAt;
  final DateTime updatedAt;

  CustomerModel({
    required this.id,
    required this.name,
    required this.displayName,
    required this.location,
    required this.gender,
    required this.createdAt,
    required this.updatedAt,
  });

  CustomerModel.form({
    int? id,
    required this.name,
    required this.displayName,
    required this.location,
    required this.gender,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : id = id ?? 0,
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['id'],
      name: json['name'],
      displayName: json['displayName'],
      location: json['location'],
      gender: json['gender'],
      createdAt: dateFormat.parse(json['createdAt']),
      updatedAt: dateFormat.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'displayName': displayName,
      'location': location,
      'gender': gender,
      'createdAt': createdAt.toString(),
      'updatedAt': updatedAt.toString(),
    };
  }

  Map<String, dynamic> toRequest() {
    return {
      'id': id,
      'name': name,
      'display_name': displayName,
      'location': location,
      'gender': gender,
    };
  }
}
