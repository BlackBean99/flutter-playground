import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:toss_gift_card_interaction/gift_card_list_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const GiftCardListPage(),
    );
  }
}
