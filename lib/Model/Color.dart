import 'dart:ui';

import 'Memory.dart';

class Color {
  int? id;
  String? name;
  String? img;

  Color.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    img = json["img"];
  }

  static fromARGB(int i, int j, int k, int l) {}
}
