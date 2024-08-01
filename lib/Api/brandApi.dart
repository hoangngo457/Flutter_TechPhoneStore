import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:storesalephone/Model/Category.dart';
import 'package:http/http.dart' as http;

class BrandApi {
  Future<List<Category>> fetchCategory() async {
    String apiUrl = dotenv.env['URL'].toString();
    final response =
        await http.get(Uri.parse('$apiUrl/api/get-all-brand?id=ALL'));
    if (response.statusCode == 200) {
      print("run in uin");
      final data = jsonDecode(response.body);
      return (data["Brand"] as List).map((e) => Category.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load user');
    }
  }
}
