/*
Widget tests for LoginPage form behavior.

These tests verify that the login UI renders expected fields and that
built-in validation prevents submission when input is invalid.

Uses external test cases from login_page_testcases.dart
*/

import 'package:flutter/material.dart';
import 'package:search_cms/features/authentication/presentation/pages/login_page.dart';
import 'package:sizer/sizer.dart';
import 'login_page_testcases.dart';

void main() {
  Widget wrap(Widget child) {
    return Sizer(
      builder: (_, __, ___) {
        return MaterialApp(home: child);
      },
    );
  }

  runLoginPageTestCases(() => wrap(const LoginPage()));

}