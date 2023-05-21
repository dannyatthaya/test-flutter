class ShowParamsModel {
  final dynamic id;

  ShowParamsModel({
    this.id,
  });

  factory ShowParamsModel.fromJson(Map<String, dynamic> json) {
    return ShowParamsModel(
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
    };
  }
}
