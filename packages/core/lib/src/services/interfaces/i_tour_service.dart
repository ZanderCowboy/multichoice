abstract class ITourService {
  Future<void> saveTourProgress(int? lastStep, bool isSkipped);

  Future<Map<String, dynamic>> getTourProgress();

  Future<void> resetTourProgress();
}
