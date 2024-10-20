import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hang_dev_app/models/my_place.dart';
import 'package:hang_dev_app/services/dio_service.dart';
import 'package:hang_dev_app/utils/user_manager.dart';

class MyPlaceService {
  static final MyPlaceService _instance = MyPlaceService._internal();
  final Dio dio = DioService().getDio();

  MyPlaceService._internal();

  final box = GetStorage();

  // factory
  factory MyPlaceService() => _instance;

  Future<List<MyPlace>> getMyPlaceInfo() async {
    List<MyPlace> myPlaces;
    int? userId = UserManager().getUserId();
    var response = await dio.get('/myplace/$userId');
    myPlaces = MyPlace.listFromJson(response.data['data']);
    for (var e in myPlaces) {
      box.write(e.placeName.toString(), e.placePoint!);
    }
    return myPlaces;
  }

  Future<void> putMyPlaceInfo(
      String placeName, double latitude, double longitude) async {
    int? userId = UserManager().getUserId();
    await dio.put('/myplace', data: {
      "userId": userId,
      "placeName": placeName,
      "latitude": latitude,
      "longitude": longitude,
    });
  }

  Future<void> deleteMyPlaceInfo(String placeName) async {
    int? userId = UserManager().getUserId();
    await dio
        .delete('/myplace', data: {"userId": userId, "placeName": placeName});
  }
}
