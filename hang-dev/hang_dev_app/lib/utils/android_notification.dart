import 'dart:async';
import 'dart:isolate';

import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:hang_dev_app/services/android_walking_service.dart';
import 'package:hang_dev_app/utils/secure_storage.dart';

Future<void> initForegroundTask() async {
  if (!await FlutterForegroundTask.isRunningService) {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'ground-flip',
        channelName: 'ground-flip Notification',
        channelDescription:
            'This notification appears when the ground-flip is running.',
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
        iconData: const NotificationIconData(
          resType: ResourceType.mipmap,
          resPrefix: ResourcePrefix.ic,
          name: 'background_app_icon',
        ),
        isSticky: true,
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
        playSound: false,
      ),
      foregroundTaskOptions: const ForegroundTaskOptions(
        interval: 1000,
        isOnceEvent: false,
        autoRunOnBoot: true,
        allowWakeLock: true,
        allowWifiLock: true,
      ),
    );
    FlutterForegroundTask.startService(
      notificationTitle: "걸음수",
      notificationText: "0",
      callback: startCallback,
    );
  }
}

@pragma('vm:entry-point')
Future<void> startCallback() async {
  FlutterForegroundTask.setTaskHandler(AndroidWalkingHandler());
}

class AndroidWalkingHandler extends TaskHandler {
  late Stream<StepCount> stepCountStream;
  final SecureStorage secureStorage = SecureStorage();
  final AndroidWalkingService walkingService = AndroidWalkingService();

  static String todayStepKey = 'currentSteps';
  static String lastSavedStepKey = 'lastSteps'
  
  static int currentSteps = 0;

  
  @override
  void onDestroy(DateTime timestamp, SendPort? sendPort) {}

  @override
  void onRepeatEvent(DateTime timestamp, SendPort? sendPort) {
    // TODO: implement onRepeatEvent
  }

  @override
  void onStart(DateTime timestamp, SendPort? sendPort) {
    // TODO: implement onStart
  }
}
