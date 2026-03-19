import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:logging/logging.dart';

import 'basic_functionality_test.dart';
import 'health_checks_test.dart';
import 'render_pages_test.dart';
import 'sync_test.dart';

void main() async {
  final Logger logger = Logger('Smoke Test');

  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('Smoke Tests', () {
    healthChecksTest(logger);
    renderPagesTest(logger);
    basicFunctionalityTest(logger);
    syncTest(logger);
  });
}