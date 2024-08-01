import 'package:storesalephone/Model/Memory.dart';

class Ram {
  int? id;
  int? name;
  List<Memory>? memory;

  Ram.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    memory = (json["roms"] as List).map((e) => Memory.fromJson(e)).toList();
  }
  Ram();
}
