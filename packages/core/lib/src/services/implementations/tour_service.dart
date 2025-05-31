import 'package:core/core.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@injectable
class TourService implements ITourService {
  static const String _lastStepKey = 'tour_last_step';
  static const String _isSkippedKey = 'tour_is_skipped';

  @override
  Future<void> saveTourProgress(int? lastStep, bool isSkipped) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_lastStepKey, lastStep ?? -1);
    await prefs.setBool(_isSkippedKey, isSkipped);
  }

  @override
  Future<Map<String, dynamic>> getTourProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final lastStep = prefs.getInt(_lastStepKey);
    final isSkipped = prefs.getBool(_isSkippedKey) ?? false;

    return {
      'lastStep': lastStep == -1 ? null : lastStep,
      'isSkipped': isSkipped,
    };
  }

  @override
  Future<void> resetTourProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_lastStepKey);
    await prefs.remove(_isSkippedKey);
  }
}
