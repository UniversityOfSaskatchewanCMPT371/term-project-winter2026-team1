import 'package:flutter/material.dart';
import 'package:search_cms/core/utils/constants.dart';


/// Main dashboard home page, showed by defualt after logging in
/// Contains title card, search entry point, and data display widgets
class DashboardHomePage extends StatelessWidget {
  const DashboardHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: 48.0,
            height: 1.1,
            color: AppColors.mainText,
            letterSpacing: 1.0,
          ),
          children: const [
            TextSpan(
              text: 'Home',
              style: TextStyle(
                color: AppColors.primaryBlue,
                fontWeight: FontWeight.w300,
              ),
            )
          ],
          // TODO: Add more widgets here
        ),
      ),
    );
  }
}
