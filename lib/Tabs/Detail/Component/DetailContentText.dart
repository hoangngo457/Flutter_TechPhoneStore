import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:storesalephone/CommonWidget/CardProduct.dart';
import 'package:storesalephone/Provider/DetailProvider.dart';
import 'package:storesalephone/Tabs/Detail/Component/ComponentTab/Tab/DetailRatingView.dart';

class ContentText extends StatefulWidget {
  const ContentText({super.key});
  @override
  State<StatefulWidget> createState() => ContentTextState();
}

class ContentTextState extends State<ContentText> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DetailProvider>(
      builder: (BuildContext context, DetailProvider value, Widget? child) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    value.product.product != null
                        ? value.product.product!.name.toString()
                        : "null",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 25)),

                // Row(
                //   children: [
                //     value.product.feedbacks == null
                //         ? const Text("")
                //         : value.product.feedbacks!.isEmpty
                //             ? const Text("")
                //             : const Icon(
                //                 Icons.star,
                //                 size: 18,
                //                 color: Colors.orangeAccent,
                //               ),
                //     Text(
                //       value.product.feedbacks == null
                //           ? ""
                //           : value.product.feedbacks!.isEmpty
                //               ? "Chưa có đánh giá"
                //               : value.product.getSumRating(),
                //       style: const TextStyle(fontSize: 12),
                //     ),
                //     const SizedBox(
                //       width: 10,
                //     ),
                //     Text(
                //       value.product.feedbacks == null
                //           ? ""
                //           : value.product.feedbacks!.isEmpty
                //               ? ""
                //               : "(${value.product.feedbacks!.length})",
                //       style: const TextStyle(fontSize: 12),
                //     )
                //   ],
                // )
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                RatingBarIndicator(
                  rating: value.product.getSumRatingNumber(),
                  itemBuilder: (context, index) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  itemCount: 5,
                  itemSize: 20.0,
                  direction: Axis.horizontal,
                ),
                Text("(${value.product.feedbacks!.length})"),
                const SizedBox(
                  width: 155,
                ),
                InkWell(
                  child: const Text("Xem đánh giá"),
                  onTap: () {
                    showModalBottomSheet(
                      shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(30.0)),
                      ),
                      context: context,
                      builder: (context) {
                        return const SingleChildScrollView(
                          child: RatingView(),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
            Padding(
                padding: const EdgeInsets.only(
                    right: 0, top: 10, bottom: 20, left: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          vietnameseCurrencyFormat
                              .format(value.product.price ?? 0),
                          style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        // Text(
                        //   "vietnameseCurrencyFormat.format(product.price)",
                        //   style: const TextStyle(
                        //       color: Colors.grey,
                        //       decoration:
                        //           TextDecoration.lineThrough,
                        //       fontWeight: FontWeight.bold,
                        //       fontSize: 13),
                        // ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 255, 193, 7),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        "Giảm 10%",
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    )
                  ],
                )),
          ],
        );
      },
    );
  }
}
