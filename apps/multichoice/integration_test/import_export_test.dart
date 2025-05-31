import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

/// This test will run a journey where the user
///
/// - opens the app with existing data,
/// - exports the data,
/// - clears all existing data after successfully exporting,
/// - imports new data,
/// - and exits.
///
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Import and Export Journey', (tester) async {});
}
