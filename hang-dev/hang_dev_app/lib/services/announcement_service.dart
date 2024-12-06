// import 'package:dio/dio.dart';
// import 'package:hang_dev_app/models/event.dart';
// import 'package:hang_dev_app/services/dio_service.dart';

// class AnnouncementService {
//   static final AnnouncementService _instance = AnnouncementService._internal();
//   AnnouncementService._internal();

//   final Dio dio = DioService().getDio();

//   factory AnnouncementService() {
//     return _instance;
//   }

//   Future<List<Event>> getEvents() async {
//     try {
//       var response = await dio.get('/announcement/events');
//       return Event.listFromJson(response.data['data']);
//     } catch (e) {
//       print(e);
//       return [];
//     }
//     Future<List<Announcement>> get
// }
