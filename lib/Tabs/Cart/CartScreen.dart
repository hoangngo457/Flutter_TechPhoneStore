import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:storesalephone/Model/Address.dart';
import 'package:storesalephone/MyAppScreen.dart';
import 'package:storesalephone/Provider/CartProvider.dart';
import 'package:storesalephone/Tabs/Cart/EditCart.dart';
import 'package:storesalephone/Tabs/Payment/shipping_page.dart';
import '../../Api/CartApi.dart';
import 'package:storesalephone/Model/Cart.dart';

import 'package:http/http.dart' as http;

class ProductCart extends StatefulWidget {
  const ProductCart({super.key});

  @override
  State<ProductCart> createState() => ProductCartState();
}

class ProductCartState extends State<ProductCart> {
  int id = 0;
  var lstProStr = "";
  bool isCheckedFull = false;
  List<bool> isCheckedList =
      []; // Danh sách lưu trữ trạng thái checked của từng sản phẩm
  List<CartDetail> cartItems = [];
  bool isLoading = true;
  late Future<List<Address>> futureAddresses;
  Map<int, bool> defaultAddresses = {};
  List<CartDetail> selectedItems = [];

  @override
  void initState() {
    super.initState();
    _fetchCartItems();
  }

  Future<int?> fetchIDAddress() async {
    int? idDefault = 0;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId =
        prefs.getInt('userId') ?? 1; // Lấy id người dùng từ SharedPreferences
    String apiUrl = dotenv.env['URL'].toString();
    final response = await http
        .get(Uri.parse('$apiUrl/api/get-all-Address-by-Iduser?id=$userId'));

    if (response.statusCode == 200) {
      print("Lấy id địa chỉ mặc định người dùng thành công ");
      final data = jsonDecode(response.body);
      List<Address> addresses =
          (data["Address"] as List).map((i) => Address.fromJson(i)).toList();
      if (addresses.isNotEmpty) {
        idDefault = addresses.first.id; // Lấy ID của phần tử đầu tiên
      }
      print("id la: $idDefault");
      return idDefault;
    } else {
      throw Exception('Lỗi khi gọi API Address');
    }
  }

