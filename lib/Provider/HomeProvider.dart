import 'package:flutter/cupertino.dart';
import 'package:storesalephone/Api/OrderApi.dart';

class HomeProvider extends ChangeNotifier {
  int indexPage = 0;

  setSelected(int index) {
    indexPage = index;
    notifyListeners();
  }

  reBuyOrder(int idOrder) async {
    await OrderApi().reBuyOrder(idOrder);
  }
}
