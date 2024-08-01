import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:provider/provider.dart';
import 'package:storesalephone/Model/FeedBack.dart';
import 'package:storesalephone/Provider/DetailProvider.dart';

class RatingView extends StatefulWidget {
  const RatingView({super.key});

  @override
  State<StatefulWidget> createState() => RatingViewState();
}

class RatingViewState extends State<RatingView> {
  final NumberPaginatorController _controller = NumberPaginatorController();
  static List<Widget> PageData = [];

  @override
  Widget build(BuildContext context) {
    return Consumer<DetailProvider>(
      builder: (BuildContext context, DetailProvider value, Widget? child) {
        return Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              value.product.feedbacks!.isNotEmpty
                  ? NumberPaginator(
                      config: const NumberPaginatorUIConfig(
                          buttonSelectedBackgroundColor: Colors.indigoAccent),
                      controller: _controller,
                      initialPage: value.currentPageFeedback,
                      numberPages: value.product.getCountPag(),
                      onPageChange: (int index) {
                        value.setPageFeedBack(index);
                      },
                    )
                  : const Text(""),
              const SizedBox(
                height: 10,
              ),
              const RatingViewAssess(),
            ],
          ),
        );
      },
    );
  }
}

class RatingViewAssess extends StatelessWidget {
  const RatingViewAssess({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DetailProvider>(
        builder: (BuildContext context, DetailProvider value, Widget? child) {
      return SingleChildScrollView(
        child: ListView.builder(
            // physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount:
                value.product.getFeedbackPage(value.currentPageFeedback).length,
            itemBuilder: (BuildContext context, int index) {
              return ItemView(value.product
                  .getFeedbackPage(value.currentPageFeedback)[index]);
            }),
      );
    });
  }
}

Widget ItemView(FeedBack feedBack) {
  return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Image(
                    image: AssetImage("assets/user.png"),
                    width: 30,
                    height: 30,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        feedBack.name.toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                color: Color.fromARGB(255, 229, 230, 247)),
                            child: Text(
                              feedBack.color.toString(),
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                color: Color.fromARGB(255, 229, 230, 247)),
                            child: Text(feedBack.ram.toString(),
                                style: const TextStyle(fontSize: 12)),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                color: Color.fromARGB(255, 229, 230, 247)),
                            child: Text(feedBack.rom.toString(),
                                style: const TextStyle(fontSize: 12)),
                          ),
                        ],
                      ),
                      RatingBarIndicator(
                        rating: feedBack.count!.toDouble(),
                        itemBuilder: (context, index) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        itemCount: 5,
                        itemSize: 18.0,
                        direction: Axis.horizontal,
                      ),
                    ],
                  )
                ],
              ),
              Text(
                feedBack.getDateRating(),
                style: const TextStyle(fontSize: 13),
              )
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(feedBack.content.toString()),
              const SizedBox(
                height: 5,
              ),
              // img == null
              //     ? const Text("")
              //     : Image.network(
              //         img.toString(),
              //         width: 200,
              //         fit: BoxFit.contain,
              //       )
            ],
          )
        ],
      ));
}
