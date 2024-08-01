import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:storesalephone/Api/OptionProductApi.dart';
import 'package:storesalephone/Api/brandApi.dart';
import 'package:storesalephone/Model/Category.dart';
import 'package:storesalephone/Model/OptionProduct.dart';
import 'package:storesalephone/Model/Product.dart';

class SetUpData {
  Future<List<Category>> getDataCategory() async {
    BrandApi brandApi = BrandApi();
    List<Category> listCategoryApi = await brandApi.fetchCategory();
    return listCategoryApi;
  }

  Future<List<OptionProduct>> getDataProduct() async {
    OptionProductApi productApi = OptionProductApi();
    List<OptionProduct> listProducts = await productApi.fetchOptionProduct();
    return listProducts;
  }

  Future<List<OptionProduct>> getDataFilterProduct(
      String id, String priceOrder, int brandId) async {
    OptionProductApi productApi = OptionProductApi();
    List<OptionProduct> listProducts =
        await productApi.fetchFilterOptionProduct(id, priceOrder, brandId);
    return listProducts;
  }
}
