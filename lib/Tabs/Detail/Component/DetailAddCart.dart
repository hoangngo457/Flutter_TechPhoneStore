import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:storesalephone/Provider/CartProvider.dart';
import 'package:storesalephone/Provider/DetailProvider.dart';
import 'package:toastification/toastification.dart'; // Import toastification

void showSuccessToast(BuildContext context, String message) {
  toastification.show(
    context: context,
    type: ToastificationType.success,
    style: ToastificationStyle.fillColored,
    title: const Text('Thành công!'),
    description: Text(message),
    alignment: Alignment.centerLeft,
    autoCloseDuration: const Duration(seconds: 4),
    primaryColor: const Color(0xff24b926),
    backgroundColor: const Color(0xff4682b4),
    icon: const Icon(Icons.check_circle),
    showProgressBar: true,
    dragToClose: true,
  );
}

Widget handle(BuildContext context, DetailProvider value) {
  return Consumer<CartProvider>(
    builder: (BuildContext context, CartProvider value2, Widget? child) {
      return InkWell(
        onTap: () {
          value2.Add(1, value.product.codeOption);
          showSuccessToast(context, 'Thêm vào giỏ hàng thành công');
        },
        child: Container(
            decoration: BoxDecoration(
              color: Colors.indigoAccent,
              borderRadius: BorderRadius.circular(5),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Thêm vào giỏ hàng",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white)),
                SizedBox(
                  width: 10,
                ),
                Image(
                  image: AssetImage("assets/shopping-bag-white.png"),
                  width: 20,
                  height: 20,
                )
              ],
            )),
      );
    },
  );
}

class AddCart extends StatelessWidget {
  const AddCart({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<DetailProvider>(
      builder: (BuildContext context, DetailProvider value, Widget? child) {
        return SizedBox(height: 60, child: handle(context, value));
      },
    );
  }
}
