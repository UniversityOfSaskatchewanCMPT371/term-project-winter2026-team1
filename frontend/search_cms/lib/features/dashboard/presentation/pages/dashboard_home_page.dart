import 'package:flutter/material.dart';
import 'package:search_cms/core/utils/constants.dart';
import 'package:sizer/sizer.dart';

/// Class for the search / advanced search toggle buttons, which will be used in the dashboard home page
/// I really expect that this should be in a different file lol
class SearchToggle extends StatefulWidget {
  const SearchToggle({super.key});

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
        });
      },
      borderRadius: const BorderRadius.all(Radius.circular(12)),
      
      selectedBorderColor: Colors.black,
      disabledBorderColor: Colors.black,
      borderWidth: 1,
      selectedColor: Colors.white,  // text colour when selected
      fillColor: Colors.blueGrey,   // background colour when selected
      disabledColor: Colors.grey[850],      // unselected text colour

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

  @override
  Widget build(BuildContext context) {
    // TODO: Does this need to be Scaffold?
    return Column(
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
          ),

          const Divider(
            height: 5,
            thickness: 5,
            indent: 5,
            endIndent: 5,
            color: Color.fromARGB(255, 122, 122, 122),
          ),

          // Search / Advanced Search Toggle
          Row(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SearchToggle()
          ],
          )
          ]
        ),
      ],
    );
  }
}
