import 'package:flutter/foundation.dart';

// 1. Default these to empty strings so we can check if they were actually provided
const String _envSupabaseUrl = String.fromEnvironment('SUPABASE_URL', defaultValue: '');
const String _envPowersyncUrl = String.fromEnvironment('POWERSYNC_URL', defaultValue: '');

class AppConfig {
  
  // This helper strictly handles figuring out the correct "localhost" string
  static String get _localHostString {
    final isApple =
        defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS;
    return (kIsWeb || isApple) ? 'http://localhost' : 'http://127.0.0.1';
  }

  // Supabase Logic
  static String get supabaseUrl {
    // If the environment is passed update it.
    if (_envSupabaseUrl.isNotEmpty) {
      return _envSupabaseUrl; 
    }
    // Fallback to local if its not up.
    return '$_localHostString:54321';
  }

  static String get powersyncUrl {
    // Same logic: use the injected URL if it exists
    if (_envPowersyncUrl.isNotEmpty) {
      return _envPowersyncUrl;
    }
    // Fallback to local
    return '$_localHostString:8080';
  }

  static const String supabaseAnonKey =
  // ignore: lines_longer_than_80_chars
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYW5vbiIsImlzcyI6InN1cGFiYXNlIiwiaWF0IjoxNzY5Nzk2OTk2LCJleHAiOjE5Mjc0NzY5OTZ9.tWcV_u7-NL8wTrmMS5irJ7JA7E23C37BOY8163wqYcY';
}