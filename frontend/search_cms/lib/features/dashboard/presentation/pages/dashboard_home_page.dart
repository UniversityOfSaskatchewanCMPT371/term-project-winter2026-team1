import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:search_cms/core/utils/constants.dart';
import 'package:sizer/sizer.dart';
import 'package:two_dimensional_scrollables/two_dimensional_scrollables.dart';

import '../bloc/home_cubit.dart';
import '../bloc/home_state.dart';

import 'data_table.dart';
import '../bloc/data_table_cubit.dart';
import '../bloc/data_table_state.dart';


/// Main dashboard home page, showed by defualt after logging in
/// Contains title card, search entry point, and data display widgets
class DashboardHomePage extends StatelessWidget {
  const DashboardHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        // Show loading indicator until cubit emits DashboardLoaded
        // Will never happen but exists if we ever want to async load the page
        if (state is! HomeLoaded) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.start,
              children: [
                
              // SizedBox is just empty spaced used to layout other widget, add margins, etc.  
              SizedBox(width: 1.w),

              // Home title card
              Text.rich(
                TextSpan(
                  text: 'Home',
                  style: TextStyle(
                    fontSize: 7.sp,
                    color: AppColors.mainText,
                    fontWeight: FontWeight.w300,
                  )
                ),
              ),

              const Spacer(), // Push the last updated text to the right edge of the row
              // TODO: Last updated text, should be dynamic in the future (or NUKED lol)
              Text.rich(
                TextSpan(
                  text: 'Last Updated: 2024-06-01',
                  style: TextStyle(
                    fontSize: 3.sp,
                    color: AppColors.mutedText,
                    fontWeight: FontWeight.w300,
                  ),
                )
              ),
              
              SizedBox(width: 1.w)  
              
              ]
            ),

            // Horizontal bar
            const Divider(
              height: 2,
              thickness: 2,
              indent: 5,
              endIndent: 5,
              color: AppColors.inputBorder,
            ),

            SizedBox(height: 2.h),

            // Search / Advanced Search Toggle
            Row(mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 1.w), // Add some spacing between the left edge and the toggle buttons
                SearchToggle(onSelectionChanged: (index) {
                  context.read<HomeCubit>().updateSearchToggle(index);
                },),
              ]
            ),

            SizedBox(height: 2.h),

            // Search Bar and Filter Columns Dropdown
            // Basic search case
            if (state.selectedSearch == 0)
              Row(mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 1.w),

                  const Expanded(child: BasicSearchBar()),

                  SizedBox(width: 35.w),

                  FilterColumnsPopup(
                    selectedColumns: state.selectedColumns,
                    onSelectionChanged: (columns) {
                      context.read<HomeCubit>().updateSelectedColumns(columns);
                    },
                  ),
                  
                  SizedBox(width: 1.w),
            ],)
              
            else
            // Advanced search
              Row(mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 1.w),

                  const Expanded(child: AdvancedSearchBar()), // TODO implement real advanced search

                  SizedBox(width: 35.w),

                  FilterColumnsPopup(
                    selectedColumns: state.selectedColumns,
                    onSelectionChanged: (columns) {
                      context.read<HomeCubit>().updateSelectedColumns(columns);
                    },
                  ),
                  
                  SizedBox(width: 1.w),
                ])

            ,const SizedBox(height: 20),

            // Data table takes up remaining area
            Expanded(
              child: BlocProvider(
                create: (_) => DataTableCubit()..initialFetch(),
                child: const DataTableWidget(),
              ),
            )
          ],
        );
      }
    );
  }
}


/// Class for the search / advanced search toggle buttons, which will be used in the dashboard home page
/// Should the other classes be in a different file? Maybe.
class SearchToggle extends StatefulWidget {
  final ValueChanged<int> onSelectionChanged;
  const SearchToggle({super.key, required this.onSelectionChanged});
  
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
          // Enable tapped and disable the other
          for (int i = 0; i < _selected.length; i++) {
            _selected[i] = i == index;
          }
          widget.onSelectionChanged(index);
        });
      },
      borderRadius: const BorderRadius.all(Radius.circular(12)),
      // terminology for style labels is quite confusing
      selectedBorderColor: Colors.black,
      borderColor: Colors.black,
      borderWidth: 1,
      selectedColor: Colors.white,  // text colour when selected
      fillColor: Colors.blueGrey,   // background colour when selected
      color: Colors.grey[850],      // unselected text colour

      constraints: const BoxConstraints(
        // TODO: probably make the toggle a little shorter
        minHeight: 40.0,
        minWidth: 80.0,
      ),
      isSelected: _selected,
      children: [
        SizedBox(width: 80, child: Center(child: Text("Search"))),
        SizedBox(width: 140, child: Center(child: Text("Advanced Search"))),
      ],
    );
  }
}

