import 'dart:io';

import 'package:hang_dev_app/services/android_walking_service.dart';
import 'package:hang_dev_app/services/ios_walking_service.dart';
import 'package:hang_dev_app/utils/walking_service.dart';

class WalklingServiceFactory {
  static WalkingService getWalkingService() {
    if (Platform.isIOS) {
      IosWalkingService().init();
      return IosWalkingService();
    } else if (Platform.isAndroid) {
      AndroidWalkingService().init();
      return AndroidWalkingService();
    } else {
      throw UnsupportedError(
          'None supported platform, please use IOS or Android');
    }
  }
}
