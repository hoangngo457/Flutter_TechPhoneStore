import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storesalephone/Api/UserApi.dart';
import 'package:toastification/toastification.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final UsersApi _usersApi = UsersApi();

  void showSuccessToast() {
    toastification.show(
      context: context,
      type: ToastificationType.success,
      style: ToastificationStyle.fillColored,
      title: const Text('Đổi mật khẩu thành công!'),
      description: const Text('Bạn đã đổi mật khẩu thành công.'),
      alignment: Alignment.centerLeft,
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
        'Đổi mật khẩu thất bại!',
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

  Future<void> _changePassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId =
        prefs.getInt('userId') ?? 1; // Lấy id người dùng từ SharedPreferences
    if (_formKey.currentState!.validate()) {
      try {
        String oldPassword = _oldPasswordController.text;
        String newPassword = _newPasswordController.text;

        final response = await _usersApi.fetchChangePassword(
            userId, oldPassword, newPassword);

        if (response['errcode'] == 0) {
          showSuccessToast();
        } else {
          showFailToast('${response['message']}');
        }
      } catch (e) {
        showFailToast('Đổi mật khẩu thất bại: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back), // Icon back của iOS
          onPressed: () {
            Navigator.pop(
                context); // Đóng màn hình và quay lại màn hình trước đó
          },
        ),
        title: Text(
          "Đổi mật khẩu",
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontSize: 20), // Thiết lập style cho tiêu đề
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0), // Chiều cao của đường ngăn cách
          child: Container(
            height: 1.0,
            color: Colors.grey,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Center(
                child: Text(
                  'Đổi mật khẩu',
                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                  height:
                      20.0), // Add some space between the title and the form
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    TextFormField(
                      controller: _oldPasswordController,
                      decoration: const InputDecoration(
                        labelText: 'Mật khẩu cũ',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng điền đầy đủ thông tin';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: _newPasswordController,
                      decoration: const InputDecoration(
                        labelText: 'Mật khẩu mới',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng điền đầy đủ thông tin';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: _confirmPasswordController,
                      decoration: const InputDecoration(
                        labelText: 'Nhập lại mật khẩu',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng điền đầy đủ thông tin';
                        }
                        if (value != _newPasswordController.text) {
                          return 'Mật khẩu  mới không giống';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32.0),
                    ElevatedButton(
                      onPressed: _changePassword,
                      child: Text(
                        'Thay đổi',
                        style: const TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
