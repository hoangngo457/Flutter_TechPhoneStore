import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storesalephone/Provider/DetailProvider.dart';
import 'package:storesalephone/Tabs/Detail/Component/ComponentTab/Tab/DetailDescriptionView.dart';
import 'package:storesalephone/Tabs/Detail/Component/ComponentTab/Tab/DetailParameterView.dart';
import 'package:storesalephone/Tabs/Detail/Component/ComponentTab/Tab/DetailRatingView.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({super.key});
  @override
  State<StatefulWidget> createState() => TabScreenState();
}

class TabScreenState extends State<TabScreen> {
  static List<Widget> optionWidget = [
    const ParameterView(),
    const DescriptionView(),
    const RatingView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<DetailProvider>(
      builder: (BuildContext context, DetailProvider value, Widget? child) {
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 229, 230, 247)),
              width: double.infinity,
              child: Row(
                children: [
                  Expanded(
                      child: OutlinedButton(
                          onPressed: () => value.setSelectedTab(0),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: MaterialStateColor.resolveWith(
                                (states) => value.selectedTab == 0
                                    ? Colors.indigoAccent
                                    : Colors.transparent),
                            side: const BorderSide(color: Colors.indigoAccent),
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(5),
                                    topLeft: Radius.circular(5))),
                          ),
                          child: Text(
                            "Thông số",
                            style: TextStyle(
                                fontSize: 13,
                                color: MaterialStateColor.resolveWith(
                                    (states) => value.selectedTab == 0
                                        ? Colors.white
                                        : Colors.indigoAccent)),
                          ))),
                  Expanded(
                      child: OutlinedButton(
                          onPressed: () => value.setSelectedTab(1),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: MaterialStateColor.resolveWith(
                                (states) => value.selectedTab == 1
                                    ? Colors.indigoAccent
                                    : Colors.transparent),
                            side: const BorderSide(color: Colors.indigoAccent),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0)),
                          ),
                          child: Text(
                            "Thông tin",
                            style: TextStyle(
                                fontSize: 13,
                                color: MaterialStateColor.resolveWith(
                                    (states) => value.selectedTab == 1
                                        ? Colors.white
                                        : Colors.indigoAccent)),
                          ))),
                  Expanded(
                      child: OutlinedButton(
                          onPressed: () => value.setSelectedTab(2),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: MaterialStateColor.resolveWith(
                                (states) => value.selectedTab == 2
                                    ? Colors.indigoAccent
                                    : Colors.transparent),
                            side: const BorderSide(color: Colors.indigoAccent),
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(5),
                                    topRight: Radius.circular(5))),
                          ),
                          child: Text(
                            "Đánh giá",
                            softWrap: false,
                            style: TextStyle(
                                fontSize: 13,
                                color: MaterialStateColor.resolveWith(
                                    (states) => value.selectedTab == 2
                                        ? Colors.white
                                        : Colors.indigoAccent)),
                          )))
                ],
              ),
            ),
            Container(
              decoration: const BoxDecoration(color: Colors.white),
              child: Column(
                children: [
                  const Divider(
                    color: Colors
                        .indigoAccent, // specify the color you want for the line
                    thickness: 2, // specify the thickness of the line
                    height: 30, // specify the height of the divider
                    indent: 120, // specify the left indentation of the divider
                    endIndent:
                        120, // specify the right indentation of the divider
                  ),
                  optionWidget.elementAt(value.selectedTab),
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
