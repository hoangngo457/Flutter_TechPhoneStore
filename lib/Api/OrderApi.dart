import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storesalephone/Model/Order.dart';

class OrderApi {
  Future<Map<String, dynamic>> fetchOrder(
      String order_status, int total_value, String payment, int idAdr) async {
    String apiUrl = dotenv.env['URL'].toString();
    final response = await http.post(
      Uri.parse('$apiUrl/api/create-new-Order'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'order_status': order_status,
        'total_value': total_value,
        'payment': payment,
        'idAdr': idAdr,
      }),
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (data['errcode'] == 0) {
        print('Đặt hàng thành công');
        var createdOrderId = data['data']['id'];
        print('ID MỚI ĐƯỢC TẠO LÀ : $createdOrderId');

        return {
          'id': data['data']['id'],
          'errcode': data['errcode'],
          'message': data['message'],
        };
      } else {
        return {
          'id': data['data']['id'],
          'errcode': data['errcode'],
          'message': data['message'],
        };
      }
    } else {
      throw Exception('Đặt hàng bị lỗi code');
    }
  }



  Future<Map<String, dynamic>> fetchOrderDetails(List<Map<String, dynamic>> orderDetails) async {
    String apiUrl = dotenv.env['URL'].toString();
    final response = await http.post(
      Uri.parse('$apiUrl/api/create-new-Orderdetail'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(orderDetails),
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (data['errcode'] == 0) {
        print('Đặt hàng thành công');

        return {
          'errcode': data['errcode'],
          'message': data['message'],
        };
      } else {
        return {
          'errcode': data['errcode'],
          'message': data['message'],
        };
      }
    } else {
      throw Exception('Đặt hàng bị lỗi code');
    }
  }

  Future<List<OrderModel>> fetchAllOrderByUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId =
        prefs.getInt('userId') ?? 1; // Lấy id người dùng từ SharedPreferences
    String apiUrl = dotenv.env['URL'].toString();
    final response = await http
        .get(Uri.parse('$apiUrl/api/get-all-Order-User?idUser=$userId'));
    if (response.statusCode == 200) {
      final data = await jsonDecode(response.body);
      return (data["dataResult"] as List)
          .map((e) => OrderModel.fromJson(e))
          .toList();
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<void> reBuyOrder(int idOrder) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId =
        prefs.getInt('userId') ?? 1; // Lấy id người dùng từ SharedPreferences
    String apiUrl = dotenv.env['URL'].toString();
    final response = await http.get(
        Uri.parse('$apiUrl/api/rebuy_order?idUser=$userId&idOrder=$idOrder'));
    if (response.statusCode == 200) {
      print("success");
    } else {
      print("fail");
    }
  }
}
