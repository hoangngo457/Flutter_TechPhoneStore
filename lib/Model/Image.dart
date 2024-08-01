class Images {
  String? name;

  Images.fromJson(Map<String, dynamic> json) {
    name = json["img"];
  }
}
