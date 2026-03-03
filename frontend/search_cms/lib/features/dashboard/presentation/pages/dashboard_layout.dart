import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:search_cms/core/utils/constants.dart';

class DashboardLayout extends StatelessWidget {
  final Widget child;

  const DashboardLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          _buildDrawer(context),
          Expanded(child: child),
        ],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      width: 250,
      backgroundColor: AppColors.mainText,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: RichText(
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 24.0,
                  height: 1.1,
                  letterSpacing: 1.0,
                ),
                children: [
                  TextSpan(
                    text: 's',
                    style: TextStyle(
                      color: AppColors.primaryBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text: 'EARCH',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(color: AppColors.mutedText, height: 1),
          _buildDrawerItem(
            context,
            icon: Icons.home,
            label: 'Home',
            path: '/dashboard/home',
          ),
          _buildDrawerItem(
            context,
            icon: Icons.add,
            label: 'Add',
            path: '/dashboard/add',
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String path,
  }) {
    final isSelected = GoRouterState.of(context).uri.path == path;

    return InkWell(
      onTap: () => context.go(path),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        color: isSelected ? AppColors.primaryBlue.withOpacity(0.1) : null,
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primaryBlue : Colors.white70,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.primaryBlue : Colors.white70,
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
