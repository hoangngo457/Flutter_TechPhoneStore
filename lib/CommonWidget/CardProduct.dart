import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';

import 'package:storesalephone/Model/OptionProduct.dart';


final vietnameseCurrencyFormat =
    NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

class CardProduct extends StatelessWidget {
  const CardProduct({super.key, required this.product, required this.type});

  final OptionProduct product;
  final String type;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Image.network(product.images![0].name.toString(),
                  height: 125, fit: BoxFit.contain, width: double.infinity),
            ),
            type == "hot"
                ? const Padding(
                    padding: EdgeInsets.all(5),
                    child: Row(children: [HotTag()]),
                  )
                : const Text(""),
            // const Positioned(top: 5, right: 5, child: DiscountTag())
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            product.product!.name.toString(),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Container(
            padding: const EdgeInsets.all(5),
            width: double.infinity,
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 240, 245, 254),
                borderRadius: BorderRadius.circular(5)),
            child: Wrap(
                direction: Axis.horizontal,
                spacing: 5,
                runSpacing: 10,
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.center,
                children: [
                  miniInfo(
                      const Icon(
                        Icons.memory,
                        size: 15,
                      ),
                      product.product!.system.toString()),
                  miniInfo(
                      const Icon(
                        Icons.memory,
                        size: 15,
                      ),
                      "${product.rams![0].name} GB"),
                  miniInfo(
                      const Icon(
                        LineIcons.mobilePhone,
                        size: 15,
                      ),
                      product.product!.display.toString()),
                  miniInfo(
                      const Icon(
                        LineIcons.microchip,
                        size: 15,
                      ),
                      product.product!.cpu.toString()),
                ]),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Expanded(
            child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Row(
                  children: [
                    Expanded(
                        child: Text(
                      vietnameseCurrencyFormat.format(product.price),
                      style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    )),
                  ],
                ))),
        Container(
          padding: const EdgeInsets.all(10),
          width: double.infinity,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                      product.feedbacks!.isNotEmpty
                          ? product.getSumRating().toString()
                          : "Không có",
                      style: const TextStyle(
                          fontSize: 10, color: Colors.orangeAccent)),
                  const SizedBox(width: 2),
                  product.feedbacks!.isEmpty
                      ? const Text("")
                      : const Icon(
                          Icons.star,
                          size: 11,
                          color: Colors.orangeAccent,
                        ),
                  const SizedBox(width: 4),
                  Text(
                      product.feedbacks!.isEmpty
                          ? ""
                          : "(${product.feedbacks!.length})",
                      style: const TextStyle(fontSize: 10))
                ],
              ),
              const Spacer(),
              Text("Đã bán ${product.sold}",
                  textAlign: TextAlign.end,
                  style: const TextStyle(fontSize: 10))
            ],
          ),
        ),
      ],
    );
  }
}

Widget miniInfo(Icon icon, String value) {
  return Container(
      constraints: const BoxConstraints(minWidth: 70),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          const SizedBox(
            width: 5,
          ),
          Text(
            value.toString(),
            overflow: TextOverflow.fade,
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          )
        ],
      ));
}

// class DiscountTag extends StatelessWidget {
//   const DiscountTag({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         constraints: const BoxConstraints(maxWidth: 50),
//         height: 20,
//         alignment: Alignment.center,
//         decoration: BoxDecoration(
//             color: const Color.fromARGB(255, 255, 193, 7),
//             borderRadius: BorderRadius.circular(5)),
//         child: const Text(
//           "Giảm 20%",
//           style: TextStyle(fontSize: 8, color: Colors.white),
//         ));
//   }
// }

class HotTag extends StatelessWidget {
  const HotTag({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      // constraints: const BoxConstraints(maxWidth: 70),
      alignment: Alignment.center,
      // height: 25,
      padding: const EdgeInsets.only(right: 10, top: 5, left: 5, bottom: 5),
      decoration: BoxDecoration(
          color: Colors.red, borderRadius: BorderRadius.circular(5)),
      child: Row(
        children: [
          const SizedBox(
            width: 2,
          ),
          Container(
            width: 15,
            height: 15,
            decoration: const BoxDecoration(
                color: Colors.white, shape: BoxShape.circle),
            child: const Image(
              image: AssetImage("assets/fire.png"),
              width: 10,
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          const Text(
            "Hot",
            style: TextStyle(fontSize: 12, color: Colors.white),
          )
        ],
      ),
    );
  }
}
