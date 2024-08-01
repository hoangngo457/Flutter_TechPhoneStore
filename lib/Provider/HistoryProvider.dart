import 'package:flutter/cupertino.dart';
import 'package:storesalephone/Api/OrderApi.dart';
import 'package:storesalephone/Api/RatingApi.dart';
import 'package:storesalephone/Model/Order.dart';

class HistoryProvider extends ChangeNotifier {
  List<OrderModel> orderInit = [];
  List<OrderModel> orders = [];

  OrderModel detail = OrderModel();

  initData() async {
    orderInit = await OrderApi().fetchAllOrderByUser();
    notifyListeners();
  }

  postAddRating(int count, String content, int idOpt) async {
    await RatingApi().createNew(count, content, idOpt);
  }

  List<OrderModel> OrderWaiting() {
    orders = [];
    // get waiting order
    var x = orderInit.where((element) => element.state == "Chờ xác nhận");
    for (var element in x) {
      orders.add(element);
    }
    return orders;
  }

  List<OrderModel> OrderShipping() {
    orders = [];
    // get waiting order
    var x = orderInit.where((element) => element.state == "Đang giao");
    for (var element in x) {
      orders.add(element);
    }
    return orders;
  }

  List<OrderModel> OrderShipped() {
    orders = [];
    // get waiting order
    var x = orderInit.where((element) => element.state == "Đã giao");
    for (var element in x) {
      orders.add(element);
    }
    return orders;
  }

  List<OrderModel> OrderDestroyed() {
    orders = [];
    // get waiting order
    var x = orderInit.where((element) => element.state == "Đã hủy");
    for (var element in x) {
      orders.add(element);
    }
    return orders;
  }
}
