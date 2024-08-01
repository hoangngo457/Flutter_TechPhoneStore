import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:storesalephone/Provider/CartProvider.dart';
import 'package:storesalephone/Provider/HomeProvider.dart';
import 'package:storesalephone/Tabs/Cart/CartScreen.dart';
import 'package:storesalephone/Tabs/ProfileHome/ProfileHome.dart';

import 'package:storesalephone/Tabs/SearchHome/ProductHome.dart';
import 'Tabs/Home/HomeScreen.dart';

class MyAppScreen extends StatefulWidget {
  const MyAppScreen({super.key});
  @override
  State<StatefulWidget> createState() => MyAppState();
}

class MyAppState extends State<MyAppScreen> {
  static List<Widget> pagesWidget = [
    const HomeScreen(),
    const ProductHome(),
    const ProductCart(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (BuildContext context, HomeProvider value, Widget? child) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              pagesWidget.elementAt(value.indexPage),
              // Align(
              //   alignment: Alignment.bottomLeft,
              //   child: Container(
              //       margin:
              //           const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              //       decoration: const BoxDecoration(boxShadow: [
              //         BoxShadow(
              //             color: Colors.black26,
              //             blurRadius: 30,
              //             offset: Offset(0, 20))
              //       ]),
              //       child: ClipRRect(
              //         borderRadius: const BorderRadius.all(Radius.circular(20)),
              //         child:
              //       )),
              // )
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: value.indexPage,
            selectedItemColor: Colors.indigo,
            onTap: (index) {
              value.setSelected(index);
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(LineIcons.home,
                    color: MaterialStateColor.resolveWith((states) =>
                        value.indexPage == 0 ? Colors.indigo : Colors.black)),
                label: 'Trang chủ',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.category_outlined,
                    color: MaterialStateColor.resolveWith((states) =>
                        value.indexPage == 1 ? Colors.indigo : Colors.black)),
                label: 'Sản phẩm',
              ),
              BottomNavigationBarItem(
                icon: Consumer<CartProvider>(
                  builder: (BuildContext context, CartProvider value2,
                      Widget? child) {
                    return SizedBox(
                        child: Stack(
                      children: [
                        Image(
                          image: AssetImage(value.indexPage == 2
                              ? "assets/shopping-bag-blue.png"
                              : "assets/shopping-bag-black.png"),
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
                                value2.cart.length.toString(),
                                style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ))
                      ],
                    ));
                  },
                ),
                label: 'Giỏ hàng',
              ),
              BottomNavigationBarItem(
                icon: Icon(LineIcons.user,
                    color: MaterialStateColor.resolveWith((states) =>
                        value.indexPage == 3 ? Colors.indigo : Colors.black)),
                label: 'Cá nhân',
              ),
            ],
          ),
        );
      },
    );
  }
}
