import 'package:flutter_supabase_template/features/counter/domain/usecases/counter_page_increment_and_upload_use_case.dart';

import 'counter_page_loading_use_case.dart';

class CounterPageUseCases {
  final CounterPageLoadingUseCase counterPageLoadingUseCase;
  final CounterPageIncrementAndUploadUseCase counterPageIncrementAndUploadUseCase;

  CounterPageUseCases({
    required this.counterPageLoadingUseCase,
    required this.counterPageIncrementAndUploadUseCase,
  });
}