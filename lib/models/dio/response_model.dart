import 'package:logger/logger.dart';
import 'package:mini_project_flutter/models/pagination/pagination_model.dart';

class ResponseModel<T> {
  final String message;
  final int status;
  final String? error;
  final int? page;
  final T? data;
  final dynamic links;
  final PaginationModel? meta;

  ResponseModel({
    required this.message,
    required this.status,
    this.error,
    this.page,
    this.data,
    this.links,
    this.meta,
  });

  factory ResponseModel.fromJson(Map<String, dynamic> json) {
    return ResponseModel<T>(
      message: json['message'],
      status: json['status'],
      data: json.containsKey('data') ? json['data'] as T : null,
      error: json.containsKey('error') ? json['error'] : null,
      page: json.containsKey('page') ? json['page'] : null,
      links: json.containsKey('links') ? json['links'] : null,
      meta: json.containsKey('meta')
          ? PaginationModel.fromJson(json['meta'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'status': status,
      'error': error,
      'page': page,
      'data': data,
      'links': links,
      'meta': meta,
    };
  }
}
