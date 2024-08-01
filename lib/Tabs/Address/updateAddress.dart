import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:storesalephone/Api/AddressApi.dart';

import 'package:storesalephone/Model/Address.dart';
import 'package:toastification/toastification.dart'; // Import toastification

class UpdateAddressPage extends StatefulWidget {
  final Address address;

  UpdateAddressPage({required this.address});

  @override
  _UpdateAddressPageState createState() => _UpdateAddressPageState();
}

class _UpdateAddressPageState extends State<UpdateAddressPage> {
  bool isDefault = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _wardController = TextEditingController();
  final TextEditingController _detailAdrController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.address.name ?? '';
    _phoneController.text = widget.address.phoneNumber ?? '';
    _cityController.text = widget.address.city ?? '';
    _districtController.text = widget.address.district ?? '';
    _wardController.text = widget.address.ward ?? '';
    _detailAdrController.text = widget.address.detailAdr ?? '';
  }

  void showSuccessToast() {
    toastification.show(
      context: context,
      type: ToastificationType.success,
      style: ToastificationStyle.fillColored,
      title: const Text('Cập nhật địa chỉ thành công!'),
      description: const Text('Bạn đã cập nhật địa chỉ thành công.'),
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
        'Cập nhật địa chỉ thất bại!',
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

  void _editAddress() async {
    final phoneRegex = RegExp(r'^\d+$');
    if (!phoneRegex.hasMatch(_phoneController.text) ||
        _phoneController.text.length != 10) {
      showFailToast('Số điện thoại phải có 10 số');
      return;
    }
    try {
      final result = await AddressApi().editAddress(
        widget.address.id!,
        _nameController.text,
        _cityController.text,
        _districtController.text,
        _wardController.text,
        _phoneController.text,
        _detailAdrController.text,
      );

      if (result['errcode'] == 0) {
        showSuccessToast();
        Navigator.pop(context, true);
      } else {
        showFailToast('Chỉnh sửa địa chỉ thất bại: ${result['message']}');
      }
    } catch (e) {
      showFailToast('Lỗi: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Cập nhật địa chỉ",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 20),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Container(
            height: 1.0,
            color: Colors.grey,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              buildTextField(_nameController, 'Tên', 'Vui lòng nhập họ và tên'),
              buildTextField(
                  _phoneController, 'Số điện thoại', 'Vui lòng nhập số'),
              buildTextField(
                  _cityController, 'Tỉnh/Thành phố', 'Vui lòng nhập'),
              buildTextField(
                  _districtController, 'Quận/Huyện', 'Vui lòng nhập'),
              buildTextField(_wardController, 'Phường/Xã', 'Vui lòng nhập'),
              buildTextField(_detailAdrController, 'Địa chỉ cụ thể',
                  'Số nhà, tên tòa nhà, tên đường, tên khu vực'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _editAddress,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: const Text(
                  'Cập nhật',
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
      TextEditingController controller, String label, String placeholder) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: placeholder,
        ),
      ),
    );
  }
}
