import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:storesalephone/Provider/CartProvider.dart';
import 'package:storesalephone/Provider/DetailProvider.dart';
import 'package:storesalephone/Provider/HistoryProvider.dart';
import 'package:storesalephone/Provider/HomeProvider.dart';
import 'package:storesalephone/Tabs/SplashApp/SplashScreen.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => DetailProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => HomeProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => HistoryProvider(),
      ),
      ChangeNotifierProvider(create: (context) => CartProvider()..initData()),
    ],
    child: MaterialApp(
      title: 'My app',
      home: SplashScreenApp(),
      debugShowCheckedModeBanner: false,
    ),
  ));
}
