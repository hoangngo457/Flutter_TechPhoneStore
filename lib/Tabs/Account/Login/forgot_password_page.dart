import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import 'package:storesalephone/Api/UserApi.dart';
import 'package:toastification/toastification.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  final UsersApi _usersApi = UsersApi();

  void _showSuccessToast() {
    toastification.show(
      context: context,
      type: ToastificationType.success,
      style: ToastificationStyle.fillColored,
      title: const Text('Gửi email thành công!'),
      description: const Text('Vui lòng kiểm tra mật khẩu mới trong email'),
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
        'Gửi email thất bại!',
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

  void _sendForgotPasswordEmail() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final emailRegex = RegExp(r'^[^@]+@gmail\.com$');

      if (!emailRegex.hasMatch(_emailController.text)) {
        showFailToast('Email không hợp lệ');
        return;
      } else {
        final response =
            await _usersApi.fetchForgotPassword(_emailController.text);
        if (response['errcode'] == 0) {
          _showSuccessToast();
        }
      }
    } catch (e) {
      showFailToast('Có lỗi xảy ra. Vui lòng thử lại.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                            'Quên mật khẩu',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Nhập email nhận mật khẩu mới',
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
                          _isLoading
                              ? const CircularProgressIndicator()
                              : ElevatedButton(
                                  onPressed: _sendForgotPasswordEmail,
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: Size(double.infinity, 50),
                                    backgroundColor: Colors.blue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                  ),
                                  child: const Text(
                                    'Gửi',
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  ),
                                ),
                          const SizedBox(height: 20),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Bạn có tài khoản?'),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Đăng nhập ngay!'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Nhân viên hỗ trợ gọi ngay: 0399654045',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
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
      ..lineTo(size.width, size.height * 0.6)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
