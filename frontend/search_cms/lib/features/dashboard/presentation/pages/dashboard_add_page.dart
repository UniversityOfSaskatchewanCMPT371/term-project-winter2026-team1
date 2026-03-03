import 'package:flutter/material.dart';
import 'package:search_cms/core/utils/constants.dart';

class DashboardAddPage extends StatelessWidget {
  const DashboardAddPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text('Add Placeholder'),
      ),
      body: const Center(
        child: Text('Add Page TODO'),
      ),
    );
  }
}
