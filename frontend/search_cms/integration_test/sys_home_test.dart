import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:integration_test/integration_test.dart';
import 'package:logging/logging.dart';
import 'package:search_cms/core/injections.dart';
import 'package:search_cms/core/utils/constants.dart';
import 'package:search_cms/features/dashboard/presentation/bloc/home_cubit.dart';
import 'package:search_cms/features/dashboard/presentation/pages/dashboard_home_page.dart';
import 'package:sizer/sizer.dart';

// Helper functions

// Build a copy of the real router for use in this test suite
GoRouter _buildTestRouter() {
  return GoRouter(
    initialLocation: '/dashboard/home',
    routes: [
      GoRoute(
        path: '/dashboard/home',
        builder: (_, __) => BlocProvider(
          create: (_) => HomeCubit()..init(),
          child: const Scaffold(
            body: DashboardHomePage(),
          ),
        ),
      ),
    ],
  );
}