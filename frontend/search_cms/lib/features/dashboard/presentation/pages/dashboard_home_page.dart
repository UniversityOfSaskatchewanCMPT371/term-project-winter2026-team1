import 'package:flutter/material.dart';
import 'package:search_cms/core/utils/constants.dart';

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
              text: 's',
              style: TextStyle(
                color: AppColors.primaryBlue,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextSpan(
              text: 'EARCH',
              style: TextStyle(fontWeight: FontWeight.w300),
            ),
          ],
        ),
      ),
    );
  }
}
