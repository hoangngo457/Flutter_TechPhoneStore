import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeCarousel extends StatefulWidget {
  const HomeCarousel({super.key});

  @override
  State<StatefulWidget> createState() => HomeCarouselState();
}

class HomeCarouselState extends State<HomeCarousel> {
  int currentCarousel = 0;
  final myItems = [
    const Image(
        image: AssetImage("assets/carousel/carousel1.png"), fit: BoxFit.cover),
    const Image(
        image: AssetImage("assets/carousel/carousel2.jpg"), fit: BoxFit.cover),
    const Image(
        image: AssetImage("assets/carousel/carousel3.png"), fit: BoxFit.cover),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          items: myItems.map((i) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: i,
                  ),
                );
              },
            );
          }).toList(),
          options: CarouselOptions(
              autoPlay: true,
              aspectRatio: 2.0,
              initialPage: 1,
              // enlargeCenterPage: true,
              viewportFraction: 1,
              height: 170,
              onPageChanged: (index, reason) {
                setState(() {
                  currentCarousel = index;
                });
              }),
        ),
        const SizedBox(
          height: 15,
        ),
        AnimatedSmoothIndicator(
          activeIndex: currentCarousel,
          count: myItems.length,
          effect: const WormEffect(
            dotWidth: 10,
            dotHeight: 10,
            spacing: 5,
          ),
        ),
      ],
    );
  }
}
