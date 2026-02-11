// Copy this template: `cp lib/app_config_template.dart lib/app_config.dart`
// Edit lib/app_config.dart and enter your Supabase and PowerSync project details.
import 'package:flutter/foundation.dart';

class AppConfig {
  // Use localhost for iOS/macOS/Web, 10.0.2.2 for Android emulator
  static String get _host {
    final isApple =
        defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS;
    return (kIsWeb || isApple) ? 'http://localhost' : 'http://10.0.2.2';
  }

  static String get supabaseUrl => '$_host:54321';
  static String get powersyncUrl => '$_host:8080';

  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYW5vbiIsImlzcyI6InN1cGFiYXNlIiwiaWF0IjoxNzY5Nzk2OTk2LCJleHAiOjE5Mjc0NzY5OTZ9.tWcV_u7-NL8wTrmMS5irJ7JA7E23C37BOY8163wqYcY';
}
