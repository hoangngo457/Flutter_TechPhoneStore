import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:storesalephone/Model/Order.dart';
import 'package:storesalephone/Provider/HistoryProvider.dart';
import 'package:storesalephone/Provider/HomeProvider.dart';
import 'package:storesalephone/Tabs/Cart/CartScreen.dart';
import 'package:storesalephone/Tabs/Payment/DetailOrder.dart';
import 'package:storesalephone/Tabs/Rating/AddRating.dart';

class OrderHistory extends StatefulWidget {
  const OrderHistory({super.key});

  @override
  State<OrderHistory> createState() => OrderHistoryScreen();
}

class OrderHistoryScreen extends State<OrderHistory> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(CupertinoIcons.back),
              onPressed: () {
                Navigator.pop(
                    context); // Đóng màn hình và quay lại màn hình trước đó
              },
            ),
            title: const Text('Lịch sử mua hàng'),
            bottom: TabBar(
              isScrollable: true, // Cho phép cuộn ngang
              tabAlignment: TabAlignment.start,
              onTap: (index) {
                String tabName = '';
                switch (index) {
                  case 0:
                    tabName = 'Chờ xử lí';
                    break;
                  case 1:
                    tabName = 'Đang giao hàng';
                    break;
                  case 2:
                    tabName = 'Đã giao';
                    break;
                  case 3:
                    tabName = 'Đã hủy';
                    break;
                  default:
                    tabName = 'Unknown';
                }
              },
              tabs: const [
                Tab(text: 'Chờ xử lí'),
                Tab(text: 'Đang giao hàng'),
                Tab(text: 'Đã giao'),
                Tab(text: 'Đã hủy'),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              OrderStatusTab1(),
              OrderStatusTab2(),
              OrderStatusTab3(),
              OrderStatusTab4(),
            ],
          ),
        ));
  }
}

String formatDate(String data) {
  String originalDateString = data;
  DateTime dateTime = DateTime.parse(originalDateString);
  String formattedDateTime = DateFormat('dd-MM-yyyy').format(dateTime);

  return formattedDateTime;
}

class OrderStatusTab1 extends StatelessWidget {
  const OrderStatusTab1({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HistoryProvider>(
      builder: (BuildContext context, HistoryProvider value, Widget? child) {
        return SingleChildScrollView(
            child: Column(
          children: List.generate(value.OrderWaiting().length,
              (index) => ItemOrder(data: value.OrderWaiting()[index])),
        ));
      },
    );
  }
}

class OrderStatusTab2 extends StatelessWidget {
  const OrderStatusTab2({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<HistoryProvider>(
      builder: (BuildContext context, HistoryProvider value, Widget? child) {
        return SingleChildScrollView(
            child: Column(
          children: List.generate(value.OrderShipping().length,
              (index) => ItemOrder(data: value.OrderShipping()[index])),
        ));
      },
    );
  }
}

class OrderStatusTab3 extends StatelessWidget {
  const OrderStatusTab3({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HistoryProvider>(
      builder: (BuildContext context, HistoryProvider value, Widget? child) {
        return SingleChildScrollView(
            child: Column(
          children: List.generate(value.OrderShipped().length,
              (index) => ItemOrder(data: value.OrderShipped()[index])),
        ));
      },
    );
  }
}

class OrderStatusTab4 extends StatelessWidget {
  const OrderStatusTab4({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HistoryProvider>(
      builder: (BuildContext context, HistoryProvider value, Widget? child) {
        return SingleChildScrollView(
            child: Column(
          children: List.generate(value.OrderDestroyed().length,
              (index) => ItemOrder(data: value.OrderDestroyed()[index])),
        ));
      },
    );
  }
}

final vietnameseCurrencyFormat =
    NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

class ItemOrder extends StatelessWidget {
  const ItemOrder({super.key, required this.data});
  final OrderModel data;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => DetailOrders(data: data)));
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Colors.grey, width: 0.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black
                    .withOpacity(0.3), // Màu và độ trong suốt của bóng đổ
                spreadRadius: 2, // Độ lan rộng của bóng đổ
                blurRadius: 5, // Độ mờ của bóng đổ
                offset: const Offset(0, 3), // Độ dịch chuyển của bóng đổ
              ),
            ],
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "#0000${data.id}",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      data.state.toString(),
                      style: const TextStyle(color: Colors.indigoAccent),
                    ),
                  ],
                ),
              ),
              const Divider(
                color: Colors.black12,
                endIndent: 10,
                indent: 10,
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(formatDate(data.date.toString())),
                    Row(
                      children: [
                        const Text(
                          "Thành tiền:",
                          style: TextStyle(
                              color: Color.fromARGB(255, 78, 78, 78),
                              fontSize: 16),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          vietnameseCurrencyFormat.format(data.total),
                          style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        )
                      ],
                    )
                  ],
                ),
              ),
              data.state == "Đã hủy" || data.state == "Đã giao"
                  ? Padding(
                      padding: const EdgeInsets.only(right: 10, bottom: 10),
                      child: Consumer<HomeProvider>(
                        builder: (BuildContext context, HomeProvider value,
                            Widget? child) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              OutlinedButton(
                                  onPressed: () async {
                                    value.setSelected(2);
                                    await value.reBuyOrder(data.id!.toInt());
                                    Navigator.pop(context);
                                  },
                                  style: OutlinedButton.styleFrom(
                                      side: const BorderSide(
                                          color: Colors.orange),
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                          side:
                                              BorderSide(color: Colors.white)),
                                      backgroundColor: Colors.orange),
                                  child: const Text(
                                    "Mua lại",
                                    style: TextStyle(color: Colors.white),
                                  ))
                            ],
                          );
                        },
                      ))
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
