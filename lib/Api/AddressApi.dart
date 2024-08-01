import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storesalephone/Model/Address.dart';

class AddressApi {
  Future<List<Address>> fetchListAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId =
        prefs.getInt('userId') ?? 1; // Lấy id người dùng từ SharedPreferences
    String apiUrl = dotenv.env['URL'].toString();
    final response = await http
        .get(Uri.parse('$apiUrl/api/get-all-Address-by-Iduser?id=$userId'));
    if (response.statusCode == 200) {
      print("Lấy danh sách địa chỉ người dùng thành công");
      final data = jsonDecode(response.body);
      List<Address> addresses =
          (data["Address"] as List).map((i) => Address.fromJson(i)).toList();
      return addresses;
    } else {
      throw Exception('Lỗi khi gọi API Address');
    }
  }

 Future<Address> fetchAddressById(int id) async {
  String apiUrl = dotenv.env['URL'].toString();
  final response =
      await http.get(Uri.parse('$apiUrl/api/get-all-Address?id=$id'));
  if (response.statusCode == 200) {
    print("Lấy id và tin của địa chỉ thành công");
    final data = jsonDecode(response.body);
    return Address.fromJson(data['Address']);
  } else {
    throw Exception('Lỗi khi gọi API Address');
  }
}

  Future<Map<String, dynamic>> fetchCreateAddress(
      String name,
      String city,
      String district,
      String ward,
      String phoneNumber,
      String detailAdr,
      int idUser) async {
    String apiUrl = dotenv.env['URL'].toString();
    final response = await http.post(
      Uri.parse('$apiUrl/api/create-new-Address'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'name': name,
        'city': city,
        'district': district,
        'ward': ward,
        'phone_num': phoneNumber,
        'detail_Adr': detailAdr,
        'idUser': idUser,
      }),
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (data['errcode'] == 0) {
        print('Thêm địa chỉ thành công');
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
      throw Exception('Thêm địa chỉ bị lỗi code');
    }
  }

  Future<Map<String, dynamic>> deleteAddress(int addressId) async {
    String apiUrl = dotenv.env['URL'].toString();
    final response = await http.delete(
      Uri.parse('$apiUrl/api/delete-Address?id=$addressId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (data['errcode'] == 0) {
        print('Xóa địa chỉ thành công');
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
      throw Exception('Xóa địa chỉ bị lỗi code');
    }
  }

  Future<Map<String, dynamic>> editAddress(
    int addressId,
    String name,
    String city,
    String district,
    String ward,
    String phoneNumber,
    String detailAdr,
  ) async {
    String apiUrl = dotenv.env['URL'].toString();
    final response = await http.put(
      Uri.parse('$apiUrl/api/edit-Address'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'id': addressId,
        'name': name,
        'city': city,
        'district': district,
        'ward': ward,
        'phone_num': phoneNumber,
        'detail_Adr': detailAdr,
      }),
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (data['errcode'] == 0) {
        print('Chỉnh sửa địa chỉ thành công');
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
      throw Exception('Chỉnh sửa địa chỉ bị lỗi code');
    }
  }

 
}
