
import 'package:storesalephone/Api/OptionProductApi.dart';
import 'package:storesalephone/Model/OptionProduct.dart';

class SetUpData {
  Future<List<OptionProduct>> getDataProductFavorite() async {

    OptionProductApi productApi = OptionProductApi();
    List<OptionProduct> listProducts =
        await productApi.fetchOptionProductFavorite();
    return listProducts;
  }

  Future<void> deleteFavorite(int idPro, int idColor) async {
    OptionProductApi productApi = OptionProductApi();
    productApi.deleteFavorite(idPro, idColor);
  }
}
