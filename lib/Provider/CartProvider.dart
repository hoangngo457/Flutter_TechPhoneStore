import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storesalephone/Api/CartApi.dart';
import 'package:storesalephone/Model/Cart.dart';

class CartProvider extends ChangeNotifier {
  List<CartDetail> cart = [];

  List<int> cardOrder = [];

  Future<void> _fetchCartItems() async {
    try {
      cart = await CartApi().fetchAllCart();
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  allOrder(bool add) {
    cardOrder = [];
    if (add == true) {
      cart.forEach((element) {
        cardOrder.add(element.idCart!.toInt());
      });
    }

    cardOrder.forEach((element) {
      print(element);
    });
  }

  initData() async {
    _fetchCartItems();
  }

  void Add(int quantity, int? idOpt) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId =
        prefs.getInt('userId') ?? 1; // Lấy id người dùng từ SharedPreferences
    int idUser = userId;
    CartApi api = CartApi();
    DataAdd x = DataAdd();
    x.quantity = quantity;
    x.idOpt = idOpt;
    x.idUser = idUser;
    api.addCart(x);
    await initData();
  }

  Future<void> add() async {
    notifyListeners();
    await initData();
  }

  Future<void> remove() async {
    notifyListeners();
    await initData();
  }

  int get cartItemCount => cart.length;
}

class DataAdd {
  int? quantity;
  int? idUser;
  int? idOpt;
  DataAdd();

  Map<String, dynamic> toJson() {
    return {
      'quantity': quantity,
      'idUser': idUser,
      'idOpt': idOpt,
    };
  }

  // String toJson() => json.encode(toMap());
}
