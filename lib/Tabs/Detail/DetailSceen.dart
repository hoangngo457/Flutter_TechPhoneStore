import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storesalephone/Model/OptionProduct.dart';
import 'package:storesalephone/Provider/CartProvider.dart';
import 'package:storesalephone/Provider/DetailProvider.dart';
import 'package:storesalephone/Tabs/Cart/CartScreen.dart';
import 'package:storesalephone/Tabs/Detail/Component/DetailAddCart.dart';
import 'package:storesalephone/Tabs/Detail/Component/DetailChoiceColor.dart';
import 'package:storesalephone/Tabs/Detail/Component/DetailChoiceFavorite.dart';
import 'package:storesalephone/Tabs/Detail/Component/DetailChoiceRam.dart';
import 'package:storesalephone/Tabs/Detail/Component/DetailChoiceRom.dart';
import 'package:storesalephone/Tabs/Detail/Component/DetailContentText.dart';
import 'package:storesalephone/Tabs/Detail/Component/DetailViewImage.dart';
import 'package:storesalephone/Tabs/Detail/Component/ComponentTab/Tab/DetailParameterView.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key});
  @override
  State<StatefulWidget> createState() => DetailScreenState();
}

class DetailScreenState extends State<DetailScreen> {
  OptionProduct product = OptionProduct();
  int selectedIndexColor = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor:
            // const Color.fromARGB(255, 255, 255, 255).withOpacity(0.9),
            Colors.indigoAccent,
        body: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverAppBar(
                  leadingWidth: 100,
                  backgroundColor: Colors.transparent,
                  leading: Consumer<DetailProvider>(
                    builder: (BuildContext context, DetailProvider value,
                        Widget? child) {
                      return InkWell(
                          onTap: () {
                            value.resetSelected();
                            Navigator.pop(context);
                          },
                          child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    child: const Icon(
                                      CupertinoIcons.back,
                                      size: 30,
                                    ),
                                  ),
                                ],
                              )));
                    },
                  ),
                  actions: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: InkWell(onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ProductCart(),
                            ));
                        // value.setSelectedFavorite();
                      }, child: Consumer<CartProvider>(
                        builder: (BuildContext context, CartProvider value,
                            Widget? child) {
                          return Center(
                            child: SizedBox(
                                child: Stack(
                              children: [
                                const Image(
                                  image: AssetImage(
                                      "assets/shopping-bag-black.png"),
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
                                          shape: BoxShape.circle,
                                          color: Colors.red),
                                      child: Text(
                                        value.cart.length.toString(),
                                        style: const TextStyle(
                                            fontSize: 10,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                    ))
                              ],
                            )),
                          );
                        },
                      )),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    const ChoiceFavorite(),
                    const SizedBox(
                      width: 20,
                    ),
                  ],
                  floating: true,
                  // pinned: true,
                  snap: true,
                ),
                SliverToBoxAdapter(
                  child: SingleChildScrollView(
                      child: Container(
                    decoration: const BoxDecoration(
                        // color: Color.fromARGB(168, 222, 217, 217),
                        ),
                    child: Column(
                      children: [
                        const ViewImage(),
                        Container(
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(30),
                                  topLeft: Radius.circular(30))),
                          padding: const EdgeInsets.all(20),
                          child: const Column(
                            children: [
                              ContentText(),
                              ChoiceColor(),
                              SizedBox(
                                height: 10,
                              ),
                              ChoiceRam(),
                              SizedBox(
                                height: 20,
                              ),
                              ChoiceRom(),
                              SizedBox(
                                height: 100,
                              ),
                              // OverviewCompany(),
                            ],
                          ),
                        ),
                        // const TabScreen(),
                      ],
                    ),
                  )),
                )
              ],
            ),
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  margin: const EdgeInsets.all(15),
                  child: Row(
                    children: [
                      const Expanded(child: AddCart()),
                      const SizedBox(
                        width: 20,
                      ),
                      Container(
                          decoration: const BoxDecoration(
                              color: Colors.white, shape: BoxShape.circle),
                          height: 60,
                          width: 50,
                          child: InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(30.0)),
                                ),
                                context: context,
                                builder: (context) {
                                  return const SingleChildScrollView(
                                    child: ParameterView(),
                                  );
                                },
                              );
                            },
                            child: const Image(
                              image: AssetImage("assets/smartphone.png"),
                              width: 20,
                              height: 20,
                            ),
                          )),
                    ],
                  ),
                ))
          ],
        ));
  }
}
