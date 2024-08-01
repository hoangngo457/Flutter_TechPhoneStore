import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:storesalephone/Provider/CartProvider.dart';
import 'package:storesalephone/Tabs/Cart/CartScreen.dart';
import '../../Api/CartApi.dart';
import 'package:storesalephone/Model/Cart.dart';
//import './edit_cart.dart';

class EditCart extends StatefulWidget {
  const EditCart({super.key});

  @override
  State<EditCart> createState() => EditCartState();
}

class EditCartState extends State<EditCart> {
  var lstProStr = "";
  bool isCheckedFull = false;
  List<bool> isCheckedList =
      []; // Danh sách lưu trữ trạng thái checked của từng sản phẩm
  List<CartDetail> cartItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCartItems();
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

      Provider.of<CartProvider>(context, listen: false).add();

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

  Future<void> _deleteSelectedItems() async {
    try {
      List<int> idsToDelete = [];
      for (int i = 0; i < cartItems.length; i++) {
        if (isCheckedList[i]) {
          idsToDelete.add(cartItems[i].idCart!);
        }
      }

      for (int id in idsToDelete) {
        await _deleteCartItem(id);
      }

      print("Đã xóa các sản phẩm đã chọn");
    } catch (e) {
      print("Lỗi khi xóa các sản phẩm đã chọn: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: cartItems.isEmpty
          ? PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: AppBar(
                leading: IconButton(
                  icon: const Icon(
                    CupertinoIcons.back,
                    color: Colors.black,
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                title: const Text(
                  'Giỏ hàng',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 28,
                  ),
                ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(4.0),
                  child: Container(
                    height: 2.0,
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.all(Radius.circular(2.0)),
                    ),
                  ),
                ),
              ),
            )
          : PreferredSize(
              preferredSize: const Size.fromHeight(100),
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
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const ProductCart()));
                          },
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () async {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const ProductCart()));
                          },
                          child: const Text(
                            'Xong',
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

                                isCheckedList = List.generate(
                                  cartItems.length,
                                  (index) => isCheckedFull,
                                );
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
                    child: ListView.builder(
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
        height: 85,
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
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 360,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 175, 19, 19),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: () async {
                            await _deleteSelectedItems();
                            if (cartItems.isEmpty) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ProductCart()));
                            }
                            _fetchCartItems();
                          },
                          // onPressed: () {
                          //   _deleteSelectedItems();

                          // },
                          child: const Text(
                            'Xóa',
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget itemListView(CartDetail product, int ind) {
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

    //String selectedStorage = product.productData!.rams!.join(Ram().memory!.join(Memory().name.toString()));
    //String selectedRam = product.productData!.rams!.join(Ram().name.toString());
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
                value: isCheckedList[ind],
                onChanged: (value) {
                  setState(() {
                    isCheckedList[ind] = value!;

                    isCheckedFull =
                        isCheckedList.every((element) => element == true);
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
                      product.productData?.product?.name! ?? '',
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
                            width: 75, // Đặt độ rộng tùy ý cho DropdownButton
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
                            width: 65,
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