  Future<void> _fetchCartItems() async {
    try {
      cartItems = await CartApi().fetchAllCart();

      isCheckedList = List.generate(cartItems.length, (index) => false);
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
    Provider.of<CartProvider>(context, listen: false).add();
  }

  Future<void> _updateCartItem(int id, int newQuantity) async {
    try {
      await CartApi().updateCart(id, newQuantity);
      for (int i = 0; i < cartItems.length; i++) {
        if (cartItems[i].idCart == id) {
          setState(() {
            cartItems[i].quantity = newQuantity;
          });
        }
      }

      print("Cập nhật thành công");
    } catch (e) {
      print("Lỗi khi cập nhật: $e");
    }
  }

  Future<void> _deleteCartItem(int id) async {
    try {
      await CartApi().deleteCart(id);
      setState(() {
        cartItems.removeWhere((item) => item.idCart == id);
      });
      Provider.of<CartProvider>(context, listen: false).remove();
      print("Xóa thành công");
    } catch (e) {
      print("Lỗi khi xóa: $e");
    }
  }

  Future<void> _showDeleteConfirmationDialog(int id) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Xác nhận xóa"),
          content: const Text("Bạn có chắc chắn muốn xóa sản phẩm này?"),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Hủy bỏ",
                style: TextStyle(color: Color.fromARGB(255, 77, 77, 77)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                "Xác nhận",
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                _deleteCartItem(id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
        builder: (BuildContext context, CartProvider value, Widget? child) {
      return Scaffold(
        appBar: cartItems.isEmpty
            ? AppBar(
                leading: IconButton(
                  icon: const Icon(CupertinoIcons.back), // Icon back của iOS
                  onPressed: () {
                    Navigator.pop(
                        context); // Đóng màn hình và quay lại màn hình trước đó
                  },
                ),
                title: Text(
                  "Giỏ hàng",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontSize: 20), // Thiết lập style cho tiêu đề
                ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(
                      1.0), // Chiều cao của đường ngăn cách
                  child: Container(
                    height: 1.0,
                    color: Colors.grey,
                  ),
                ),
              )
            : PreferredSize(
                preferredSize: const Size.fromHeight(90),
                child: Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              CupertinoIcons.back,
                              color: Colors.black,
                              size: 30,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const EditCart()));
                            },
                            child: const Text(
                              'Sửa',
                              style: TextStyle(
                                color: Color.fromARGB(255, 65, 65, 65),
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Row(
                          children: [
                            Checkbox(
                              value: isCheckedFull,
                              onChanged: (bool? value1) {
                                setState(() {
                                  isCheckedFull = value1!;
                                  // Khởi tạo lại isCheckedList với chiều dài tương ứng
                                  isCheckedList = List.generate(
                                    cartItems.length,
                                    (index) => isCheckedFull,
                                  );
                                  //cập nhật item được chọn
                                  if (isCheckedFull) {
                                    selectedItems = List.from(cartItems);
                                  } else {
                                    selectedItems.clear();
                                  }
                                });
                              },
                            ),
                            const Text('Tất cả'),
                            const SizedBox(
                              width: 50,
                            ),
                            const Expanded(
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'Giỏ hàng',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 30,
                                  ),
                                ),
                              ),
                            ),
                            const Spacer(),
                          ],
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey,
                              width: 3.0,
                            ),
                          ),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(7.0),
                            bottomRight: Radius.circular(7.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Container(
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 250, 250, 250)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: cartItems.isEmpty
                          ? noItem()
                          : ListView.builder(
                              itemCount: cartItems.length,
                              itemBuilder: (context, index) {
                                var ind = index;
                                return itemListView(cartItems[index], ind);
                              },
                            ),
                    ),
                  ],
                ),
              ),
        bottomNavigationBar: BottomAppBar(
          padding: EdgeInsets.zero,
          height: 120,
          child: Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Color.fromARGB(100, 86, 86, 86),
                  width: 2.5,
                ),
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              color: Color.fromARGB(255, 255, 255, 255),
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: 15,
                ),
                Builder(
                  builder: (context) {
                    int itemCount = 0;
                    double totalPrice = 0;

                    for (int i = 0; i < cartItems.length; i++) {
                      if (isCheckedList[i]) {
                        if (cartItems[i] == 1) {
                          itemCount++;
                        } else {
                          itemCount =
                              itemCount + cartItems[i].quantity!.toInt();
                        }

                        totalPrice += cartItems[i].productData!.price! *
                            (cartItems[i].quantity!.toInt());
                      }
                    }

                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Text(
                                '$itemCount sản phẩm',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Row(
                                children: [
                                  const Text("Tổng tiền: "),
                                  Text(
                                    NumberFormat('###,### đ')
                                        .format(totalPrice),
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 360,
                              height: 50,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 56, 56, 238),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                onPressed: () async {
                                  bool hasSelectedItems =
                                      isCheckedList.contains(true);

                                  if (!hasSelectedItems) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor: Colors.transparent,
                                        elevation: 0,
                                        content: Container(
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: Colors.black87,
                                            borderRadius:
                                                BorderRadius.circular(24),
                                          ),
                                          child: const Text(
                                            'Bạn chưa chọn sản phẩm nào để thực hiện đặt hàng',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        behavior: SnackBarBehavior.floating,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 10),
                                        duration: const Duration(seconds: 1),
                                      ),
                                    );
                                  } else {
                                    setState(() {});
                                    int? idDefault = await fetchIDAddress();
                                    id = idDefault ?? 0;

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ShippingPage(
                                          addressId: id,
                                          lstPrd: selectedItems,
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: const Text(
                                  'Đặt hàng',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget noItem() {
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.fromLTRB(20, 50, 0, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/no_product_cart.png',
            width: 300,
            height: 300,
            fit: BoxFit.contain,
          ),
          const Text(
            "Giỏ hàng đang trống",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
          ),
          const Text(
            "Hãy bắt đầu mua sắm ngay nào!",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget itemListView(CartDetail product, int index) {
    List<String> memoryValues = product.productData!.rams!
        .expand((ram) => ram.memory!)
        .map((memory) => memory.name!.toString())
        .toList();
    List<String> ramValues =
        product.productData!.rams!.map((m) => m.name.toString()).toList();

    print("$ramValues, $memoryValues");
    String selectedRam = product.productData!.rams!.first.name.toString();
    String selectedStorage =
        product.productData!.rams!.first.memory!.first.name.toString();

    String? selectedColor = product.productData!.color!.name;
    print("$selectedRam, $selectedStorage, $selectedColor");

    return Container(
      margin: const EdgeInsets.fromLTRB(8, 10, 8, 5),
      child: Container(
        padding: const EdgeInsets.all(5),
        height: 130,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: SizedBox(
          child: Row(
            children: [
              Checkbox(
                value: isCheckedList[index],
                onChanged: (value) {
                  setState(() {
                    isCheckedList[index] = value!;

                    isCheckedFull =
                        isCheckedList.every((element) => element == true);

                    if (value) {
                      selectedItems.add(product);
                    } else {
                      selectedItems.remove(product);
                    }
                  });
                },
              ),
              Image.network(
                product.productData!.images![0].name.toString(),
                height: 80,
                width: 80,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.image),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.productData?.product?.name ?? '',
                      overflow: TextOverflow
                          .ellipsis, // Sử dụng dấu "..." để cắt ngắn văn bản
                      maxLines: 1, // Giới hạn số dòng
                      softWrap: false, // Ngăn ngắt dòng tự động
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 40,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 75,
                            child: DropdownButton<String>(
                              value: selectedStorage,
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedStorage = newValue!;
                                });
                              },
                              items: memoryValues.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    int.parse(value) < 1000
                                        ? "${value}GB"
                                        : "${int.parse(value) ~/ 1000}TB",
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            width: 80,
                            child: DropdownButton<String>(
                              value: selectedRam,
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedRam = newValue!;
                                });
                              },
                              items: ramValues.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text("${value}GB"),
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            selectedColor!,
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          NumberFormat('###,###.###').format(
                              product.productData!.price! *
                                  (product.quantity!.toInt())),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                int newQuantity;
                                if (product.quantity! > 0) {
                                  newQuantity = product.quantity! - 1;
                                } else {
                                  newQuantity = product.quantity!;
                                }
                                setState(() {
                                  if (newQuantity == 0) {
                                    print("sl bằng 0");
                                    _showDeleteConfirmationDialog(
                                        product.idCart!);
                                  } else {
                                    _updateCartItem(
                                        product.idCart!, newQuantity);
                                  }
                                });
                              },
                            ),
                            Text(
                              '${product.quantity}',
                              style: const TextStyle(fontSize: 18),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                setState(() {
                                  int newQuantity = product.quantity! + 1;
                                  _updateCartItem(product.idCart!, newQuantity);
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
