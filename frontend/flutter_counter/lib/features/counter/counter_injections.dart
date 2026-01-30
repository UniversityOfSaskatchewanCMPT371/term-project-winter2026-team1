import 'package:flutter_supabase_template/features/counter/data/data_sources/counter_page_increment_and_upload_api_impl.dart';
import 'package:flutter_supabase_template/features/counter/data/data_sources/counter_page_loading_api_impl.dart';
import 'package:flutter_supabase_template/features/counter/data/repositories/counter_page_increment_and_upload_repository_impl.dart';
import 'package:flutter_supabase_template/features/counter/data/repositories/counter_page_loading_repository_impl.dart';
import 'package:flutter_supabase_template/features/counter/domain/usecases/counter_page_increment_and_upload_use_case.dart';
import 'package:flutter_supabase_template/features/counter/domain/usecases/counter_page_loading_use_case.dart';
import 'package:flutter_supabase_template/features/counter/domain/usecases/counter_page_use_cases.dart';
import 'package:flutter_supabase_template/features/counter/presentation/bloc/counter_page_bloc.dart';
import 'package:flutter_supabase_template/utils/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void initCounterInjections() {
  registerCounterPage();
}

void registerCounterPage() {
  getIt.registerFactory<CounterPageIncrementAndUploadApiImpl>(() =>
      CounterPageIncrementAndUploadApiImpl(supabaseClient: getIt<SupabaseClient>()));
  getIt.registerFactory<CounterPageIncrementAndUploadRepositoryImpl>(
          () => CounterPageIncrementAndUploadRepositoryImpl(
              api: getIt<CounterPageIncrementAndUploadApiImpl>()));
  getIt.registerFactory<CounterPageIncrementAndUploadUseCase>(() =>
      CounterPageIncrementAndUploadUseCase(repository: getIt<CounterPageIncrementAndUploadRepositoryImpl>()));

  getIt.registerFactory<CounterPageLoadingApiImpl>(() =>
    CounterPageLoadingApiImpl(supabaseClient: getIt<SupabaseClient>())
  );
  getIt.registerFactory<CounterPageLoadingRepositoryImpl>(() =>
    CounterPageLoadingRepositoryImpl(api: getIt<CounterPageLoadingApiImpl>())
  );
  getIt.registerFactory<CounterPageLoadingUseCase>(() =>
      CounterPageLoadingUseCase(repository: getIt<CounterPageLoadingRepositoryImpl>()));

  getIt.registerFactory<CounterPageUseCases>(() => CounterPageUseCases(
      counterPageLoadingUseCase: getIt<CounterPageLoadingUseCase>(),
      counterPageIncrementAndUploadUseCase: getIt<CounterPageIncrementAndUploadUseCase>(),
  ));

  getIt.registerFactory<CounterPageBloc>(() => CounterPageBloc(
      counterPageUseCases: getIt<CounterPageUseCases>()
  ));
}