import 'package:flutter/material.dart';
import 'package:search_cms/core/utils/constants.dart';
import 'package:sizer/sizer.dart';


/// Main dashboard home page, showed by defualt after logging in
/// Contains title card, search entry point, and data display widgets
class DashboardHomePage extends StatelessWidget {
  const DashboardHomePage({super.key});

  @override
  Widget build(BuildContext context) {
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
          // Last updated text, should be dynamic in the future
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
      ],
    );
  }
}
