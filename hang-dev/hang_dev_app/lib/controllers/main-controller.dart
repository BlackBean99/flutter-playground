import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hang_dev_app/constants/app-colors.dart';
import 'package:hang_dev_app/constants/text-styles.dart';
import 'package:hang_dev_app/utils/secure_storage.dart';
import 'package:hang_dev_app/widgets/common/pop_up_event.dart';
import 'package:optimize_battery/optimize_battery.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:hang_dev_app/services/my_place_service.dart';

class MainController extends GetxController {
  // final FcmService fcmService = FcmService();
  // final AnnouncementService announcementService = AnnouncementService();
  final MyPlaceService myPlaceService = MyPlaceService();
  final storage = GetStorage();

  final RxBool internetCheck = true.obs;
  final RxBool isAlertIsShow = false.obs;
  final String popupKey = "hidePopupUntil";

  @override
  void onInit() async {
    super.onInit();
    // fcmService.registerFcmToken();
    myPlaceService.getMyPlaceInfo();
    await checkLocationPermission();
    await checkBatteryPermission();
    loadEvent();
  }

  Future<bool> checkLocationPermission() async {
    PermissionStatus status = await Permission.locationAlways.status;

    if (status != PermissionStatus.granted) {
      _showRequestLocationAlways();
      return false;
    }

    return true;
  }

  Future<void> checkBatteryPermission() async {
    bool batteryPermissionGranted =
        await OptimizeBattery.isIgnoringBatteryOptimizations();
    if (batteryPermissionGranted == false) {
      _showRequestBattery();
    }
  }

  loadEvent() async {
    final popupData = await SecureStorage().secureStorage.read(key: popupKey);
    if (popupData == null ||
        popupData != DateTime.now().toString().split(" ")[0]) {
      var events;
      // List<Event> events = await announcementService.getEvents();

      // if (events.isEmpty) {
      //   return;
      // }
      Get.bottomSheet(
        EventPopUp(events: events),
        backgroundColor: AppColors.backgroundSecondary,
      );
    }
  }

  void _showRequestLocationAlways() {
    Get.dialog(
      AlertDialog(
        title: const Text(
          '위치 권한을 "항상 허용"으로 바꿔주세요!',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w400,
          ),
        ),
        content: Text(
          '앱을 켜지 않아도 땅따먹기를 할 수 있어요!',
          style: TextStyles.fs17w400cTextSecondary,
        ),
        actions: [
          TextButton(
            child: Text(
              '아니오',
              style: TextStyles.fs17w600cAccent,
            ),
            onPressed: () async {
              Get.back();
            },
          ),
          TextButton(
            child: Text(
              '예',
              style: TextStyles.fs17w700cPrimary,
            ),
            onPressed: () {
              openAppSettings();
              Get.back();
            },
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: AppColors.boxColor,
      ),
    );
  }

  void _showRequestBattery() {
    Get.dialog(
      AlertDialog(
        title: const Text(
          '배터리 최적화를 해제 해주세요!',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w400,
          ),
        ),
        content: Text(
          '만보기 기능과 땅따먹기 기능이 예기치 않게 종료되지 않아요! ',
          style: TextStyles.fs17w400cTextSecondary,
        ),
        actions: [
          TextButton(
            child: Text(
              '아니오',
              style: TextStyles.fs17w600cAccent,
            ),
            onPressed: () async {
              Get.back();
            },
          ),
          TextButton(
            child: Text(
              '예',
              style: TextStyles.fs17w700cPrimary,
            ),
            onPressed: () async {
              await OptimizeBattery.stopOptimizingBatteryUsage();
              Get.back();
            },
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: AppColors.boxColor,
      ),
    );
  }

  void _showNewFeature() {
    Get.dialog(
      AlertDialog(
        title: const Text(
          '그룹 기능 출시!',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w400,
          ),
        ),
        content: Text(
          '이제 그룹원들과 함께 점령할 수 있어요! 지금 바로 원하는 그룹에 가입해서 그룹의 랭킹을 높여보세요!!',
          style: TextStyles.fs17w400cTextSecondary,
        ),
        actions: [
          TextButton(
            child: Text(
              '닫기',
              style: TextStyles.fs17w700cPrimary,
            ),
            onPressed: () async {
              Get.back();
            },
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: AppColors.boxColor,
      ),
    );
  }
}
