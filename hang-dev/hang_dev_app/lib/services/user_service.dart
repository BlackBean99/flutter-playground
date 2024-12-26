import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:hang_dev_app/models/user.dart';
import 'package:hang_dev_app/models/user_pixel_count.dart';
import 'package:hang_dev_app/services/dio_service.dart';
import 'package:hang_dev_app/utils/secure_storage.dart';
import 'package:hang_dev_app/utils/user_manager.dart';

class UserService {
  static final UserService _instance = UserService._internal();
  UserService._internal();

  final SecureStorage secureStorage = SecureStorage();
  final Dio dio = DioService().getDio();

  factory UserService() {
    return _instance;
  }
  Future<User> getCurrentUserInfo() async {
    int? userId = UserManager().getUserId();
    var response = await dio.get('/users/$userId');
    return User.fromJson(response.data['data']);
  }

  Future<UserPixelCount> getUserPixelCount(String? lookUpDate) async {
    int? userId = UserManager().getUserId();
    var response = await dio.get(
      '/pixels/count',
      queryParameters: {"user-id": userId, 'lookup-date': lookUpDate},
    );
    return UserPixelCount.fromJson(response.data['data']);
  }

  Future<UserPixelCount> getAnotherUserPixelCount(
      String? lookUpDate, int userId) async {
    var response = await dio.get(
      '/pixels/count',
      queryParameters: {"user-id": userId, 'lookup-date': lookUpDate},
    );
    return UserPixelCount.fromJson(response.data['data']);
  }

  deleteUser() async {
    String? accessToken = await secureStorage.readAccessToken();
    String? refreshToken = await secureStorage.readRefreshToken();
    await dio.delete('/users/${UserManager().userId}', data: {
      "accessToken": accessToken,
      "refreshToken": refreshToken,
    });
    await secureStorage.deleteAccessToken();
    await secureStorage.deleteRefreshToken();
  }

  Future<int?> putUserInfo({
    required String gender,
    required int birthYear,
    required String nickname,
    String? profileImagePath,
  }) async {
    int? userId = UserManager().getUserId();
    late String fileName;
    var userInfoJson = jsonEncode(
      {
        'gender': gender,
        'birthYear': birthYear,
        'nickname': nickname,
      },
    );
    var formData = FormData();

    formData.files.add(MapEntry(
        'userInfoRequest',
        MultipartFile.fromString(
          userInfoJson,
          contentType: DioMediaType.parse('application/json'),
        )));
    if (profileImagePath != null) {
      fileName = profileImagePath.split('/').last;
      formData.files.add(MapEntry('profileImage',
          await MultipartFile.fromFile(profileImagePath, filename: fileName)));
    }
    var response = await dio.put(
      '/users/$userId',
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );
    return response.statusCode;
  }
}
