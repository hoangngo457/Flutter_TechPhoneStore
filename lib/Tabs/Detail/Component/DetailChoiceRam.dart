import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:storesalephone/Provider/DetailProvider.dart';

class ChoiceRam extends StatefulWidget {
  const ChoiceRam({super.key});
  @override
  State<StatefulWidget> createState() => ChoiceRamState();
}

class ChoiceRamState extends State<ChoiceRam> {
  Widget customRadioRam(String text, int index) {
    return Consumer<DetailProvider>(
      builder: (BuildContext context, DetailProvider value, Widget? child) {
        return OutlinedButton(
          onPressed: () {
            setState(() {
              value.setSelectedRam(index);
            });
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(10),
            side: BorderSide(
                width: 2,
                color: value.selectedRam == index
                    ? Colors.transparent
                    : const Color.fromARGB(157, 209, 213, 213)),
            backgroundColor: MaterialStateColor.resolveWith((states) =>
                value.selectedRam == index
                    ? Colors.indigoAccent
                    : Colors.white),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
          ),
          child: Text(
            "${text} GB",
            style: TextStyle(
              color: MaterialStateColor.resolveWith((states) =>
                  value.selectedRam == index ? Colors.white : Colors.black38),
              fontSize: 13,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DetailProvider>(
      builder: (BuildContext context, DetailProvider value, Widget? child) {
        return Column(
          children: [
            const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Ram",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                )),
            const SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Wrap(
                  direction: Axis.horizontal,
                  spacing: 5,
                  runSpacing: 10,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  alignment: WrapAlignment.center,
                  children: List.generate(
                      value.product == null ? 0 : value.product.rams!.length,
                      (index) => customRadioRam(
                          value.product.rams![index].name.toString(), index))),
            )
          ],
        );
      },
    );
  }
}
