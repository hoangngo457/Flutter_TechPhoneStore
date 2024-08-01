import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storesalephone/Model/OptionProduct.dart';

class OptionProductApi {
  Future<List<OptionProduct>> fetchOptionProduct() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId =
        prefs.getInt('userId') ?? 1; // Lấy id người dùng từ SharedPreferences
    String apiUrl = dotenv.env['URL'].toString();
    final response = await http.get(Uri.parse(
        '$apiUrl/api/get-all-option-product?id=BESTSELLER&idUser=$userId'));
    if (response.statusCode == 200) {
      print('lay peoduct dc rui ne');
      final data = jsonDecode(response.body);
      return (data["Option_Product"] as List)
          .map((e) => OptionProduct.fromJson(e))
          .toList();
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<List<OptionProduct>> fetchOptionProductFavorite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId =
        prefs.getInt('userId') ?? 2; // Lấy id người dùng từ SharedPreferences
    String apiUrl = dotenv.env['URL'].toString();
    final response =
        await http.get(Uri.parse('$apiUrl/api/get-Favorites-User?id=$userId'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data["result"] as List)
          .map((e) => OptionProduct.fromJson(e))
          .toList();
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<void> deleteFavorite(int idProduct, int idColor) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId =
        prefs.getInt('userId') ?? 3; // Lấy id người dùng từ SharedPreferences
    String apiUrl = dotenv.env['URL'].toString();
    final response = await http.delete(Uri.parse(
        '$apiUrl/api/delete-Favorites?idUser=$userId&idColor=$idColor&idPro=$idProduct'));
    if (response.statusCode == 200) {
      print("detele Success");
    } else {
      print("detele fail");
    }
  }

  Future<void> createFavorite(int idProduct, int idColor) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId =
        prefs.getInt('userId') ?? 3; // Lấy id người dùng từ SharedPreferences
    String apiUrl = dotenv.env['URL'].toString();
    final response = await http.post(Uri.parse(
        '$apiUrl/api/create-new-Favorites?idUser=$userId&idColor=$idColor&idPro=$idProduct'));
    if (response.statusCode == 200) {
      print("add Success");
    } else {
      print("add fail");
    }
  }

  Future<List<OptionProduct>> fetchOptionProductById() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('userId') ?? 1;
    var idProduct = prefs.getInt('idProduct');
    var idColor = prefs.getInt('idColor');

    String apiUrl = dotenv.env['URL'].toString();
    final response = await http.get(Uri.parse(
        '$apiUrl/api/get-all-option-product?id=$idProduct-$idColor&idUser=$userId'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data["Option_Product"] as List)
          .map((e) => OptionProduct.fromJson(e))
          .toList();
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<List<OptionProduct>> fetchOptionProductByIdColor(int idColor) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var idProduct = prefs.getInt('idProduct') ?? 1;
    int userId = prefs.getInt('userId') ?? 1;
    String apiUrl = dotenv.env['URL'].toString();
    final response = await http.get(Uri.parse(
        '$apiUrl/api/get-all-option-product?id=$idProduct-$idColor&idUser=$userId'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data["Option_Product"] as List)
          .map((e) => OptionProduct.fromJson(e))
          .toList();
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<List<OptionProduct>> fetchFilterOptionProduct(
      String id, String priceOrder, int brandId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    int userId =
        prefs.getInt('userId') ?? 1; // Lấy id người dùng từ SharedPreferences
    String apiUrl = dotenv.env['URL'].toString();
    final response = await http.get(Uri.parse(
        '$apiUrl/api/get-filter-option-product?id=$id-$priceOrder-$brandId&idUser=$userId'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data["filterProduct"] as List)
          .map((e) => OptionProduct.fromJson(e))
          .toList();
    } else {
      throw Exception('Failed to load user');
    }
  }
}
