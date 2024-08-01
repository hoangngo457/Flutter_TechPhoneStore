import 'package:shared_preferences/shared_preferences.dart';
import 'package:storesalephone/Api/OptionProductApi.dart';
import 'package:storesalephone/Model/OptionProduct.dart';

class DetailSetUp {
  Future<OptionProduct> getDataProductById() async {
    OptionProductApi productApi = OptionProductApi();
    List<OptionProduct> listProducts =
        await productApi.fetchOptionProductById();
    return listProducts[0];
  }

  Future<OptionProduct> getDataProductByIdColor(int idColor) async {
    OptionProductApi productApi = OptionProductApi();
    List<OptionProduct> listProducts =
        await productApi.fetchOptionProductByIdColor(idColor);
    return listProducts[0];
  }

  Future<void> addFavorite(idColor, idProduct) async {
    OptionProductApi productApi = OptionProductApi();
    productApi.createFavorite(idProduct, idColor);
  }

  Future<void> deleteFavorite(idColor, idProduct) async {
    OptionProductApi productApi = OptionProductApi();
    productApi.deleteFavorite(idProduct, idColor);
  }
}
