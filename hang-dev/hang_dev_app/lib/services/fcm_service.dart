import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hang_dev_app/services/dio_service.dart';

import '../utils/user_manager.dart';

class FcmService {
  static final FcmService _instance = FcmService._internal();

  final Dio dio = DioService().getDio();

  FcmService._internal();

  factory FcmService() {
    return _instance;
  }

  registerFcmToken() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    dio.post(
      "/users/fcm-token",
      data: {
        "userId": UserManager().getUserId(),
        "fcmToken": fcmToken,
        "device": Platform.isIOS ? "IOS" : "ANDROID",
      },
    );
  }
}
