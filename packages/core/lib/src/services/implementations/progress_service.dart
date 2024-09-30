import 'package:core/core.dart';
import 'package:shared_preferences/shared_preferences.dart';

ProgressController get progressController => ProgressController._instance;

class ProgressController extends IProgressController {
  ProgressController._();

  static final ProgressController _instance = ProgressController._();

  int _currentStep = 0;
  int get currentStep => _currentStep;

  @override
  Future<void> init() async {
    _currentStep = await _ProgressRepository.getCurrentStep();
  }

  @override
  Future<void> progress() async {
    _currentStep++;
    await _ProgressRepository.saveCurrentStep(_currentStep);
  }
}

class _ProgressRepository {
  static const _currentStepKey = '_productTourCurrentStep';

  static Future<int> getCurrentStep() async {
    final sharedPreferences = coreSl<SharedPreferences>();
    final currentStep = await sharedPreferences.getInt(_currentStepKey) ?? 0;

    return currentStep;
  }

  static Future<void> saveCurrentStep(int currentStep) async {
    final sharedPreferences = coreSl<SharedPreferences>();
    await sharedPreferences.setInt(_currentStepKey, currentStep);
  }
}
