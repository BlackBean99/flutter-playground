import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hang_dev_app/services/user_service.dart';
import 'package:hang_dev_app/utils/walking_service_factory.dart';

class MapController extends SuperController {
  final PixelService pixelService = PixelService();
  final UserService userSErvice = UserService();
  final CommunityService communityService = CommunityService();
  final LocationService _locationService = LocationSErvice();
  final NotificationService notificationService = NotificationService();
  final WalkingService walkingService =
      WalklingServiceFactory().getWalkingService();
}
