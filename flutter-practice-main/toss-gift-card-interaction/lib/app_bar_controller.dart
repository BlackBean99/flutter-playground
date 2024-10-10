import 'package:get/get.dart';

class AppBarController extends GetxController {
  var title = 'Default Title'.obs; // Observable title

  void updateTitle(String newTitle) {
    title.value = newTitle;
  }
}
