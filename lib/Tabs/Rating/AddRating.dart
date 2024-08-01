import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:storesalephone/Model/Order.dart';
import 'package:storesalephone/Provider/HistoryProvider.dart';

final vietnameseCurrencyFormat =
    NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

int getSum(int? x, int? y) {
  return x! * y!;
}

final TextEditingController _controller = TextEditingController();
int ratingData = 5;

class AddRating extends StatelessWidget {
  const AddRating({super.key, required this.data});
  final DetailOrder data;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios_new_rounded),
          ),
          title: Text("Đánh giá"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
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
                              "${data.color}, ${data.ram}, ${data.rom}",
                            ),
                            Text("Số lượng: ${data.quantity}")
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              vietnameseCurrencyFormat
                                  .format(getSum(data.price, data.quantity)),
                              style: const TextStyle(
                                  color: Colors.indigo,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        )
                      ],
                    ))
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Chọn đánh giá sản phẩm ?",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(
                height: 10,
              ),
              RatingBar.builder(
                initialRating: 5,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  ratingData = rating.toInt();
                },
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Viết đánh giá của bạn",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                        controller: _controller,
                        maxLines: 6, // Cho phép nhập nhiều dòng
                        keyboardType: TextInputType
                            .multiline, // Kiểu nhập văn bản nhiều dòng
                        decoration: InputDecoration(
                          hintText: 'Nhập nội dung...',
                          border: OutlineInputBorder(),
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: double.maxFinite,
                      child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                  color: Colors.indigoAccent, width: 2),
                              backgroundColor: Colors.indigoAccent,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)))),
                          onPressed: () {
                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) => Dialog(
                                  child: Container(
                                padding: EdgeInsets.all(20),
                                width: 500,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(200),
                                      child: Image.asset(
                                        "assets/logo2.png",
                                        width: 200,
                                        height: 200,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Text(
                                      "Cảm ơn bạn",
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    RatingBarIndicator(
                                      rating: ratingData.toDouble(),
                                      itemBuilder: (context, index) =>
                                          const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      itemCount: 5,
                                      itemSize: 30.0,
                                      direction: Axis.horizontal,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Text(
                                      "Chúng tôi rất cảm kích vì sự nhiệt tình của bạn, chúc bạn một ngày vui vẻ",
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                                side: const BorderSide(
                                                    color: Colors.orange,
                                                    width: 2),
                                                backgroundColor: Colors.orange,
                                                shape:
                                                    const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    5)))),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text(
                                              "Đánh giá lại",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            )),
                                        Consumer<HistoryProvider>(
                                          builder: (BuildContext context,
                                              HistoryProvider value,
                                              Widget? child) {
                                            return OutlinedButton(
                                                style: OutlinedButton.styleFrom(
                                                    side: const BorderSide(
                                                        color:
                                                            Colors.indigoAccent,
                                                        width: 2),
                                                    backgroundColor:
                                                        Colors.indigoAccent,
                                                    shape: const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    5)))),
                                                onPressed: () async {
                                                  await value.postAddRating(
                                                      ratingData,
                                                      _controller.text,
                                                      data.idOpt!.toInt());
                                                  Navigator.pop(context);
                                                  Navigator.pop(context);
                                                },
                                                child: const Text(
                                                  "Xong",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ));
                                          },
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              )),
                            );
                          },
                          child: const Text(
                            "Đánh giá",
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Center(
                      child: Text(
                        "Đánh giá của bạn sẻ được kiễm tra, vui lòng không spam",
                        style: TextStyle(color: Colors.black38, fontSize: 13),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
