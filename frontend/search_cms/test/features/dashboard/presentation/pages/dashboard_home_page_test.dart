import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:search_cms/features/dashboard/presentation/bloc/home_cubit.dart';
import 'package:search_cms/features/dashboard/presentation/pages/dashboard_home_page.dart';
import 'package:sizer/sizer.dart';

void main() {
  Widget buildTestableWidget(Widget child) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          home: Scaffold(
            body: BlocProvider(
              create: (_) => HomeCubit()..init(),
              child: child,
            ),
          ),
        );
      },
    );
  }

  group('DashboardHomePage widget tests', () {
    testWidgets('renders home page title and last updated text', (
      WidgetTester tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(1600, 1000));

      await tester.pumpWidget(buildTestableWidget(const DashboardHomePage()));
      await tester.pumpAndSettle();

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Last Updated: 2024-06-01'), findsOneWidget);

      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('renders default basic search UI', (
      WidgetTester tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(1600, 1000));

      await tester.pumpWidget(buildTestableWidget(const DashboardHomePage()));
      await tester.pumpAndSettle();

      expect(find.text('Search'), findsOneWidget);
      expect(find.text('Advanced Search'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Filter Columns'), findsOneWidget);
      expect(find.text('Search...'), findsOneWidget);

      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('switches from basic search to advanced search', (
      WidgetTester tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(1600, 1000));

      await tester.pumpWidget(buildTestableWidget(const DashboardHomePage()));
      await tester.pumpAndSettle();

      expect(find.text('Search...'), findsOneWidget);
      expect(find.text('Advanced Search...'), findsNothing);

      await tester.tap(find.text('Advanced Search'));
      await tester.pumpAndSettle();

      expect(find.text('Advanced Search...'), findsOneWidget);
      expect(find.text('Search...'), findsNothing);

      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('opens filter columns popup and shows options', (
      WidgetTester tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(1600, 1000));

      await tester.pumpWidget(buildTestableWidget(const DashboardHomePage()));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Filter Columns'));
      await tester.pumpAndSettle();

      expect(find.text('Title'), findsOneWidget);
      expect(find.text('Site'), findsOneWidget);
      expect(find.text('Unit'), findsOneWidget);
      expect(find.text('Level'), findsOneWidget);
      expect(find.text('Apply'), findsOneWidget);

      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('filter popup closes when apply is pressed', (
      WidgetTester tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(1600, 1000));

      await tester.pumpWidget(buildTestableWidget(const DashboardHomePage()));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Filter Columns'));
      await tester.pumpAndSettle();

      expect(find.text('Apply'), findsOneWidget);

      await tester.tap(find.text('Apply'));
      await tester.pumpAndSettle();

      expect(find.text('Apply'), findsNothing);

      await tester.binding.setSurfaceSize(null);
    });
  });
}