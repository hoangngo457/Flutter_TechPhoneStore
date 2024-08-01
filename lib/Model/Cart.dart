import 'package:storesalephone/Model/OptionProduct.dart';

class CartDetail {
  int? idCart;
  int? quantity;
  int? idProduct;
  int? idColor;
  int? idRam;
  int? idRom;

  // data cua option
  OptionProduct? productData;

  CartDetail();

  CartDetail.fromJson(Map<String, dynamic> json) {
    idCart = json["id"];
    quantity = json["quantity"];
    idProduct = json["idPro"];
    idColor = json["idColor"];
    idRom = json["idRom"];
    idRam = json["idRam"];
    if (json["data"] != null) {
      productData = OptionProduct.fromJson(json["data"]);
    }
  }
}
