import 'package:storesalephone/Model/Product.dart';
import 'package:storesalephone/Model/Color.dart';
import 'package:storesalephone/Model/Ram.dart';
import 'package:storesalephone/Model/Image.dart';
import 'package:storesalephone/Model/FeedBack.dart';

class OptionProduct {
  int? codeOption;
  int? sold;
  int? price;
  Product? product;
  Color? color;
  bool? fav;
  List<Ram>? rams;
  List<Images>? images;
  List<FeedBack>? feedbacks;
  List<Color>? colors;
  OptionProduct() {}

  OptionProduct.fromJson(Map<String, dynamic> json) {
    codeOption = json["CodeOption"];
    sold = json["sold"];
    price = json["price"];
    product = Product.fromJson(json["product"]);
    feedbacks =
        (json["feedback"] as List).map((e) => FeedBack.fromJson(e)).toList();
    color = Color.fromJson(json["color"]);
    colors = (json["colors"] as List).map((e) => Color.fromJson(e)).toList();
    rams = (json["ram"] as List).map((e) => Ram.fromJson(e)).toList();
    images = (json["img"] as List).map((e) => Images.fromJson(e)).toList();
    fav = json["fav"];
  }

  getSumRating() {
    var data = 0;
    feedbacks?.forEach((element) {
      data += element.count!;
    });
    if (feedbacks!.isEmpty) {
      return 0.toString();
    }
    double roundedNumber =
        double.parse(((data / feedbacks!.length)).toStringAsFixed(1));
    return roundedNumber.toString();
  }

  getSumRatingNumber() {
    var data = 0;
    feedbacks?.forEach((element) {
      data += element.count!;
    });
    if (feedbacks!.isEmpty) {
      return 0.0;
    }
    double roundedNumber =
        double.parse(((data / feedbacks!.length)).toStringAsFixed(2));
    return roundedNumber;
  }

  getCountPag() {
    int itemPage = 3;
    if (feedbacks!.isEmpty || feedbacks == null) {
      return 0;
    }
    double number = feedbacks!.length / itemPage;
    int roundedNumber = number.ceil();
    return roundedNumber;
  }

  List<FeedBack> getFeedbackPage(int indexPage) {
    List<FeedBack> list = [];

    int indexStart = indexPage * 3;
    int indexEnd = indexStart + 3;

    if (indexStart == 0) {
      indexEnd = indexEnd - 1;
    }

    for (int x = 0; x < feedbacks!.length; x++) {
      if (indexStart == 0) {
        if (x <= indexEnd && x >= indexStart) {
          list.add(feedbacks![x]);
        }
      } else {
        if (x < indexEnd && x >= indexStart) {
          list.add(feedbacks![x]);
        }
      }
    }
    return list;
  }
}
