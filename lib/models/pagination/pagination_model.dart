import 'package:mini_project_flutter/models/pagination/links_model.dart';

class PaginationModel {
  final int currentPage;
  final int? from;
  final int lastPage;
  final List<LinksModel> links;
  final String path;
  final int perPage;
  final int? to;
  final int total;

  PaginationModel({
    required this.currentPage,
    required this.from,
    required this.lastPage,
    required this.links,
    required this.path,
    required this.perPage,
    required this.to,
    required this.total,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      currentPage: json['currentPage'],
      from: json['from'],
      lastPage: json['lastPage'],
      links: json.containsKey('links')
          ? List<dynamic>.from(json['links'])
              .map((link) => LinksModel.fromJson(link))
              .toList()
          : [],
      path: json['path'],
      perPage: json['perPage'],
      to: json['to'],
      total: json['total'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentPage': currentPage,
      'from': from,
      'lastPage': lastPage,
      'links': links,
      'path': path,
      'perPage': perPage,
      'to': to,
      'total': total,
    };
  }
}
