import 'package:get/get.dart';
import 'package:hang_dev_app/models/user.dart';

class MyPageController extends GetxController {
  // final UserService userService = UserService();
  // final PixelService
  final Rx<User> currentUserInfo = User().obs;
  final RxInt currentPixelCount = 0.obs;
  final RxInt accumulatePixelCount = 0.obs;

  late DateTime selectedWeekStartDate;
  late DateTime selectedWeekEndDate;

  static DateTime checkFirstDate = DateTime.parse('2024-06-01');

  @override
  Future<void> onInit() async {
    super.onInit();
    updateUserInfo();
  }

  updateUserInfo() async {
    User userInfo = await UserService.getCurrentUserInfo();
    currentUserInfo.value = userInfo;
  }
}
