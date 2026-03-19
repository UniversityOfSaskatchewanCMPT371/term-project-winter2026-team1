import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:integration_test/integration_test.dart';
import 'package:logging/logging.dart';
import 'package:search_cms/core/app_config.dart';
import 'package:search_cms/core/injections.dart';
import 'package:search_cms/core/utils/constants.dart';
import 'package:search_cms/main.dart';

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