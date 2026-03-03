import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:search_cms/features/authentication/presentation/pages/login_page.dart';
import 'package:search_cms/features/dashboard/presentation/pages/dashboard_layout.dart';
import 'package:search_cms/features/dashboard/presentation/pages/dashboard_home_page.dart';
import 'package:search_cms/features/dashboard/presentation/pages/dashboard_add_page.dart';

final GoRouter router = GoRouter(
  initialLocation: '/login',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      redirect: (context, state) => '/login',
    ),
    GoRoute(
      path: '/login',
      builder: (BuildContext context, GoRouterState state) {
        return const LoginPage();
      },
    ),
    ShellRoute(
      builder: (context, state, child) {
        return DashboardLayout(child: child);
      },
      routes: [
        GoRoute(
          path: '/dashboard/home',
          builder: (context, state) => const DashboardHomePage(),
        ),
        GoRoute(
          path: '/dashboard/add',
          builder: (context, state) => const DashboardAddPage(),
        ),
      ],
    ),
  ],
);
