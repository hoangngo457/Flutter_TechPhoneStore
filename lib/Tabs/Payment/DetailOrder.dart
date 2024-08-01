import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:storesalephone/Model/Order.dart';
import 'package:storesalephone/Provider/HistoryProvider.dart';

import '../Rating/AddRating.dart';

String formatDate(String data) {
  String originalDateString = data;
  DateTime dateTime = DateTime.parse(originalDateString);
  String formattedDateTime = DateFormat('dd-MM-yyyy').format(dateTime);

  return formattedDateTime;
}

class DetailOrders extends StatelessWidget {
  const DetailOrders({super.key, required this.data});
  final OrderModel data;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          leading: InkWell(
            child: const Icon(Icons.arrow_back_ios_new),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          title: const Text("Thông tin đơn hàng"),
        ),
        body: Consumer<HistoryProvider>(builder:
            (BuildContext context, HistoryProvider value, Widget? child) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: const BoxDecoration(color: Colors.white),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(top: 15, bottom: 15),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Chi tiết đơn hàng",
                                style: TextStyle(fontSize: 16),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                "#0000${data.id}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.indigoAccent,
                                    fontSize: 16),
                              )
                            ],
                          )),
                      const Divider(
                        color: Colors.black12,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.info,
                                color: Colors.indigoAccent,
                              ),
                              SizedBox(
                                width: 5,
                                child: Text(""),
                              ),
                              Text("Thông tin khách hàng")
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            data.address!.name.toString(),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            data.address!.phoneNumber.toString(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "${data.address!.detailAdr},${data.address!.ward}, ${data.address!.district}, ${data.address!.city}",
                            style: const TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                      const Divider(
                        color: Colors.black12,
                      ),
                      const Text(
                        "Các sản phẩm",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(100, 222, 234, 252)),
                  child: Column(
                      children:
                          List<Widget>.generate(data.list!.length, (int index) {
                    return ItemDetailOrder(
                      data: data.list![index],
                      type: data.state.toString(),
                    );
                  })),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: const BoxDecoration(color: Colors.white),
                  padding: const EdgeInsets.all(0),
                  child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.payment, color: Colors.orange),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Chi tiết thanh toán",
                                style: TextStyle(fontSize: 15),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Chi phí vận chuyển",
                                style: TextStyle(fontSize: 15),
                              ),
                              Text("Miễn phí vận chuyển")
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Ngày đặt hàng",
                                  style: TextStyle(fontSize: 15)),
                              Text(formatDate(data.date.toString()))
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Tình trạng",
                                  style: TextStyle(fontSize: 15)),
                              Text(data.state.toString())
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Tổng tiền",
                                  style: TextStyle(fontSize: 16)),
                              Text(
                                vietnameseCurrencyFormat.format(data.total),
                                style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          )
                        ],
                      )),
                )
              ],
            ),
          );
        }));
  }
}

final vietnameseCurrencyFormat =
    NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

int getSum(int? x, int? y) {
  return x! * y!;
}

class ItemDetailOrder extends StatelessWidget {
  final DetailOrder data;
  final String type;
  const ItemDetailOrder({super.key, required this.data, required this.type});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Image.network(
            data.img.toString(),
            height: 60,
            width: 60,
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.nameProduct.toString(),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                      '${data.ram}GB, ${int.parse(data.rom.toString()) < 1000 ? "${data.rom}GB" : "${int.parse(data.rom.toString()) ~/ 1000}TB"}, ${data.color}'),
                  Text("Số lượng: ${data.quantity}")
                ],
              ),
              Column(
                children: [
                  Text(
                    vietnameseCurrencyFormat
                        .format(getSum(data.price, data.quantity)),
                    style: const TextStyle(
                        color: Colors.indigo, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  type == "Đã giao"
                      ? Padding(
                          padding: const EdgeInsets.only(right: 10, bottom: 10),
                          child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AddRating(
                                              data: data,
                                            )));
                              },
                              child: Container(
                                padding: const EdgeInsets.only(
                                    top: 5, bottom: 5, left: 10, right: 10),
                                decoration: const BoxDecoration(
                                    color: Colors.orange,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                                child: const Text(
                                  "Đánh giá",
                                  style: TextStyle(color: Colors.white),
                                ),
                              )),
                        )
                      : const Text(""),
                ],
              )
            ],
          ))
        ],
      ),
    );
  }
}
