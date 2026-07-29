import 'package:multichoice/app/run_multichoice.dart';
import 'package:multichoice/config/app_flavor.dart';

void main() async {
  assert(
    AppFlavor.isDev,
    'Run with --dart-define-from-file=config/develop_config.json',
  );
  await runMultichoice();
}
