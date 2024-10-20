abstract class WalkingService {
  Future<int> getCurrentStep();

  Future<List<int>> getDailyStepsInInterval(
      DateTime startTime, DateTime endDate);
  bool isWalking();
}
