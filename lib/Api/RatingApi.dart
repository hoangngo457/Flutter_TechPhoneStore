import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RatingApi {
  RatingApi() {}
  Future<void> createNew(int count, String content, int idOpt) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('userId') ?? 1;
    String apiUrl = dotenv.env['URL'].toString();

    final response = await http.post(
      Uri.parse('$apiUrl/api/create-new-FeedBack'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "rating": count,
        "comment": content,
        "idUser": userId,
        "idOpt": idOpt,
      }),
    );
    if (response.statusCode == 200) {
      print("add feedback success");
    } else {
      print("add feedback fail");
    }
  }
}
