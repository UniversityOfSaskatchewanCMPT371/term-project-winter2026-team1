import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:search_cms/core/utils/constants.dart';
import 'package:sizer/sizer.dart';
import 'package:two_dimensional_scrollables/two_dimensional_scrollables.dart';

import '../bloc/home_cubit.dart';
import '../bloc/home_state.dart';


/// Main dashboard home page, showed by defualt after logging in
/// Contains title card, search entry point, and data display widgets
class DashboardHomePage extends StatelessWidget {
  const DashboardHomePage({super.key});
  // int _selectedSearch = 0; // 0 = Search, 1 = Advanced Search
  // Set<String> _selectedColumns = {}; // Set to hold selected columns for filtering

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        // Show loading indicator until cubit emits DashboardLoaded
        
        if (state is! HomeLoaded) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.start,
              children: [
                
              SizedBox(width: 1.w), // Add some spacing between the left edge and the title card

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
              // Last updated text, should be dynamic in the future (or NUKED lol)
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

            // Search Bar and Filter Columns Dropdown
            if (state.selectedSearch == 0)
              Row(mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 1.w),

                  const BasicSearchBar(),

                  Spacer(), // Push the filter columns dropdown to the right edge

                  FilterColumnsDropdown(
                    selectedColumns: state.selectedColumns,
                    onSelectionChanged: (columns) {
                      context.read<HomeCubit>().updateSelectedColumns(columns);
                    },
                  ),
                  
                  SizedBox(width: 1.w),
            ],)
              
            else
              Row(mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 1.w),

                  const BasicSearchBar(), // TODO Replace with advanced search widget when implemented

                  Spacer(), // Push the filter columns dropdown to the right edge

                  FilterColumnsDropdown(
                    selectedColumns: state.selectedColumns,
                    onSelectionChanged: (columns) {
                      context.read<HomeCubit>().updateSelectedColumns(columns);
                    },
                  ),
                  
                  SizedBox(width: 1.w),
                ])

            ,const SizedBox(height: 20), // Add some spacing between the search bar and the data table

            // Data table takes up remaining area
            Expanded(child:
              DataTable()
            )
          ],
        );
      }
    );
  }
}


/// Class for the search / advanced search toggle buttons, which will be used in the dashboard home page
/// I really expect that this should be in a different file lol
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
          // The button that is tapped is set to true, and the others to false.
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
      selectedColor: Colors.white,  // text colour when selected
      fillColor: Colors.blueGrey,   // background colour when selected
      color: Colors.grey[850],      // unselected text colour

      constraints: const BoxConstraints(
        minHeight: 40.0,
        minWidth: 80.0,
      ),
      isSelected: _selected,
      children: [Text("Search"), Text("Advanced Search")],
    );
  }
}


class BasicSearchBar extends StatelessWidget {
  const BasicSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: const InputDecoration(
              hintText: "Search...",
              border: OutlineInputBorder(),
            ),
          //onSubmitted: context.read<HomeCubit>().add(SearchSubmitted(query));
          )
        )
      ],
    );
  }
}

/// Class for the filter columns dropdown, which will be used in the dashboard home page
/// Itself contains the button and drop down menu
class FilterColumnsDropdown extends StatefulWidget {
  final Set<String> selectedColumns;
  final ValueChanged<Set<String>> onSelectionChanged;
  
  const FilterColumnsDropdown({
    super.key,
    required this.selectedColumns,
    required this.onSelectionChanged
  });

  @override
  State<FilterColumnsDropdown> createState() => _FilterColumnsDropdownState();
}
class _FilterColumnsDropdownState extends State<FilterColumnsDropdown> {
  bool isDropdownOpen = false;  // Track dropdown state
  
  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          OutlinedButton(
            child: const Text('Filter Columns'),
            onPressed: () => setState(() => isDropdownOpen = !isDropdownOpen),
              // Toggle dropdown visibility
          ),
          if (isDropdownOpen)
            Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  // Close button to hide dropdown at the top right of the dropdown
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => setState(() => isDropdownOpen = false),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: DropdownButtonFormField(
                    onChanged: (x) {},  // required but not used
                    // All possible items in the dropdown go here:
                    items: ['Site', 'Unit', 'Level'].map((e) {
                      return DropdownMenuItem(
                        value: e,
                        child: StatefulBuilder(
                          builder: (context, setState) {
                            return Row(
                              children: [
                                // Checkbox to select/deselect items
                                Checkbox(
                                  value: widget.selectedColumns.contains(e),
                                  onChanged: (isSelected) {
                                    // Update the selected columns set and notify parent widget
                                    final updated = Set<String>.from(widget.selectedColumns);
                                    isSelected == true ? updated.add(e) : updated.remove(e);
                                    widget.onSelectionChanged(updated);
                                  },
                                ),
                                SizedBox(width: 10),  // Add space between checkbox and text
                                Text(e),  // Display item label
                              ],
                            );
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ]
            )
          ],
      );
    }
  }


  /// Data table widget, which will be used to display search results in the dashboard home page
  class DataTable extends StatelessWidget {
    const DataTable({super.key});

    @override
    Widget build(BuildContext context) {
      return Container(
        color: Colors.grey[200],
        child: Center(
          child: TableView.builder(
            columnCount: 4,
            rowCount: 10,
            columnBuilder: buildTableSpan,
            rowBuilder: buildTableSpan,

            // TODO: placeholder - need to figure out how to render data from the backend here
            cellBuilder:(BuildContext context, TableVicinity vicinity) {
              return TableViewCell(
                child: Center(
                  child: Text('Cell ${vicinity.column} : ${vicinity.row}'),
                ),
              );
            },
          ),
        )
      );
    }

    TableSpan buildTableSpan(int index){
      // add row/col level decorations here
      return TableSpan(extent: FixedTableSpanExtent(50));
    }
  }