import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hang_dev_app/controllers/main-controller.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    Get.put(MainController());
    Get.put(MyPageController());
    // Get.put(RankingController());
    // Get.put(BottomSheetController());
    // Get.put(MapController());
    final NavigationController navigationController =
        Get.put(NavigationController());

    return Scaffold(
      appBar: navigationController.selectedIndex.value == 0 ||
              navigationController.selectedIndex.value == 2
          ? null
          : PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: Obx(() => navigationController.getCurrentAppBar()),
            ),
      body: Obx(
        () => navigationController.getCurrentPage(),
      ),
      backgroundColor: AppColors.background,
      bottomNavigationBar: CustomBottomNavigationBar((index) {
        setState(() {
          navigationController.changeIndex(index);
        });
      }),
    );
  }
}
