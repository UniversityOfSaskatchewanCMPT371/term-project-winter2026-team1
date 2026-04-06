import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:integration_test/integration_test.dart';
import 'package:logging/logging.dart';
import 'package:search_cms/core/injections.dart';
import 'package:search_cms/core/utils/constants.dart';
import 'package:search_cms/features/dashboard/presentation/bloc/add_data_cubit.dart';
import 'package:search_cms/features/dashboard/presentation/bloc/add_data_state.dart';
import 'package:search_cms/features/dashboard/presentation/pages/dashboard_add_page.dart';
import 'package:sizer/sizer.dart';

