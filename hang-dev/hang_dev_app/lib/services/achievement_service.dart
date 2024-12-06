import 'package:dio/dio.dart';
import 'package:hang_dev_app/models/achievement.dart';
import 'package:hang_dev_app/models/achievementByCategory.dart';
import 'package:hang_dev_app/models/user_achievements.dart';
import 'package:hang_dev_app/services/dio_service.dart';
import 'package:hang_dev_app/utils/secure_storage.dart';

class AchievementService {
  static final AchievementService _instance = AchievementService._internal();
  AchievementService._internal();
  final SecureStorage secureStorage = SecureStorage();
  final Dio dio = DioService().getDio();

  factory AchievementService() {
    return _instance;
  }

  Future<UserAchievements> getUserAchievements(int userId, int? count) async {
    var response = await dio.get(
      '/achievements/user',
      queryParameters: {"user-id": userId, 'count': count},
    );
    return UserAchievements.fromJson(response.data['data']);
  }

  Future<Achievement> getAchievementInfo(int userId, int achievementId) async {
    String? accessToken = await secureStorage.readAccessToken();
    var response = await dio.get('/achievements/$achievementId', data: {
      "accessToken": accessToken,
    });
    return response.data['data'];
  }

  Future<AchievementsByCategory> getAchievementsByCategory(
      int userId, int categoryId) async {
    String? accessToken = await secureStorage.readAccessToken();
    var response = await dio.get(
      '/achievements/category/$categoryId',
      data: {
        "accessToken": accessToken,
      },
    );
    return response.data['data'];
  }
}
