import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';

class OverviewCompany extends StatelessWidget {
  const OverviewCompany({super.key});
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Row(
          children: [
            Image(
              image: AssetImage("assets/premium-quality.png"),
              width: 20,
              height: 20,
            ),
            SizedBox(
              width: 10,
            ),
            Text("Chúng tôi Cam kết chất lượng 100 % ",
                style: TextStyle(fontSize: 12))
          ],
        ),
        SizedBox(
          height: 5,
        ),
        Row(
          children: [
            Image(
              image: AssetImage("assets/express-delivery.png"),
              width: 30,
              height: 30,
            ),
            SizedBox(
              width: 10,
            ),
            Text("Giao hàng nhanh chóng", style: TextStyle(fontSize: 12))
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Text(
              "Hotline:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            Text(
              " 032999888",
              style: TextStyle(
                  color: Colors.indigo,
                  fontWeight: FontWeight.bold,
                  fontSize: 13),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Text(
            "Cửa hàng:",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 5,
        ),
        Row(
          children: [
            Image(
              image: AssetImage("assets/store.png"),
              width: 20,
              height: 20,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              "83/41b Pham Van Bach P.15 ,Q.Tân Bình, TP HCM ",
              style: TextStyle(fontSize: 12),
            )
          ],
        ),
        SizedBox(
          width: 30,
        ),
      ],
    );
  }
}
