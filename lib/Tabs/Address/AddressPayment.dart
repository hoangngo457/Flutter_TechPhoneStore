import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:storesalephone/Api/AddressApi.dart';
import 'package:storesalephone/Model/Address.dart';
import 'package:storesalephone/Tabs/Address/updateAddress.dart';
import 'package:storesalephone/Tabs/Cart/CartScreen.dart';
import 'package:storesalephone/Tabs/Payment/shipping_page.dart';
import 'package:toastification/toastification.dart';
import 'addaddressPage.dart';
import 'package:storesalephone/Model/Cart.dart';

class AddressPaymentPage extends StatefulWidget {
  List<CartDetail> selectedItems;
  AddressPaymentPage({required this.selectedItems});

  @override
  State<AddressPaymentPage> createState() => _AddressPaymentPageState();
}

class _AddressPaymentPageState extends State<AddressPaymentPage> {
  late Future<List<Address>> futureAddresses;
  Map<int, bool> defaultAddresses = {};
  List<CartDetail> item = [];

  @override
  void initState() {
    super.initState();
    futureAddresses = AddressApi().fetchListAddress();
    item = widget.selectedItems;
  }

  void showSuccessToast(String message) {
    toastification.show(
      context: context,
      type: ToastificationType.success,
      style: ToastificationStyle.fillColored,
      title: const Text('Thành công!'),
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
        'Thất bại!',
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

  void _deleteAddress(int addressId) async {
    try {
      final result = await AddressApi().deleteAddress(addressId);
      if (result['errcode'] == 0) {
        setState(() {
          futureAddresses = AddressApi().fetchListAddress();
        });
        showSuccessToast('Xóa địa chỉ thành công');
      } else {
        showFailToast('Xóa địa chỉ thất bại: ${result['message']}');
      }
    } catch (e) {
      showFailToast('Lỗi: $e');
    }
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
          "Danh sách địa chỉ",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 20),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            height: 1.0,
            color: Colors.grey,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: FutureBuilder<List<Address>>(
          future: futureAddresses,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Lỗi: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/location.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                    const Text('Không có địa chỉ nào'),
                    TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddAddressPage(),
                          ),
                        ).then((value) {
                          if (value == true) {
                            setState(() {
                              futureAddresses = AddressApi().fetchListAddress();
                            });
                          }
                        });
                      },
                      icon: const Icon(
                        Icons.add_circle_outline,
                        color: Colors.blue,
                      ),
                      label: const Text(
                        "Thêm địa chỉ mới",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return ListView.separated(
                itemCount: snapshot.data!.length + 1,
                separatorBuilder: (context, index) => const Divider(
                  color: Colors.grey,
                ),
                itemBuilder: (context, index) {
                  if (index == snapshot.data!.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: TextButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddAddressPage(),
                            ),
                          ).then((value) {
                            if (value == true) {
                              setState(() {
                                futureAddresses =
                                    AddressApi().fetchListAddress();
                              });
                            }
                          });
                        },
                        icon: const Icon(
                          Icons.add_circle_outline,
                          color: Colors.blue,
                        ),
                        label: const Text(
                          "Thêm địa chỉ mới",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    );
                  } else {
                    final address = snapshot.data![index];
                    return ListTile(
                      title: Text(address.name ?? 'Không có thông tin'),
                      subtitle: Text(
                          '${address.phoneNumber}\n${address.detailAdr}, ${address.ward}, ${address.district}, ${address.city}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UpdateAddressPage(
                                    address: address,
                                  ),
                                ),
                              ).then((value) {
                                if (value == true) {
                                  setState(() {
                                    futureAddresses =
                                        AddressApi().fetchListAddress();
                                  });
                                }
                              });
                            },
                          ),
                          TextButton(
                            onPressed: () {
                              _deleteAddress(address.id!);
                            },
                            child: const Text('Xóa bỏ',
                                style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ShippingPage(
                              addressId: address.id!,
                              lstPrd: item,
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              );
            }
          },
        ),
      ),
    );
  }
}
