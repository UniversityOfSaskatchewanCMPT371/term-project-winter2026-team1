import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:powersync/powersync.dart' show PowerSyncDatabase;
import 'package:search_cms/core/utils/constants.dart';
import 'package:sizer/sizer.dart';

import '../../data/data_sources/dashboard_api_impl.dart';
import '../bloc/data_table_cubit.dart';
import '../bloc/home_cubit.dart';
import '../bloc/home_state.dart';
import 'data_table.dart';

/// Main dashboard home page, showed by default after logging in
/// Contains title card, search entry point, and data display widgets
class DashboardHomePage extends StatelessWidget {
  const DashboardHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DataTableCubit>(
      create: (_) => DataTableCubit(
        dashboardApi: DashboardApiImpl(
          database: getIt<PowerSyncDatabase>(),
        ),
      )..initialFetch(),
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          // Show loading indicator until cubit emits DashboardLoaded
          if (state is! HomeLoaded) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 1.w),
                  Text.rich(
                    TextSpan(
                      text: 'Home',
                      style: TextStyle(
                        fontSize: 7.sp,
                        color: AppColors.mainText,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text.rich(
                    TextSpan(
                      text: 'Last Updated: 2024-06-01',
                      style: TextStyle(
                        fontSize: 3.sp,
                        color: AppColors.mutedText,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                  SizedBox(width: 1.w),
                ],
              ),

              const Divider(
                height: 2,
                thickness: 2,
                indent: 5,
                endIndent: 5,
                color: AppColors.inputBorder,
              ),

              SizedBox(height: 2.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 1.w),
                  SearchToggle(
                    onSelectionChanged: (index) {
                      context.read<HomeCubit>().updateSearchToggle(index);
                    },
                  ),
                ],
              ),

              SizedBox(height: 2.h),

              if (state.selectedSearch == 0)
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: 1.w),
                    const Expanded(
                      child: BasicSearchBar(),
                    ),
                    SizedBox(width: 35.w),
                    FilterColumnsPopup(
                      selectedColumns: state.selectedColumns,
                      onSelectionChanged: (columns) {
                        context
                            .read<HomeCubit>()
                            .updateSelectedColumns(columns);
                      },
                    ),
                    SizedBox(width: 1.w),
                  ],
                )
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: 1.w),
                    const Expanded(
                      child: AdvancedSearchBar(),
                    ),
                    SizedBox(width: 35.w),
                    FilterColumnsPopup(
                      selectedColumns: state.selectedColumns,
                      onSelectionChanged: (columns) {
                        context
                            .read<HomeCubit>()
                            .updateSelectedColumns(columns);
                      },
                    ),
                    SizedBox(width: 1.w),
                  ],
                ),

              const SizedBox(height: 20),

              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(2.5.h),
                  child: const DataTableWidget(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Class for the search / advanced search toggle buttons
class SearchToggle extends StatefulWidget {
  final ValueChanged<int> onSelectionChanged;

  const SearchToggle({
    super.key,
    required this.onSelectionChanged,
  });

  @override
  State<SearchToggle> createState() => _SearchToggleState();
}

class _SearchToggleState extends State<SearchToggle> {
  final List<bool> _selected = [true, false];

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      direction: Axis.horizontal,
      onPressed: (int index) {
        setState(() {
          for (int i = 0; i < _selected.length; i++) {
            _selected[i] = i == index;
          }
          widget.onSelectionChanged(index);
        });
      },
      borderRadius: const BorderRadius.all(Radius.circular(12)),
      selectedBorderColor: Colors.black,
      borderColor: Colors.black,
      borderWidth: 1,
      selectedColor: Colors.white,
      fillColor: Colors.blueGrey,
      color: Colors.grey[850],
      constraints: const BoxConstraints(
        minHeight: 40.0,
        minWidth: 80.0,
      ),
      isSelected: _selected,
      children: const [
        SizedBox(width: 80, child: Center(child: Text('Search'))),
        SizedBox(width: 140, child: Center(child: Text('Advanced Search'))),
      ],
    );
  }
}

/// Basic Search Bar
class BasicSearchBar extends StatelessWidget {
  const BasicSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: const InputDecoration(
        hintText: 'Search...',
        border: OutlineInputBorder(),
      ),
      onSubmitted: (String query) {
        final String trimmedQuery = query.trim();

        if (trimmedQuery.isEmpty) {
          context.read<DataTableCubit>().initialFetch();
          return;
        }

        context.read<DataTableCubit>().basicFetch(trimmedQuery);
      },
    );
  }
}

/// Placeholder for advanced search
class AdvancedSearchBar extends StatelessWidget {
  const AdvancedSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: const InputDecoration(
        hintText: 'Advanced Search...',
        border: OutlineInputBorder(),
      ),
      onSubmitted: (_) {
        context.read<DataTableCubit>().advancedFetch();
      },
    );
  }
}

/// Class for the filter columns popup
class FilterColumnsPopup extends StatelessWidget {
  final Set<String> selectedColumns;
  final ValueChanged<Set<String>> onSelectionChanged;

  const FilterColumnsPopup({
    super.key,
    required this.selectedColumns,
    required this.onSelectionChanged,
  });

  void _openDialog(BuildContext context) {
    Set<String> pending = Set<String>.from(selectedColumns);

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Filter Columns',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 200),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: SizedBox(
            width: 80.w,
            height: 80.h,
            child: Material(
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: StatefulBuilder(
                  builder: (context, setDialogState) {
                    return Column(
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Filter Columns',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
                        Expanded(
                          child: ListView(
                            children: ['Title', 'Site', 'Unit', 'Level']
                                .map((String e) {
                              return CheckboxListTile(
                                title: Text(e),
                                value: pending.contains(e),
                                onChanged: (bool? isSelected) {
                                  setDialogState(() {
                                    if (isSelected == true) {
                                      pending.add(e);
                                    } else {
                                      pending.remove(e);
                                    }
                                  });
                                },
                              );
                            }).toList(),
                          ),
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                onSelectionChanged(Set<String>.from(pending));
                                Navigator.of(context).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryBlue,
                              ),
                              child: const Text('Apply'),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () => _openDialog(context),
      child: const Text('Filter Columns'),
    );
  }
}