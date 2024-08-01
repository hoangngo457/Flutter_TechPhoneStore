import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storesalephone/CommonWidget/CardProduct.dart';
import 'package:storesalephone/Model/OptionProduct.dart';
import 'package:storesalephone/Provider/CartProvider.dart';
import 'package:storesalephone/Provider/DetailProvider.dart';
import 'package:storesalephone/Tabs/Detail/DetailSceen.dart';
import 'package:storesalephone/Tabs/Favorite/SetUpData.dart';
import 'package:toastification/toastification.dart';

class FavoriteView extends StatefulWidget {
  const FavoriteView({super.key});

  @override
  State<StatefulWidget> createState() => FavoriteState();
}

class FavoriteState extends State<FavoriteView> {
  List<OptionProduct> products = [];

  Future<void> setUpProcess() async {
    SetUpData setUpData = SetUpData();
    List<OptionProduct> listProducts = await setUpData.getDataProductFavorite();
    setState(() {
      products = listProducts;
    });
  }

  @override
  void initState() {
    super.initState();
    setUpProcess();
  }

  void showSuccessToast() {
    toastification.show(
      context: context,
      type: ToastificationType.success,
      style: ToastificationStyle.fillColored,
      title: const Text('Bỏ thích thành công!'),
      description: const Text('Bạn đã bỏ thích sản phẩm thành công.'),
      alignment: Alignment.centerLeft,
      autoCloseDuration: const Duration(seconds: 4),
      primaryColor: const Color(0xff24b926),
      backgroundColor: const Color(0xff4682b4),
      icon: const Icon(Iconsax.tick_circle),
      showProgressBar: true,
      dragToClose: true,
    );
  }

  Future<void> deleteFav(idPro, idColor) async {
    SetUpData setUpData = SetUpData();
    await setUpData.deleteFavorite(idPro, idColor);
    setUpProcess();
    showSuccessToast();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Yêu thích",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 20),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Container(
            height: 1.0,
            color: Colors.grey,
          ),
        ),
      ),
      body: products.isEmpty
          ? Stack(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 0, 10),
                  child: Image.asset(
                    'assets/favories.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
                const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Trang yêu thích của bạn đang trống ',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : SingleChildScrollView(
              child: GridView.builder(
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
                    return Container(
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
                        child: Stack(
                          children: [
                            Consumer<DetailProvider>(builder:
                                (BuildContext context, DetailProvider value,
                                    Widget? child) {
                              return InkWell(
                                  onTap: () async {
                                    final SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    int? idProduct =
                                        products[index].product?.id;
                                    int? idColor = products[index].color?.id;
                                    await prefs.setInt('idColor', idColor!);
                                    await prefs.setInt('idProduct', idProduct!);
                                    value.init();
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const DetailScreen()));
                                  },
                                  child: CardProduct(
                                    product: products[index],
                                    type: "fav",
                                  ));
                            }),
                            Container(
                                padding: const EdgeInsets.only(
                                    left: 10, right: 0, top: 0, bottom: 0),
                                child: Consumer<CartProvider>(
                                  builder: (BuildContext context,
                                      CartProvider value, Widget? child) {
                                    return Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            // Xử lý sự kiện khi nhấn nút "Bỏ Thích"
                                            int? idPro =
                                                products[index].product?.id;
                                            int? idColor =
                                                products[index].color?.id;
                                            deleteFav(idPro, idColor);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            minimumSize: const Size(5, 30),
                                            foregroundColor: Colors.white,
                                            backgroundColor: Colors
                                                .red, // Màu chữ và biểu tượng
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 10),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                          ),
                                          child: const Icon(
                                              Icons.favorite_border,
                                              size: 18),
                                        ),
                                      ],
                                    );
                                  },
                                )),
                          ],
                        ));
                  }),
            ),
    );
  }
}
