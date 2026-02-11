import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_supabase_template/features/counter/presentation/pages/counter_page.dart';
import 'package:go_router/go_router.dart';
import '../../core/utils/constants.dart';
import '../../features/counter/presentation/bloc/counter_page_bloc.dart';

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return BlocProvider(
          create: (context) => getIt<CounterPageBloc>(),
          child: CounterPage(),
        );
      },
    ),
  ],
);