import 'package:multichoice/app/run_multichoice.dart';
import 'package:multichoice/config/app_flavor.dart';

void main() async {
  assert(
    AppFlavor.isProd,
    'Run with --dart-define-from-file=config/production_config.json',
  );
  await runMultichoice();
}
