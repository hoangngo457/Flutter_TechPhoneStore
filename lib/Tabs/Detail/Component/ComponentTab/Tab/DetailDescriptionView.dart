import 'package:flutter/cupertino.dart';

class DescriptionView extends StatefulWidget {
  const DescriptionView({super.key});

  @override
  State<StatefulWidget> createState() => DescriptionState();
}

class DescriptionState extends State<DescriptionView> {
  @override
  Widget build(BuildContext context) {
    return const Text("Cập nhật sau !");
  }
}
