import 'package:mini_project_flutter/models/pagination/pagination_model.dart';

class IndexResponseModel<T> {
  final T data;
  final PaginationModel pagination;

  IndexResponseModel({
    required this.data,
    required this.pagination,
  });

  factory IndexResponseModel.fromJson(Map<String, dynamic> json) {
    return IndexResponseModel<T>(
      data: json['data'],
      pagination: PaginationModel.fromJson(json['pagination']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data,
      'pagination': pagination,
    };
  }
}
