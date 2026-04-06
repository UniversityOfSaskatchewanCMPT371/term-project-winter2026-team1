import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:search_cms/core/utils/constants.dart';
import 'package:sizer/sizer.dart';

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
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        // Show loading indicator until cubit emits DashboardLoaded
        // Will never happen but exists if we ever want to async load the page
        if (state is! HomeLoaded) {
          return const Center(child: CircularProgressIndicator());
        }

        return 
        BlocProvider(
          create: (_) => DataTableCubit()..initialFetch(state.tableRowEntities),
          child: Column(
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

                  /* this is the fiter columns popup which will stay commented out since not functional
                     but left in just in case the stakeholders would like to implement it in the future
                  FilterColumnsPopup(
                    selectedColumns: state.selectedColumns,
                    onSelectionChanged: (columns) {
                      // Update UI State
                      context.read<HomeCubit>().updateSelectedColumns(columns);
                
                      // Trigger data table refresh
                      //BlocProvider.of<DataTableCubit>(context).updateColumns(columns);
                    },
                  ), */
                  
                  SizedBox(width: 1.w),
            ],)
              
            else
            // Advanced search
              Row(mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 1.w),

                    const Expanded(child: AdvancedSearchBar()), // TODO implement real advanced search

                    SizedBox(width: 35.w),

                  /* this is the fiter columns popup which will stay commented out since not functional
                     but left in just in case the stakeholders would like to implement it in the future
                    FilterColumnsPopup(
                    selectedColumns: state.selectedColumns,
                    onSelectionChanged: (columns) {
                      // Update UI State
                      context.read<HomeCubit>().updateSelectedColumns(columns);
                
                      // Trigger data table refresh
                      //BlocProvider.of<DataTableCubit>(context).updateColumns(columns);
                    },
                  ), */ 
                  
                  SizedBox(width: 1.w),
                ])

              ,const SizedBox(height: 20),

              // Data table takes up remaining area
              Expanded(
                child: Padding(
                  padding: EdgeInsetsGeometry.all(2.5.h),
                  child: const DataTableWidget(),
                  // BlocProvider(
                  //     create: (_) => DataTableCubit()..initialFetch(state.tableRowEntities),
                  //     child: const DataTableWidget(),
                  //   ),
                  ) 
              )
            ],
          )
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
  // Internal state to tell widget which side of toggle is selected
  // This is a common use pattern for the ToggleButtons widget
  final List<bool> _selected = [true, false];

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      direction: Axis.horizontal,
      onPressed: (int index) {
        setState(() {
          // Compare each of _selected with the index that was pressed
          // This effectively enables the side that was pressed and disables the other
          // ie. [true, false] -> [false, true] and vice-versa
          for (int i = 0; i < _selected.length; i++) {
            _selected[i] = i == index;
          }
          // pass selection up to parent for search bar rendering
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
        // more space for larger text width
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

    String searchBarContents = "";

    return Row(
      children: [
        Expanded(
          child: TextField(
            key: Key("basicSearchBar"),
            decoration: const InputDecoration(
              hintText: "Search...",
              border: OutlineInputBorder(),
            ),
            onChanged : (value){searchBarContents = value;},
            onSubmitted: (value){
              context.read<DataTableCubit>().basicFetch(value);
            },

          ),
        ),

        // const SizedBox(width: 8),

        // search button
        ElevatedButton(
          key: Key("searchButton"),
          onPressed: (){ // perform basic search
            context.read<DataTableCubit>().basicFetch(searchBarContents);          
            }, 

          style: ElevatedButton.styleFrom(
            minimumSize: const Size(90, 40),
            backgroundColor: const Color(0xFF1f40b0),
            foregroundColor: Colors.white,

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            
          ),

          child: Text(
            "Search",
            style: TextStyle(
              fontSize: 25,
            )
          ),
        ),

      ],
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
        //onSubmitted: context.read<DataTableCubit>().add(advancedFetch(query));
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
