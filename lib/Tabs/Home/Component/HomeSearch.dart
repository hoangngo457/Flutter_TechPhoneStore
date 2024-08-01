import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:storesalephone/Tabs/Search/SearchScreen.dart';

class HomeSearch extends StatelessWidget {
  const HomeSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: CupertinoSearchTextField(
        placeholder: "Tìm kiếm tại đây",
        style: const TextStyle(fontSize: 14),
        borderRadius: BorderRadius.circular(10),
        backgroundColor: Colors.white,
        padding: const EdgeInsets.all(15),
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const SearchScreen()));
        },
      ),
    );
  }
}
