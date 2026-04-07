import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:search_cms/core/utils/constants.dart';
import 'package:sizer/sizer.dart';


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
    return Container(
      width: 18.w,
      color: AppColors.mainText,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Expanded(child:
            Drawer(
            // width: 10.w,
            backgroundColor: AppColors.mainText,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(24.0),

                  // Logo
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/images/shishalh-sidebar-logo.png',
                        height: 90,
                          ),
                        ),
                    SizedBox(height: 8),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.1,
                          letterSpacing: 1.0,
                        ),
                      children: [
                        TextSpan(
                          text: 's',
                          style: TextStyle(
                            color: AppColors.primaryBlue,
                            fontWeight: FontWeight.w900,
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
                    )
                  ],
                ),
                ),
                // Dashboard navigation items
                // Buttons for home and add page, see routes.dart for widget mounting location
                Divider(color: AppColors.mutedText, height: 1),
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
          )
        )
      ]
      )
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    // Every drawer item is a button containing a label, icon and a path to route to
    required IconData icon,
    required String label,
    required String path,
  }) {
    // Gets the current path from the router and compares it to the path of each DrawerItem
    // Then we can conditionally apply styles in the following section to each item
    // depending on if they are selected or not
    final isSelected = GoRouterState.of(context).uri.path == path;

    return InkWell(
      // send route on button press
      onTap: () => context.go(path),
      child: Container(
        // Styling for the entire drawer
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        color: isSelected ? AppColors.primaryBlue.withValues(alpha: 0.1) : null,
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primaryBlue : Colors.white70,
              size: 20,
            ),
            const SizedBox(width: 12),
            Flexible(
              child: Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.primaryBlue : Colors.white70,
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
