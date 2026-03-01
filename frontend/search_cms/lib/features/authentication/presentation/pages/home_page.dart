import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:search_cms/core/utils/constants.dart';
import 'package:search_cms/features/authentication/presentation/bloc/home_cubit.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final log = Logger('HomePage');

  /* */
  @override
  void dispose() {
    super.dispose();
  }

  /*
    The widget building method.
    This is the main place where our definitions of the widget lives.
    It shouldn't have side effect other than building the widget.
   */
  @override
  Widget build(BuildContext context) {

    // BlocProvider creates the HomeCubit class
    return BlocProvider(
      create: (_) => HomeCubit(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Center(),
      ),
    );
  }
}
