import 'package:storesalephone/Model/Address.dart';

class OrderModel {
  int? id;
  Address? address;
  String? date;
  String? state;
  int? total;
  List<DetailOrder>? list;
  OrderModel() {}
  OrderModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    address = Address.fromJson(json["idAddressData"]);
    date = json["order_date"];
    state = json["order_status"];
    total = int.parse(json["total_value"].toString());
    list = (json["dataDetail"] as List)
        .map((e) => DetailOrder.fromJson(e))
        .toList();
  }
}

class DetailOrder {
  String? nameProduct;
  int? price;
  int? quantity;
  String? rom;
  String? ram;
  String? img;
  String? color;
  int? idOpt;
  DetailOrder.fromJson(Map<String, dynamic> json) {
    nameProduct = json["dataProduct"]["idProductsData"]["name"];
    price = json["dataProduct"]["price"];
    quantity = json["quantity"];
    img = json["img"];
    idOpt = json["idOpt"];
    rom = json["dataProduct"]["idRomData"]["nameRom"].toString();
    ram = json["dataProduct"]["idRamData"]["nameRam"].toString();
    color = json["dataProduct"]["idColorOptData"]["nameColor"];
  }
}
