import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storesalephone/Provider/DetailProvider.dart';

Widget customImgColor(String img, int index, DetailProvider value) {
  return Padding(
    padding: const EdgeInsets.only(right: 10, top: 10, bottom: 10),
    child: Container(
      width: 50,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
            width: 2,
            color: value.selectedIndexColor == index
                ? Colors.indigo
                : const Color.fromARGB(157, 209, 213, 213)),
      ),
      child: Center(
        child: Image.network(
          img,
          fit: BoxFit.contain,
          width: 100,
          height: 100,
        ),
      ),
    ),
  );
}

class ChoiceColor extends StatelessWidget {
  const ChoiceColor({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Align(
            alignment: Alignment.topLeft,
            child: Text(
              "Màu sắc",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            )),
        Consumer<DetailProvider>(builder:
            (BuildContext context, DetailProvider value, Widget? child) {
          return Align(
            alignment: Alignment.bottomLeft,
            child: SizedBox(
              height: 80,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: value.product.colors == null
                    ? 0
                    : value.product.colors?.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (_, index) {
                  return InkWell(
                      onTap: () async {
                        await value.hello(index);
                      },
                      child: customImgColor(
                          value.product.colors![index].img.toString(),
                          index,
                          value));
                },
              ),
            ),
          );
        })
      ],
    );
  }
}
