class LinksModel {
  final String? url;
  final String? label;
  final bool? active;

  LinksModel({
    this.url,
    this.label,
    this.active,
  });

  factory LinksModel.fromJson(Map<String, dynamic> json) {
    return LinksModel(
      url: json.containsKey('url') ? json['url'] : null,
      label: json.containsKey('label') ? json['label'] : null,
      active: json.containsKey('active') ? json['active'] : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'label': label,
      'active': active,
    };
  }
}
