import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:search_cms/core/utils/constants.dart';
import 'package:search_cms/features/dashboard/domain/entities/get_all_table_rows_result_classes.dart'
    as get_all_table_rows_result_classes;
import 'package:search_cms/features/dashboard/domain/usecases/dashboard_usecases.dart';
import 'package:search_cms/features/dashboard/domain/usecases/get_all_table_rows_usecase.dart';
import 'package:search_cms/features/dashboard/presentation/bloc/home_cubit.dart';
import 'package:search_cms/features/dashboard/presentation/pages/dashboard_home_page.dart';
import 'package:sizer/sizer.dart';
import 'dashboard_home_page_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<DashboardUsecases>(),
  MockSpec<GetAllTableRowsUseCase>(),
])
void main() async {
  final TestWidgetsFlutterBinding testWidgetsFlutterBinding =
      TestWidgetsFlutterBinding.ensureInitialized();

  // Set screen sizes and ratio
  testWidgetsFlutterBinding.platformDispatcher.views.first.physicalSize = Size(
    1920,
    1080,
  );
  testWidgetsFlutterBinding.platformDispatcher.views.first.devicePixelRatio =
      1.0;

  // Build mocked classes
  MockDashboardUsecases mockDashboardUsecases = MockDashboardUsecases();
  MockGetAllTableRowsUseCase mockGetAllTableRowsUseCase =
      MockGetAllTableRowsUseCase();

  // Mock responses
  when(
    mockDashboardUsecases.getAllTableRowsUseCase,
  ).thenReturn(mockGetAllTableRowsUseCase);
  when(mockGetAllTableRowsUseCase.call()).thenAnswer(
    (_) async =>
        get_all_table_rows_result_classes.Success(listOfTableRowEntity: []),
  );

  // Dependency injections
  getIt.registerSingleton<DashboardUsecases>(mockDashboardUsecases);
  getIt.registerSingleton<GetAllTableRowsUseCase>(mockGetAllTableRowsUseCase);
  getIt.registerFactory<HomeCubit>(
    () => HomeCubit(dashboardUsecases: MockDashboardUsecases()),
  );

  // Homepage widget tests
  testWidgets('Homepage widget tests', (tester) async {
    await tester.pumpWidget(
      Sizer(
        builder: (_, _, _) {
          return MaterialApp(
            home: Scaffold(
              body: BlocProvider(
                create: (_) =>
                    HomeCubit(dashboardUsecases: mockDashboardUsecases)..init(),
                child: DashboardHomePage(),
              ),
            ),
          );
        },
      ),
    );

    await tester.pumpAndSettle();

    // Check if Search text if present
    expect(find.text('Search'), findsWidgets);

    // Check if all column rows are shown
    expect(find.text('Advanced Search'), findsOneWidget);
    expect(find.text('Borden'), findsOneWidget);
    expect(find.text('Site Name'), findsOneWidget);
    expect(find.text('Area'), findsOneWidget);
    expect(find.text('Unit'), findsOneWidget);
    expect(find.text('Level'), findsOneWidget);
    expect(find.text('Up Limit'), findsOneWidget);
    expect(find.text('Low Limit'), findsOneWidget);
    expect(find.text('Assemblage'), findsOneWidget);
    expect(find.text('Porosity'), findsOneWidget);
    expect(find.text('Size Upper'), findsOneWidget);
    expect(find.text('Size Lower'), findsOneWidget);
    expect(find.text('Pre Excav Frags'), findsOneWidget);
    expect(find.text('Post Excav Frags'), findsOneWidget);
    expect(find.text('Elements'), findsOneWidget);
    expect(find.text('Comment'), findsOneWidget);

    // Check if the search bar exists
    expect(find.byKey(Key("basicSearchBar")), findsOneWidget);

    // Check if the search button exists
    expect(find.byKey(Key("searchButton")), findsOneWidget);

    // Click the advanced search toggle button
    await tester.tap(find.text('Advanced Search'));

    await tester.pumpAndSettle();

    // Check if the search bar switches mode
    expect(find.text('Advanced Search...'), findsOneWidget);
  });
}
