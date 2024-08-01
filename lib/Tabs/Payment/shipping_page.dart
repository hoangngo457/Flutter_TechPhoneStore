// ignore_for_file: non_constant_identifier_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:storesalephone/Api/AddressApi.dart';
import 'package:storesalephone/Api/CartApi.dart';
import 'package:storesalephone/Api/OrderApi.dart';
import 'package:storesalephone/Model/Address.dart';
import 'package:storesalephone/Model/Cart.dart';
import 'package:storesalephone/Provider/CartProvider.dart';
import 'package:storesalephone/Tabs/Address/AddressPayment.dart';
import 'package:storesalephone/Tabs/Cart/CartScreen.dart';
import 'package:toastification/toastification.dart';

import 'order_result_page.dart';

class ShippingPage extends StatefulWidget {
  final int addressId;
  final List<CartDetail> lstPrd;
  const ShippingPage({required this.addressId, required this.lstPrd});

  @override
  State<ShippingPage> createState() => _ShippingPageState();
}

class _ShippingPageState extends State<ShippingPage> {
  final OrderApi orderApi = OrderApi();
  String status = 'Chờ xác nhận';
  int total = 0;
  String payment = 'Thanh toán khi nhận hàng';
  late int idAddress;
  late Future<Address> futureAddress;
  List<CartDetail> productItem = [];

  int totalPrice() {
    for (int i = 0; i < productItem.length; i++) {
      total = total +
          productItem[i].productData!.price! *
              (productItem[i].quantity!.toInt());
    }
    return total;
  }

  void showSuccessToast(String message) {
    toastification.show(
      context: context,
      type: ToastificationType.success,
      style: ToastificationStyle.fillColored,
      title: const Text('Đặt hàng Thành công!'),
      description: Text(message),
      alignment: Alignment.centerLeft,
      autoCloseDuration: const Duration(seconds: 4),
      primaryColor: const Color(0xff24b926),
      backgroundColor: const Color(0xff4682b4),
      icon: const Icon(Icons.check_circle),
      showProgressBar: true,
      dragToClose: true,
    );
  }

