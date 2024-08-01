import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storesalephone/Api/UserApi.dart';
import 'package:storesalephone/Model/Users.dart';
import 'package:storesalephone/Tabs/Account/Login/change_password.dart';
import 'package:storesalephone/Tabs/Account/Login/login_page.dart';
import 'package:storesalephone/Tabs/Address/addressUser_page.dart';
import 'package:storesalephone/Tabs/Favorite/FavoriteScreen.dart';
import 'package:storesalephone/Tabs/ProfileHome/ProfilMenuWidget.dart';
import 'package:storesalephone/Tabs/ProfileHome/UpdateProfileScreen.dart';
import 'package:storesalephone/Tabs/Payment/orderhistory.dart';
import 'package:toastification/toastification.dart';

import '../../Provider/HistoryProvider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UsersApi _usersApi = UsersApi();
  late Future<Users?> _userFuture;

  @override
  void initState() {
    super.initState();
    _fetchUserInformation();
  }

  void showSuccessToast() {
    toastification.show(
      context: context,
      type: ToastificationType.success,
      style: ToastificationStyle.fillColored,
      title: const Text('Đăng xuất thành công!'),
      description: const Text('Bạn đã đăng xuất thành công'),
      alignment: Alignment.bottomCenter,
      autoCloseDuration: const Duration(seconds: 4),
      primaryColor: const Color(0xff24b926),
      backgroundColor: const Color(0xff4682b4),
      icon: const Icon(Iconsax.tick_circle),
      showProgressBar: true,
      dragToClose: true,
    );
  }

  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    await prefs.remove('rememberMe');
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (Route<dynamic> route) => false,
    );
    showSuccessToast();
  }

  Future<void> _fetchUserInformation() async {
    int userId = await getUserId();
    setState(() {
      _userFuture = _usersApi.fetchInformation(userId);
    });
  }

  Future<int> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId') ??
        1; // Lấy id người dùng từ SharedPreferences
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: getUserId(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Lỗi: ${snapshot.error}'));
        } else {
          return FutureBuilder<Users?>(
            future: _userFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Lỗi: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                Users? user = snapshot.data;
                String defaultImageUrl = 'assets/userprofile.jpg';
                String userImageUrl = user?.image ?? '';

                return Scaffold(
                  body: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(16, 60, 16, 16),
                      child: Column(
                        children: [
                          /// -- IMAGE
                          Stack(
                            children: [
                              SizedBox(
                                width: 120,
                                height: 120,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: userImageUrl.isNotEmpty
                                      ? Image.network(userImageUrl,
                                          fit: BoxFit.cover)
                                      : Image.asset(defaultImageUrl,
                                          fit: BoxFit.cover),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const UpdateProfileScreen(),
                                      ),
                                    ).then((_) => _fetchUserInformation());
                                  },
                                  child: Container(
                                    width: 35,
                                    height: 35,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: Colors.blue,
                                    ),
                                    child: const Icon(
                                      LineAwesomeIcons.pen_solid,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(user?.fullName ?? "Chưa đăng nhập",
                              style: Theme.of(context).textTheme.headline4),
                          Text(user?.email ?? "Chưa đăng nhập",
                              style: Theme.of(context).textTheme.bodyText2),
                          const SizedBox(height: 20),

                          /// -- BUTTON
                          SizedBox(
                            width: 200,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const UpdateProfileScreen(),
                                  ),
                                ).then((_) =>
                                    _fetchUserInformation()); // Fetch data again after returning from UpdateProfileScreen
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  side: BorderSide.none,
                                  shape: const StadiumBorder()),
                              child: const Text("Thông tin cá nhân",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                          const SizedBox(height: 30),
                          const Divider(),
                          const SizedBox(height: 10),

                          /// -- MENU
                          Consumer<HistoryProvider>(builder:
                              (BuildContext context, HistoryProvider value,
                                  Widget? child) {
                            return ProfileMenuWidget(
                                title: "Lịch sử đặt hàng",
                                icon: LineAwesomeIcons.history_solid,
                                onPress: () async {
                                  await value.initData();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const OrderHistory(),
                                    ),
                                  );
                                });
                            value.initData();
                          }),
                          ProfileMenuWidget(
                              title: "Yêu thích",
                              icon: LineAwesomeIcons.heart,
                              onPress: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const FavoriteView(),
                                  ),
                                );
                              }),
                          ProfileMenuWidget(
                              title: "Đổi mật khẩu",
                              icon: Icons.change_circle,
                              onPress: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChangePassword(),
                                  ),
                                );
                              }),
                          ProfileMenuWidget(
                              title: "Địa chỉ",
                              icon: Icons.location_history,
                              onPress: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddressPage(),
                                  ),
                                );
                              }),

                          const Divider(),
                          const SizedBox(height: 10),
                          ProfileMenuWidget(
                              title: "Cài đặt",
                              icon: LineAwesomeIcons.cog_solid,
                              onPress: () {}),
                          ProfileMenuWidget(
                              title: "Đăng xuất",
                              icon: Icons.logout,
                              textColor: Colors.red,
                              endIcon: false,
                              onPress: () {
                                _logout();
                              }),
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return const Center(
                    child: Text('Không tìm thấy thông tin người dùng'));
              }
            },
          );
        }
      },
    );
  }
}
