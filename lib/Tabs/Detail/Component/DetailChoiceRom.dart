import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storesalephone/Provider/DetailProvider.dart';

class ChoiceRom extends StatefulWidget {
  const ChoiceRom({super.key});

  @override
  State<StatefulWidget> createState() => ChoiceRomState();
}

class ChoiceRomState extends State<ChoiceRom> {
  Widget customRadioRom(String text, int index) {
    return Consumer<DetailProvider>(
      builder: (BuildContext context, DetailProvider value, Widget? child) {
        return OutlinedButton(
          onPressed: () {
            setState(() {
              value.setSelectedRom(index);
            });
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(10),
            side: BorderSide(
                width: 2,
                color: value.selectedRom == index
                    ? Colors.transparent
                    : const Color.fromARGB(157, 209, 213, 213)),
            backgroundColor: MaterialStateColor.resolveWith((states) =>
                value.selectedRom == index
                    ? Colors.indigoAccent
                    : Colors.white),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
          ),
          child: Text(
            "${text} GB",
            style: TextStyle(
              color: MaterialStateColor.resolveWith((states) =>
                  value.selectedRom == index ? Colors.white : Colors.black38),
              fontSize: 10,
            ),
          ),
        );
      },
    );
  }

  int setUpLenghth(DetailProvider data) {
    int? x = data.product.rams?[data.selectedRam].memory?.length;
    return x ?? 0;
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
                  "Bộ nhớ",
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
                        value.product == null ? 0 : setUpLenghth(value),
                        (index) => customRadioRom(
                            value.product.rams![value.selectedRam]
                                .memory![index].name
                                .toString(),
                            index))))
          ],
        );
      },
    );
  }
}
