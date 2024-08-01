class Memory {
  int? id;
  int? name;
  int? quantity;
  int? idOpt;
  Memory.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    quantity = json["quantity"];
    idOpt = json["idOpt"];
  }
  Memory() {}
}
