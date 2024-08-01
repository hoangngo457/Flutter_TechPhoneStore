class Product {
  int? id;
  String? name;
  String? cpu;
  String? ram;
  String? rom;
  String? display;
  String? camera;
  String? battery;
  String? system;
  int? idBrand;

  Product.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    cpu = json["cpu"];
    ram = json["ram"];
    rom = json["rom"];
    display = json["display"];
    battery = json["battery"];
    camera = json["camera"];
    system = json["os"];
    idBrand = json["idBrand"];
  }
}
