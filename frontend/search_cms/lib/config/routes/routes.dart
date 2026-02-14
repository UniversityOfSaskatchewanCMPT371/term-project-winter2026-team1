import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:search_cms/features/authentication/presentation/pages/login_page.dart';


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
  ],
);
