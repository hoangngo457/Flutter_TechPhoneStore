import 'package:flutter/cupertino.dart';
import 'package:storesalephone/Model/OptionProduct.dart';
import 'package:storesalephone/Tabs/Detail/DetailSetUp.dart';

class DetailProvider extends ChangeNotifier {
  OptionProduct product = OptionProduct();

  int selectedIndexImage = 0;
  int selectedRam = 0;
  int selectedRom = 0;
  int selectedTab = 0;
  int selectedIndexColor = 0;
  int selectedFavorite = 0;
  int currentPageFeedback = 0;

  hello(int index) async {
    DetailSetUp setUp = DetailSetUp();
    int? idColor = product.colors?[index].id;
    OptionProduct optionProduct = await setUp.getDataProductByIdColor(idColor!);
    product = optionProduct;
    resetSelected();
    selectedIndexColor = index;
    notifyListeners();
  }

  init() async {
    DetailSetUp setUp = DetailSetUp();
    OptionProduct optionProduct = await setUp.getDataProductById();
    product = optionProduct;
    resetSelected();
    if (product.fav == true) {
      selectedFavorite = 1;
    }
    for (int x = 0; x < product.colors!.length; x++) {
      if (product.colors?[x].id == product.color?.id) {
        selectedIndexColor = x;
      }
    }
    notifyListeners();
  }

  setSelectedImage(index) {
    selectedIndexImage = index;
    notifyListeners();
  }

  setSelectedRam(index) {
    selectedRam = index;
    selectedRom = 0;
    product.codeOption = product.rams![index].memory?[0].idOpt;
    notifyListeners();
  }

  setPageFeedBack(index) {
    currentPageFeedback = index;
    notifyListeners();
  }

  setSelectedRom(index) {
    selectedRom = index;
    product.codeOption = product.rams![selectedRam].memory?[index].idOpt;
    print(product.codeOption);
    notifyListeners();
  }

  setSelectedTab(index) {
    selectedTab = index;
    notifyListeners();
  }

  setSelectedFavorite() {
    DetailSetUp setUp = DetailSetUp();
    int? idColor = product.color?.id;
    int? idProduct = product.product?.id;
    if (selectedFavorite == 0) {
      setUp.addFavorite(idColor, idProduct);
      selectedFavorite = 1;
    } else {
      setUp.deleteFavorite(idColor, idProduct);
      selectedFavorite = 0;
    }
    notifyListeners();
  }

  resetSelected() {
    selectedFavorite = 0;
    selectedIndexImage = 0;
    selectedIndexColor = 0;
    currentPageFeedback = 0;
    selectedRom = 0;
    selectedRam = 0;
    selectedTab = 0;
    notifyListeners();
  }

  setColors(index) async {
    DetailSetUp setUp = DetailSetUp();
    int? idColor = product.colors?[index].id;
    OptionProduct optionProduct = await setUp.getDataProductByIdColor(idColor!);
    product = optionProduct;
    resetSelected();
    selectedIndexColor = index;
    notifyListeners();
  }
}
