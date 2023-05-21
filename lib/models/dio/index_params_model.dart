class IndexParamsModel {
  final String? search;
  final int? page;

  IndexParamsModel({
    this.search,
    this.page = 1,
  });

  factory IndexParamsModel.fromJson(Map<String, dynamic> json) {
    return IndexParamsModel(
      search: json['search'] ? json['search'] : null,
      page: json['page'] ? json['page'] : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'search': search,
      'page': page,
    };
  }
}
