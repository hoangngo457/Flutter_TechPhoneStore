import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storesalephone/Provider/DetailProvider.dart';

class ChoiceFavorite extends StatefulWidget {
  const ChoiceFavorite({super.key});

  @override
  State<StatefulWidget> createState() => ChoiceFavoriteState();
}

class ChoiceFavoriteState extends State<ChoiceFavorite> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DetailProvider>(
      builder: (BuildContext context, DetailProvider value, Widget? child) {
        return Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: InkWell(
              onTap: () {
                value.setSelectedFavorite();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                      value.selectedFavorite == 1
                          ? CupertinoIcons.heart_fill
                          : CupertinoIcons.heart,
                      size: 25,
                      color: value.selectedFavorite == 1
                          ? Colors.red
                          : Colors.black),
                ],
              )),
        );
      },
    );
  }
}
