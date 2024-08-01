import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:http/http.dart' as http;
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({Key? key}) : super(key: key);

  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  Uint8List? _imageGallery;
  File? _imageFile;
  String? _imageUrl;
  String? _filename;
  final phoneRegex = RegExp(r'^\d+$');

  void showSuccessToast() {
    toastification.show(
      context: context,
      type: ToastificationType.success,
      style: ToastificationStyle.fillColored,
      title: const Text('Cập nhật thông tin thành công'),
      description: const Text('Thông tin cá nhân đã được cập nhật thành công.'),
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
        'Cập nhật thông tin thất bại',
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

  Future<void> updateUserInformation() async {
    String apiUrl = dotenv.env['URL'].toString();

    if (_imageFile == null) {
      print("No image selected");
    } else {
      String cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME'].toString();
      String uploadPreset = dotenv.env['CLOUDINARY_UPLOAD_PRESET'].toString();

      final url =
          Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/upload');
      final request = http.MultipartRequest('POST', url);
      request.fields['upload_preset'] = uploadPreset;
      request.files.add(await http.MultipartFile.fromPath(
        'file',
        _imageFile?.path ?? '',
      ));
      final response1 = await request.send();
      if (response1.statusCode == 200) {
        final responseData = await response1.stream.toBytes();
        final responseString = String.fromCharCodes(responseData);
        final jsonMap = jsonDecode(responseString);

        setState(() {
          final url = jsonMap['url'];
          _imageUrl = url;
          _filename = jsonMap['public_id'];
        });
      }
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();

    int userId =
        prefs.getInt('userId') ?? 1; // Lấy id người dùng từ SharedPreferences
    if (!phoneRegex.hasMatch(phoneController.text) ||
        phoneController.text.length != 10) {
      showFailToast('Số điện thoại phải có 10 số');
      return;
    }

    final response = await http.put(
      Uri.parse('$apiUrl/api/edit-user'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id': userId,
        'fullName': nameController.text,
        'email': emailController.text,
        'phoneNumber': phoneController.text,
        'address': addressController.text,
        'image': _imageUrl,
        'filename': _filename,
      }),
    );

    if (response.statusCode == 200) {
      showSuccessToast();
    } else {
      showFailToast('Cập nhật thất bại đã có lỗi sảy ra');
    }
  }

  Future<Map<String, dynamic>> fetchUserInformation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    int userId =
        prefs.getInt('userId') ?? 1; // Lấy id người dùng từ SharedPreferences
    String apiUrl = dotenv.env['URL'].toString();
    final response =
        await http.get(Uri.parse('$apiUrl/api/get-all-users?id=$userId'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      if (data['errcode'] == 0) {
        return data['users'];
      } else {
        throw Exception('Failed to load user information');
      }
    } else {
      throw Exception('Failed to load user information');
    }
  }

  Future<void> pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: source);
    setState(() {
      if (pickedFile != null) _imageFile = File(pickedFile.path);
      _imageGallery = _imageFile?.readAsBytesSync();
    });
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
          "Thông tin cá nhân",
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
        child: Container(
          padding: const EdgeInsets.all(16),
          child: FutureBuilder<Map<String, dynamic>>(
            future: fetchUserInformation(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData) {
                return const Center(child: Text('No data found'));
              } else {
                final user = snapshot.data!;
                nameController.text = user['fullName'];
                emailController.text = user['email'];
                phoneController.text = user['phoneNumber'];
                addressController.text = user['address'];

                return Column(
                  children: [
                    Stack(
                      children: [
                        SizedBox(
                          width: 120,
                          height: 120,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: _imageGallery == null
                                ? (user['image'] != null &&
                                        user['image'].isNotEmpty
                                    ? Image.network(
                                        user['image'],
                                        fit: BoxFit.cover,
                                      )
                                    : const Image(
                                        image: AssetImage(
                                            'assets/userprofile.jpg'),
                                        fit: BoxFit.cover,
                                      ))
                                : Image.memory(
                                    _imageGallery!,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.blue,
                            ),
                            child: IconButton(
                              icon: const Icon(LineAwesomeIcons.camera_solid,
                                  color: Colors.white, size: 20),
                              onPressed: () => pickImage(ImageSource.gallery),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),
                    Form(
                      child: Column(
                        children: [
                          TextFormField(
                            controller: nameController,
                            decoration: const InputDecoration(
                                label: Text("Tên"),
                                prefixIcon: Icon(LineAwesomeIcons.user)),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: emailController,
                            decoration: const InputDecoration(
                                label: Text("Email"),
                                prefixIcon: Icon(Icons.email)),
                            enabled: false,
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: phoneController,
                            decoration: const InputDecoration(
                                label: Text('Số điện thoại'),
                                prefixIcon: Icon(LineAwesomeIcons.phone_solid)),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: addressController,
                            decoration: const InputDecoration(
                                label: Text('Địa chỉ'),
                                prefixIcon: Icon(Icons.location_on)),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: updateUserInformation,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                side: BorderSide.none,
                                shape: const StadiumBorder(),
                              ),
                              child: const Text("Cập nhật",
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
