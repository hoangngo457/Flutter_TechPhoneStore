class Category {
  int? id;
  String? name;
  String? img;

  Category.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    img = json["filename"];
    name = json["name"];
  }
}
