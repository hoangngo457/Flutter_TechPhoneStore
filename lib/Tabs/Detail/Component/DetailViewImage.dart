import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storesalephone/Provider/DetailProvider.dart';

class ViewImage extends StatefulWidget {
  const ViewImage({super.key});
  @override
  State<StatefulWidget> createState() => ViewImageState();
}

class ViewImageState extends State<ViewImage> {
  final String _emptyImg =
      "https://static.vecteezy.com/system/resources/previews/004/141/669/non_2x/no-photo-or-blank-image-icon-loading-images-or-missing-image-mark-image-not-available-or-image-coming-soon-sign-simple-nature-silhouette-in-frame-isolated-illustration-vector.jpg";

  @override
  Widget build(BuildContext context) {
    return Consumer<DetailProvider>(
      builder: (BuildContext context, DetailProvider value, Widget? child) {
        return Column(
          children: [
            Container(
                height: MediaQuery.of(context).size.height / 3,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(),
                child: Column(
                  children: [
                    Expanded(
                      child: Image.network(
                          value.product.images == null
                              ? _emptyImg
                              : value.product.images![value.selectedIndexImage]
                                  .name
                                  .toString(),
                          fit: BoxFit.contain,
                          width: double.infinity),
                    )
                  ],
                )),
            Container(
              height: 80,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: value.product.images?.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (_, index) {
                  return customImg(
                      value.product.images == null
                          ? _emptyImg
                          : value.product.images![index].name.toString(),
                      index);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

Widget customImg(String img, int index) {
  return Consumer<DetailProvider>(
      builder: (BuildContext context, DetailProvider value, Widget? child) =>
          InkWell(
            onTap: () {
              value.setSelectedImage(index);
            },
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                width: 60,
                height: 60,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  color: Colors.transparent,
                  border: value.selectedIndexImage == index
                      ? const Border(
                          bottom: BorderSide(width: 2, color: Colors.white),
                          top: BorderSide(width: 2, color: Colors.white),
                          left: BorderSide(width: 2, color: Colors.white),
                          right: BorderSide(width: 2, color: Colors.white))
                      : Border.all(
                          width: 2,
                          color: const Color.fromARGB(157, 209, 213, 213)),
                ),
                child: Center(
                  child: Image.network(
                    img,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ));
}
