import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storesalephone/Api/UserApi.dart';
import 'package:storesalephone/CommonWidget/Cart.dart';
import 'package:storesalephone/Model/Users.dart';

class HomeTitle extends StatefulWidget {
  const HomeTitle({super.key});

  @override
  _HomeTitleState createState() => _HomeTitleState();
}

class _HomeTitleState extends State<HomeTitle> {
  String _userName = 'Tên người dùng';
  final UsersApi _usersApi = UsersApi();

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('userId');
    if (userId != null) {
      try {
        Users? user = await _usersApi.fetchInformation(userId);
        if (user != null) {
          setState(() {
            _userName = user.fullName ?? 'Người dùng';
          });
        }
      } catch (e) {
        print('Error loading user information: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 50, 0, 0),
      alignment: Alignment.bottomLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Chúc một ngày tốt lành",
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
              Row(
                children: [
                  Text(
                    _userName,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Image(
                    image: AssetImage("assets/open-box.png"),
                    width: 27,
                    height: 27,
                  )
                ],
              ),
            ],
          ),
          const CartStore(color: "white")
        ],
      ),
    );
  }
}
