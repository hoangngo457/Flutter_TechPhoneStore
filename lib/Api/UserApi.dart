import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storesalephone/Model/SQLite/DatabaseUser.dart';
import '../Model/Users.dart';

class UsersApi {
  Future<Map<String, dynamic>> fetchLogin(String email, String password) async {
    String apiUrl = dotenv.env['URL'].toString();
    final response = await http.post(
      Uri.parse('$apiUrl/api/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      if (data['errcode'] == 0) {
        print('Đăng nhập thành công');
        final user = data['user'];
        final dbHelper = DatabaseHelper.instance;
        await dbHelper.clearUserLogin(); // Xóa dữ liệu cũ nếu có
        await dbHelper.insertUser({
          'id': user['id'],
          'roleId': user['roleId'],
          'fullName': user['fullName'],
          'phoneNumber': user['phoneNumber'],
          'email': user['email'],
          'address': user['address'],
          'image': user['image'],
        });

        return {
          'errcode': data['errcode'],
          'message': data['message'],
          'user': Users.fromJson(data['user']),
        };
      } else {
        return {
          'errcode': data['errcode'],
          'message': data['message'],
        };
      }
    } else {
      throw Exception('Đăng nhập thất bại');
    }
  }

  Future<Map<String, dynamic>> fetchRegister(String fullName,
      String phoneNumber, String email, String password, String address) async {
    String apiUrl = dotenv.env['URL'].toString();
    final response = await http.post(
      Uri.parse('$apiUrl/api/create-new-user'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'fullName': fullName,
        'password': password,
        'phoneNumber': phoneNumber,
        'email': email,
        'address': address,
        'roleId': 'user',
      }),
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (data['errcode'] == 0) {
        print('Đăng ký thành công');

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
      throw Exception('Đăng ký thất bại');
    }
  }


 Future<Map<String, dynamic>> fetchForgotPassword(String email, ) async {
    String apiUrl = dotenv.env['URL'].toString();
    final response = await http.post(
      Uri.parse('$apiUrl/api/guiemail'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
      }),
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (data['errcode'] == 0) {
        print('Gửi email thành công');

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
      throw Exception('Gửi email thất bại');
    }
  }





Future<Map<String, dynamic>> fetchChangePassword(int userid, String oldpassword, String newpassword) async {
  String apiUrl = dotenv.env['URL'].toString();
  final response = await http.put(
    Uri.parse('$apiUrl/api/changepassword'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'id': userid,
      'oldpassword': oldpassword,
      'newpassword': newpassword,
    }),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    if (data['errcode'] == 0) {
      print('đổi mật khẩu thành công');
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
    throw Exception('đổi mật khẩu thất bại');
  }
}











  Future<Users?> fetchInformation(int userId) async {
    String apiUrl = dotenv.env['URL'].toString();
    final response =
        await http.get(Uri.parse('$apiUrl/api/get-all-users?id=$userId'));
    if (response.statusCode == 200) {
      print("lấy thông tin người dùng thành công");
      final data = jsonDecode(response.body);
      return Users.fromJson(
          data["users"]); // Giả sử dữ liệu người dùng nằm trong `user`
    } else {
      throw Exception('bị lỗi ở api users');
    }
  }
}
