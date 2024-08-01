import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:storesalephone/Api/UserApi.dart';
import 'package:storesalephone/MyAppScreen.dart';
import 'package:storesalephone/Tabs/BoardScreen/onboarding_page.dart';
import 'package:toastification/toastification.dart';

import '../Signup/register_page.dart';
import 'forgot_password_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _rememberMe = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final UsersApi _usersApi = UsersApi();

  @override
  void initState() {
    super.initState();
    _checkRememberMe();
  }

  void _checkRememberMe() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? rememberMe = prefs.getBool('rememberMe');
    bool? seenOnBoarding = prefs.getBool('seenOnBoarding');

    if (rememberMe != null && rememberMe) {
      if (seenOnBoarding != null && seenOnBoarding) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MyAppScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const PageOnBorarding()),
        );
      }
    }
  }

  void _showSuccessToast() {
    toastification.show(
      context: context,
      type: ToastificationType.success,
      style: ToastificationStyle.fillColored,
      title: const Text('Đăng nhập thành công!'),
      description: const Text('Bạn đã đăng nhập thành công.'),
      alignment: Alignment.bottomCenter,
      autoCloseDuration: const Duration(seconds: 4),
      primaryColor: const Color(0xff24b926),
      backgroundColor: const Color(0xff4682b4),
      icon: const Icon(Iconsax.tick_circle),
      showProgressBar: true,
      dragToClose: true,
    );
  }

  void showFailToast(String message) {
    toastification.show(
      context: context,
      type: ToastificationType.error,
      style: ToastificationStyle.fillColored,
      title: const Text(
        'Đăng nhập thất bại!',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      description: Text(
        message,
        style: const TextStyle(fontSize: 16),
      ),
      alignment: Alignment.centerLeft,
      autoCloseDuration: const Duration(seconds: 4),
      primaryColor: const Color.fromARGB(255, 220, 65, 65),
      backgroundColor: const Color(0xff4682b4),
      icon: const Icon(Iconsax.close_circle),
      borderRadius: BorderRadius.circular(12.0),
      showProgressBar: true,
      dragToClose: true,
    );
  }

  void _login() async {
    try {
      final email = _emailController.text;
      final password = _passwordController.text;

      if (email.isEmpty || password.isEmpty) {
        showFailToast('Vui lòng điền đầy đủ thông tin');
        return;
      }

      final response = await _usersApi.fetchLogin(email, password);
      if (response['errcode'] == 0) {
        // Lưu id người dùng vào SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setInt('userId', response['user'].id);
        if (_rememberMe) {
          prefs.setBool('rememberMe', true);
        } else {
          prefs.setBool('rememberMe', false);
        }
        bool? seenOnBoarding = prefs.getBool('seenOnBoarding');
        if (seenOnBoarding != null && seenOnBoarding) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MyAppScreen()),
          );
          _showSuccessToast();
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const PageOnBorarding()),
          );
          _showSuccessToast();
        }
      } else {
        showFailToast(response['message']);
      }
    } catch (e) {
      showFailToast('Đăng nhập thất bại');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: CustomPaint(
          painter: BackgroundPainter(),
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 8,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            const Text(
                              'Đăng nhập',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Đăng nhập vào tài khoản của bạn',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextField(
                              controller: _emailController,
                              decoration: const InputDecoration(
                                labelText: 'Nhập địa chỉ email',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.email),
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                labelText: 'Nhập mật khẩu',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.lock),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Checkbox(
                                  value: _rememberMe,
                                  onChanged: (value) {
                                    setState(() {
                                      _rememberMe = value!;
                                    });
                                  },
                                ),
                                const Text('Ghi nhớ tài khoản'),
                                Spacer(),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const ForgotPasswordPage()),
                                    );
                                  },
                                  child: const Text('Quên mật khẩu?'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: _login,
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(double.infinity, 50),
                                backgroundColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              child: const Text(
                                'Đăng nhập',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text('hoặc'),
                            const SizedBox(height: 20),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image(
                                  image: AssetImage('assets/fb.png'),
                                  width: 40,
                                  height: 40,
                                ),
                                SizedBox(width: 35),
                                Image(
                                  image: AssetImage('assets/twitter.png'),
                                  width: 40,
                                  height: 40,
                                ),
                                SizedBox(width: 35),
                                Image(
                                  image: AssetImage('assets/github.png'),
                                  width: 40,
                                  height: 40,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Bạn chưa có tài khoản?'),
                        TextButton(
                          onPressed: () {
                            // Điều hướng đến trang đăng ký
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const RegisterPage()),
                            );
                          },
                          child: const Text('Đăng ký ngay!'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height * 0.1)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
