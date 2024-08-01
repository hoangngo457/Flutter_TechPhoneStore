import 'package:flutter/material.dart';
import 'package:storesalephone/Model/Category.dart';
import 'package:storesalephone/Model/OptionProduct.dart';
import 'package:storesalephone/Tabs/Home/Component/HomeBestSeller.dart';
import 'package:storesalephone/Tabs/Home/Component/HomeCarousel.dart';
import 'package:storesalephone/Tabs/Home/Component/HomeCategories.dart';
import 'package:storesalephone/Tabs/Home/Component/HomeSearch.dart';
import 'package:storesalephone/Tabs/Home/Component/HomeTitle.dart';
import 'package:storesalephone/Tabs/Home/HomeSetup.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<StatefulWidget> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  List<Category> brands = [];
  List<OptionProduct> products = [];

  Future<void> setUpProcess() async {
    SetUpData setUpData = SetUpData();
    List<Category> listCategoryApi = await setUpData.getDataCategory();
    List<OptionProduct> listProducts = await setUpData.getDataProduct();
    setState(() {
      brands = listCategoryApi;
      products = listProducts;
    });
  }

  @override
  void initState() {
    super.initState();
    setUpProcess();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.indigoAccent,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const HomeTitle(),
            const SizedBox(
              height: 30,
            ),
            const HomeSearch(),
            HomeCategories(brands: brands),
            const SizedBox(
              height: 10,
            ),
            Container(
                padding: const EdgeInsets.only(top: 10),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10))),
                child: Column(
                  children: [
                    const HomeCarousel(),
                    HomeBestSeller(
                      products: products,
                    ),
                    const SizedBox(
                      height: 100,
                    )
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
