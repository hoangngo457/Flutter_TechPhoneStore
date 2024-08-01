import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storesalephone/CommonWidget/CardProduct.dart';
import 'package:storesalephone/Model/OptionProduct.dart';
import 'package:storesalephone/Provider/DetailProvider.dart';
import 'package:storesalephone/Tabs/Detail/DetailSceen.dart';

class HomeBestSeller extends StatelessWidget {
  const HomeBestSeller({super.key, required this.products});
  final List<OptionProduct> products;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Siêu khuyến mãi",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              Text(
                "Tất cả",
                style: TextStyle(fontSize: 12, color: Colors.black),
              )
            ],
          ),
        ),
        GridView.builder(
            itemCount: products.length,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.all(10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.0,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
              mainAxisExtent: 330,
            ),
            itemBuilder: (_, index) {
              return Consumer<DetailProvider>(builder:
                  (BuildContext context, DetailProvider value, Widget? child) {
                return InkWell(
                    onTap: () async {
                      final SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      int? idProduct = products[index].product?.id;
                      int? idColor = products[index].color?.id;
                      await prefs.setInt('idColor', idColor!);
                      await prefs.setInt('idProduct', idProduct!);

                      await value.init();

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const DetailScreen()));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade500,
                              spreadRadius: 1.0,
                              blurRadius: 15,
                              offset: const Offset(
                                  4.0, 4.0), // changes position of shadow
                            ),
                            const BoxShadow(
                              color: Colors.white,
                              spreadRadius: 1.0,
                              blurRadius: 15,
                              offset: Offset(
                                  -4.0, -4.0), // changes position of shadow
                            ),
                          ]),
                      child: CardProduct(
                        product: products[index],
                        type: "hot",
                      ),
                    ));
              });
            })
      ],
    );
  }
}
