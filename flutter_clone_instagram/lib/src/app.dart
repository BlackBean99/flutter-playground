import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
        child: Scaffold(
      appBar: AppBar(),
      body: Container(),
      bottomNavigationBar: BottomNavigationBar(items: [
        BottomNavigationBarItem(
            icon: Image.asset('assets/images/add_friend_icon.jpg'))
      ]),
    ));
  }
}