/// Basic Search Bar
/// Currently just a text input
class BasicSearchBar extends StatelessWidget {
  const BasicSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: const InputDecoration(
        hintText: "Search...",
        border: OutlineInputBorder(),
      ),
    //onSubmitted: context.read<HomeCubit>().add(SearchSubmitted(query));
    );
  }
}

// TODO: Placeholder
// Just changes text from Basic, will replace with Advanced layout later
class AdvancedSearchBar extends StatelessWidget {
  const AdvancedSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
        decoration: const InputDecoration(
          hintText: "Advanced Search...",
          border: OutlineInputBorder(),
        ),
        //onSubmitted: context.read<HomeCubit>().add(SearchSubmitted(query));
      );
  }
}

/// Class for the filter columns popup, which will be used in the dashboard home page
/// Itself contains the button that triggers the popup
class FilterColumnsPopup extends StatelessWidget {
  final Set<String> selectedColumns;
  final ValueChanged<Set<String>> onSelectionChanged;
  
  const FilterColumnsPopup({
    super.key,
    required this.selectedColumns,
    required this.onSelectionChanged
  });

  // Command to open popup window from the outer button
  void _openDialog(BuildContext context) {
    // Pending selections to be saved if user hits 'appply'
    // discarded if user hits 'X' or closes the dialog
    Set<String> pending = Set.from(selectedColumns);

    showGeneralDialog(
        context: context,
        barrierDismissible: true,       // clicking outside closes without applying changes
        barrierLabel: 'Filter Columns', // required when barrierDismissible is true
        barrierColor: Colors.black54,   // darkened background overlay
        transitionDuration: const Duration(milliseconds: 200),
        transitionBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: SizedBox(
            width: 80.w,
            height: 80.h,
            child: Material(
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: StatefulBuilder(
                  builder: (context, setDialogState) {
                    return Column(
                      children: [
                        // Header row with upper left close button
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () => Navigator.of(context).pop(), // close without applying
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Filter Columns',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),

                        const Divider(),

                        // Checkbox list
                        Expanded(
                          child: ListView(
                            // Add more possible columns here:
                            children: ['Title', 'Site', 'Unit', 'Level'].map((e) {
                              return CheckboxListTile(
                                title: Text(e),
                                value: pending.contains(e),
                                onChanged: (isSelected) {
                                  setDialogState(() {
                                    isSelected == true
                                        ? pending.add(e)
                                        : pending.remove(e);
                                  });
                                },
                              );
                            }).toList(),
                          )
                        ),

                        const Divider(),

                        // Apply button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                // sync changes to bloc
                                onSelectionChanged(Set.from(pending));
                                // close window
                                Navigator.of(context).pop();
                              },
                              style: const ButtonStyle(
                                // why I have to write it like this I have no idea
                                backgroundColor: WidgetStatePropertyAll<Color>(AppColors.primaryBlue),
                              ),
                              child: const Text('Apply'),
                            )
                          ]
                        )
                      ]
                    );
                  }
                )
              )
            )
          ),
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      // Attach filter columns menu to filter cols button
      onPressed: () => _openDialog(context),
      child: const Text('Filter Columns'),
    );
  }
}


  /// Data table widget, which will be used to display search results in the dashboard home page
  // TODO: This should be it's own class that manages it's own state
  // Then we can replace the query with a Circular loading wheel while
  // long queries are loading in, show complete table on success and
  // show an error message on DB fail, empty search yield, etc.
  // class DataTable extends StatelessWidget {
  //   const DataTable({super.key});

  //   @override
  //   Widget build(BuildContext context) {
  //     return Padding(
  //       padding: const EdgeInsets.all(5.0),
  //       child: TableView.builder(
  //         columnCount: 4,
  //         rowCount: 10,
  //         columnBuilder: (index) => buildColumnSpan(index, context),
  //         rowBuilder: buildRowSpan,

  //         // TODO: placeholder - need to figure out how to render data from the backend here
  //         cellBuilder:(BuildContext context, TableVicinity vicinity) {
  //           return TableViewCell(
  //             child: Container(
  //               decoration: BoxDecoration(
  //                 // TODO: fix the overlap
  //                 border: Border.all(
  //                   color: Colors.black,
  //                   width: 1,
  //                 )
  //               ),
  //               child: Text('Cell ${vicinity.column} : ${vicinity.row}'),
  //             ),
  //           );
  //         },
  //       ),
  //     );
  //   }

  //   TableSpan buildRowSpan(int index){
  //     // add row level decorations here
  //     return TableSpan(extent: FixedTableSpanExtent(50));
  //   }

  //   TableSpan buildColumnSpan(int index, BuildContext context){
  //     // add col level decorations here
  //     // TODO: replace 4 with dynamic column count based on search results, and adjust the extent accordingly
  //     return TableSpan(extent: FractionalTableSpanExtent(1 / 4),);
  //   }
  // }