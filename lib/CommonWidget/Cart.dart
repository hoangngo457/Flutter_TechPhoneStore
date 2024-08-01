import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storesalephone/Provider/CartProvider.dart';
import 'package:storesalephone/Tabs/Cart/CartScreen.dart';

class CartStore extends StatelessWidget {
  const CartStore({super.key, required this.color});
  final String color;

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (BuildContext context, CartProvider value, Widget? child) {
        return InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProductCart(),
                ));
          },
          child: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: SizedBox(
                  child: Stack(
                children: [
                  Image(
                    image: AssetImage(color == "black"
                        ? "assets/shopping-bag-black.png"
                        : "assets/shopping-bag-white.png"),
                    width: 25,
                    height: 25,
                  ),
                  Positioned(
                      left: 0,
                      bottom: 0,
                      child: Container(
                        width: 15,
                        height: 15,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.red),
                        child: Text(
                          value.cartItemCount.toString(),
                          style: const TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ))
                ],
              ))),
        );
      },
    );
  }
}