  void showFailToast(String message) {
    toastification.show(
      context: context,
      type: ToastificationType.error,
      style: ToastificationStyle.fillColored,
      title: const Text(
        'Đặt hàng Thất bại!',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      description: Text(
        message,
        style: const TextStyle(fontSize: 16),
      ),
      alignment: Alignment.centerLeft,
      autoCloseDuration: const Duration(seconds: 4),
      primaryColor: const Color.fromARGB(255, 220, 65, 65),
      backgroundColor: const Color(0xff4682b4),
      icon: const Icon(Icons.close),
      borderRadius: BorderRadius.circular(12.0),
      showProgressBar: true,
      dragToClose: true,
    );
  }

  @override
  void initState() {
    super.initState();
    idAddress = widget.addressId;
    productItem = widget.lstPrd;
    futureAddress = AddressApi().fetchAddressById(idAddress);
    totalPrice();
  }

  Future<void> _placeOrder() async {
    if (idAddress == 0) {
      showFailToast('Vui lòng chọn địa chỉ');
    } else {
      final response =
          await orderApi.fetchOrder(status, total, payment, idAddress);

      if (response['errcode'] == 0) {
        int order_id = response['id'];
        List<Map<String, dynamic>> orderDetails = [];

        for (int i = 0; i < productItem.length; i++) {
          int idOpt = productItem[i].productData!.codeOption!;
          int quantity = productItem[i].quantity!;

          // Thêm một map mới vào danh sách orderDetails
          orderDetails.add({
            'order_id': order_id.toString(),
            'quantity': quantity,
            'idOpt': idOpt.toString(),
          });
        }

        final response1 = await orderApi.fetchOrderDetails(orderDetails);
        if (response1['errcode'] == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderResultPage(),
            ),
          );
          showSuccessToast('Bạn đã đặt hàng thành công');
        }
      } else {
        showFailToast('Đặt hàng thất bại');
      }
    }
  }

  Future<void> _deleteCartItem(int id) async {
    try {
      await CartApi().deleteCart(id);
      setState(() {
        productItem.removeWhere((item) => item.idCart == id);
      });
      Provider.of<CartProvider>(context, listen: false).remove();
      print("Xóa thành công");
    } catch (e) {
      print("Lỗi khi xóa: $e");
    }
  }

  Future<void> deleteOnItem() async {
    try {
      List<int> idproduct = [];
      for (int i = 0; i < productItem.length; i++) {
        idproduct.add(productItem[i].idCart!);
      }
      for (int id in idproduct) {
        await _deleteCartItem(id);
      }
    } catch (e) {
      print("Lỗi khi xóa: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back), // Icon back của iOS
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProductCart(),
              ),
            );
          },
        ),
        title: Text(
          "Đặt hàng",
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontSize: 20), // Thiết lập style cho tiêu đề
        ),
        bottom: PreferredSize(
          preferredSize:
              const Size.fromHeight(1.0), // Chiều cao của đường ngăn cách
          child: Container(
            height: 1.0,
            color: Colors.grey,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration:
              const BoxDecoration(color: Color.fromARGB(190, 255, 255, 255)),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    color: Colors.white,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddressPaymentPage(
                                  selectedItems: productItem)),
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Icon(Icons.location_on, color: Colors.indigoAccent),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Địa chỉ nhận hàng'),
                                Text('Thêm địa chỉ',
                                    style:
                                        TextStyle(color: Colors.indigoAccent)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  FutureBuilder<Address>(
                    future: futureAddress,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return const Center(
                            child: Text(
                                'Bạn chưa có địa chỉ vui lòng thêm địa chỉ'));
                      } else if (snapshot.hasData) {
                        final address = snapshot.data!;
                        return Card(
                          color: Colors.white,
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: ListTile(
                            title: Text(address.name!),
                            subtitle: Text(
                              '${address.phoneNumber}\n${address.detailAdr}, ${address.ward}, ${address.district}, ${address.city}',
                            ),
                            trailing: const Text(
                              'Đang dùng',
                              style: TextStyle(color: Colors.indigoAccent),
                            ),
                          ),
                        );
                      } else {
                        return const Center(
                            child: Text(
                                'Bạn chưa có địa chỉ vui lòng thêm địa chỉ'));
                      }
                    },
                  ),
                ],
              ),
              Card(
                color: Colors.white,
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ListTile(
                      title: Text('Techphone Store'),
                    ),
                    const Divider(height: 1),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: productItem.length,
                      itemBuilder: (context, index) {
                        return CartProduct(productItem[index], index);
                      },
                    ),
                  ],
                ),
              ),
              Card(
                color: Colors.white,
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'Nhập mã giảm giá ( nếu có )',
                            contentPadding: const EdgeInsets.all(10),
                            suffixIcon: ElevatedButton(
                              onPressed: () {},
                              child: const Text('Áp Dụng'),
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        // const ListTile(
                        //   title: Text('Liên hệ Techphone'),
                        //   trailing: Text('Lưu ý cho người bán',
                        //       style: TextStyle(color: Colors.blue)),
                        // ),
                        const ListTile(
                          title: Text('Phương thức thanh toán'),
                          trailing: Text('Thanh toán khi nhận hàng',
                              style: TextStyle(color: Colors.indigoAccent)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Tổng quan
              Card(
                color: Colors.white,
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Tổng quan',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Tổng tiền hàng'),
                          Text(NumberFormat('###,### đ').format(total),
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 16)),
                        ],
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Tổng tiền phí vận chuyển'),
                          Text('Miễn phí vận chuyển',
                              style: TextStyle(color: Colors.green)),
                        ],
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Giảm giá'),
                          Text('0đ'),
                        ],
                      ),
                      const Divider(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Tổng thanh toán'),
                          Text(NumberFormat('###,### đ').format(total),
                              style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Center(
                child: ElevatedButton(
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.blue),
                  ),
                  onPressed: () {
                    _placeOrder();
                    deleteOnItem();
                  },
                  child: const Text(
                    'Đặt hàng',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget CartProduct(CartDetail cartDetail, int index) {
    Iterable<String> ramData =
        cartDetail.productData!.rams!.map((m) => m.name.toString());
    Iterable<String> strogareData = cartDetail.productData!.rams!
        .expand((ram) => ram.memory!)
        .map((memory) => memory.name!.toString());
    String ram = ramData.join(', ');
    String strogare = strogareData.join(', ');

    String? color = cartDetail.productData!.color!.name;
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 15, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.network(cartDetail.productData!.images![0].name.toString(),
              width: 80, height: 80, fit: BoxFit.cover),
          const SizedBox(
            width: 20,
          ),
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                cartDetail.productData?.product?.name ?? '',
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black),
              ),
              Text(
                  '${ram}GB, ${int.parse(strogare) < 1000 ? "${strogare}GB" : "${int.parse(strogare) ~/ 1000}TB"}, $color'),
              Text('Số lượng: ${cartDetail.quantity}'),
            ],
          )),
          Text('${formatCurrency(cartDetail.productData!.price!)} đ',
              style: const TextStyle(color: Colors.red, fontSize: 16)),
          const Divider(height: 1),
        ],
      ),
    );
  }

  String formatCurrency(int amount) {
    final NumberFormat formatter = NumberFormat('#,##0', 'vi_VN');
    return formatter.format(amount);
  }
}
