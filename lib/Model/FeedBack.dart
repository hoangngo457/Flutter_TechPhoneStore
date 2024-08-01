import 'package:intl/intl.dart';

class FeedBack {
  int? count;
  String? content;
  String? date;
  String? name;
  String? ram;
  String? rom;
  String? color;

  FeedBack.fromJson(Map<String, dynamic> json) {
    count = json["rating"];
    content = json["content"];
    name = json["nameAssess"];
    ram = json["ram"].toString();
    rom = json["rom"].toString();
    color = json["color"];
    date = json["dateCre"];
  }

  getDateRating() {
    String dateTimeString = date.toString();
    DateFormat utcFormatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
    DateTime utcDateTime = utcFormatter.parse(dateTimeString);
    DateTime vietnamDateTime = utcDateTime.toLocal();
    DateFormat vietnamFormatter = DateFormat("yyyy-MM-dd HH:mm:ss");
    String vietnamDateTimeString = vietnamFormatter.format(vietnamDateTime);
    return vietnamDateTimeString;
  }
}
