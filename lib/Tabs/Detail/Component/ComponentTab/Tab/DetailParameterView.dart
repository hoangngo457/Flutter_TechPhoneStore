import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storesalephone/Provider/DetailProvider.dart';

class ParameterView extends StatelessWidget {
  const ParameterView({super.key});

  Widget getItem(String title, String value, bool color) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: color == true
              ? const Color.fromARGB(255, 232, 232, 236)
              : Colors.transparent),
      child: Row(
        children: [
          Expanded(child: Text(title)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DetailProvider>(
      builder: (BuildContext context, DetailProvider value, Widget? child) {
        return Container(
          padding:
              const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              getItem(
                  "Màn hình",
                  value.product.product == null
                      ? ""
                      : value.product.product!.display.toString(),
                  true),
              getItem("Hiển thị", "Dynamic AMOLED", false),
              getItem(
                  "Camera trước",
                  value.product.product == null
                      ? ""
                      : value.product.product!.camera.toString(),
                  true),
              getItem(
                  "Camera sau",
                  value.product.product == null
                      ? ""
                      : value.product.product!.camera.toString(),
                  false),
              getItem(
                  "Chipset",
                  value.product.product == null
                      ? ""
                      : value.product.product!.cpu.toString(),
                  true),
              getItem(
                  "Dung lượng RAM",
                  value.product.product == null
                      ? ""
                      : value.product.product!.ram.toString(),
                  false),
              getItem(
                  "Bộ nhớ trong",
                  value.product.product == null
                      ? ""
                      : value.product.product!.rom.toString(),
                  true),
              getItem(
                  "Pin",
                  value.product.product == null
                      ? ""
                      : value.product.product!.battery.toString(),
                  false),
              getItem(
                  "Hệ điều hành",
                  value.product.product == null
                      ? ""
                      : value.product.product!.system.toString(),
                  true),
            ],
          ),
        );
      },
    );
  }
}
