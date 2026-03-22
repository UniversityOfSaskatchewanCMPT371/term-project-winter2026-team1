import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:logging/logging.dart';
import 'package:search_cms/core/injections.dart';

import 'smoke_tests/basic_functionality_test.dart';
import 'smoke_tests/health_checks_test.dart';
import 'smoke_tests/render_pages_test.dart';
import 'smoke_tests/sync_test.dart';

void main() async {
  await initInjections();

  final Logger logger = Logger('Smoke Test');

  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('Smoke Tests', () {
    healthChecksTest(logger);
    renderPagesTest(logger);
    basicFunctionalityTest(logger);
    syncTest(logger);
  });
}