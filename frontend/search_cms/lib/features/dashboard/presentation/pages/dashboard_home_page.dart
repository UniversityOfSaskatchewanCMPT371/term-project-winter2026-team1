import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:search_cms/core/utils/constants.dart';
import 'package:sizer/sizer.dart';
import 'package:two_dimensional_scrollables/two_dimensional_scrollables.dart';

import '../bloc/home_cubit.dart';
import '../bloc/home_state.dart';

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


/// Main dashboard home page, showed by defualt after logging in
/// Contains title card, search entry point, and data display widgets
class DashboardHomePage extends StatelessWidget {
  const DashboardHomePage({super.key});
  // int _selectedSearch = 0; // 0 = Search, 1 = Advanced Search
  // Set<String> _selectedColumns = {}; // Set to hold selected columns for filtering

  @override
  Widget build(BuildContext context) {
   return BlocProvider(
    create: (_) => HomeCubit(),
    child: Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          // Home title card
          Text.rich(
            TextSpan(
              text: 'Home',
              style: TextStyle(
                fontSize: 8.sp,
                color: const Color.fromARGB(255, 0, 0, 0),
                fontWeight: FontWeight.w300,
              )
            ),
          ),
          // Last updated text, should be dynamic in the future (or NUKED lol)
          Text.rich(
            TextSpan(
              text: 'Last Updated: 2024-06-01',
              style: TextStyle(
                fontSize: 6.sp,
                color: AppColors.primaryBlue,
                fontWeight: FontWeight.w300,
              ),
            )
          )
          ]
        ),

        const Divider(
          height: 5,
          thickness: 5,
          indent: 5,
          endIndent: 5,
          color: Color.fromARGB(255, 110, 110, 110),
        ),

        // Search / Advanced Search Toggle
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SearchToggle(onSelectionChanged: (index) {
              setState(() => _selectedSearch = index);
            },),
            FilterColumnsDropdown(onSelectionChanged: (columns) {
              setState(() => _selectedColumns = columns);
            },)
          ]
        ),

        if (_selectedSearch == 0)
          const BasicSearchBar()
        else
          const BasicSearchBar() // TODO: replace with call to const AdvancedSearchPanel(),
      

        ,const SizedBox(height: 20), // Add some spacing between the search bar and the data table


        DataTable()
      ],
    )
   );
  }
}


class BasicSearchBar extends StatelessWidget {
  const BasicSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextField(
          decoration: const InputDecoration(
            hintText: "Search...",
            border: OutlineInputBorder(),
          ),
          //onSubmitted: context.read<DashboardBloc>().add(SearchSubmitted(query));
        ),
      ],
    );
  }
}

/// Class for the filter columns dropdown, which will be used in the dashboard home page
/// Itself contains the button and drop down menu
class FilterColumnsDropdown extends StatefulWidget {
  final ValueChanged<Set<String>> onSelectionChanged;
  const FilterColumnsDropdown({super.key, required this.onSelectionChanged});

  @override
  State<FilterColumnsDropdown> createState() => _FilterColumnsDropdownState();
}
class _FilterColumnsDropdownState extends State<FilterColumnsDropdown> {
  bool isDropdownOpen = false;  // Track dropdown state
  
  Set<String> selected = {};  // Set to hold selected items

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          OutlinedButton(
            child: Text('Filter Columns'),
            onPressed: () => setState(() => isDropdownOpen = !isDropdownOpen),
              // Toggle dropdown visibility
          ),
          if (isDropdownOpen)
            Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  // Close button to hide dropdown, positioned at the top right of the dropdown
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => setState(() => isDropdownOpen = false),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: DropdownButtonFormField(
                    onChanged: (x) {},  // This is required but not used
                    // All possible items in the dropdown go here:
                    items: ['Site', 'Unit', 'Level'].map((e) {
                      return DropdownMenuItem(
                        value: e,
                        child: StatefulBuilder(
                          builder: (context, _setState) {
                            return Row(
                              children: [
                                // Checkbox to select/deselect items
                                Checkbox(
                                  value: selected.contains(e),
                                  onChanged: (isSelected) {
                                    if (isSelected == true) {
                                      selected.add(e);  // Add item if selected
                                    } else {
                                      selected.remove(e);  // Remove item if deselected
                                    }
                                    _setState(() {});  // Update checkbox state
                                    setState(() {});   
                                    widget.onSelectionChanged(Set.from(selected));  // Notify parent of selection change
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