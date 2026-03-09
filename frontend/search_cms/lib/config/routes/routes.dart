import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:search_cms/features/authentication/presentation/pages/login_page.dart';
import 'package:search_cms/features/dashboard/presentation/bloc/home_cubit.dart';
import 'package:search_cms/features/dashboard/presentation/pages/dashboard_add_page.dart';
import 'package:search_cms/features/dashboard/presentation/pages/dashboard_home_page.dart';
import 'package:search_cms/features/dashboard/presentation/pages/dashboard_layout.dart';

/*
The route settings for the application.
  Remember to define your routes here when you add new pages.
  This is navigator 2.0.
  Calls to navigator 1.0 are tolerated by the system but they shouldn't be
  used as they can cause unexpected bugs.
*/

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
          builder: (context, state) => BlocProvider(
            create: (_) => HomeCubit()..init(),
            child: const DashboardHomePage()
          )
          
        ),
        GoRoute(
          path: '/dashboard/add',
          builder: (context, state) => const DashboardAddPage(),
        ),
      ],
    ),
  ],
);
