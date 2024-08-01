import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storesalephone/Model/Cart.dart';
import 'package:http/http.dart' as http;

class CartApi {
  Future<List<CartDetail>> fetchAllCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    int userId =
        prefs.getInt('userId') ?? 1; // Lấy id người dùng từ SharedPreferences
    String apiUrl = dotenv.env['URL'].toString();
    final response = await http
        .get(Uri.parse('$apiUrl/api/get-all-Cart-by-User?id=$userId'));
    if (response.statusCode == 200) {
      final data = await jsonDecode(response.body);
      return (data["Cart"] as List).map((e) => CartDetail.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<void> addCart(dataAdd) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(dataAdd);
    int userId =
        prefs.getInt('userId') ?? 1; // Lấy id người dùng từ SharedPreferences
    String apiUrl = dotenv.env['URL'].toString();
    final response =
        await http.post(Uri.parse('$apiUrl/api/create-new-Cart?id=$userId'),
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode(dataAdd.toJson()));
    if (response.statusCode == 200) {
      print("add cart Success");
    } else {
      print("add cart fail");
    }
  }

  Future<void> deleteCart(int id) async {
    String apiUrl = dotenv.env['URL'].toString();
    final response =
        await http.delete(Uri.parse('$apiUrl/api/delete-Cart?id=$id'));

    if (response.statusCode == 200) {
      print("Delete cart success");
    } else {
      print("Delete cart failed");
    }
  }

  Future<void> updateCart(int id, int newQuantity) async {
    String apiUrl = dotenv.env['URL'].toString();
    final response = await http.put(Uri.parse('$apiUrl/api/edit-Cart'), body: {
      'id': id.toString(),
      'quantity': newQuantity.toString(),
    });

    if (response.statusCode == 200) {
      print("Update cart success");
    } else {
      print("Update cart failed");
    }
  }
}
