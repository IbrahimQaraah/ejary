import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../dashboard/presentation/screens/dashboard_view.dart';
import '../../../more/presentation/screens/more_view.dart';
import '../../../properties/presentation/screens/properties_list_view.dart';
import '../controllers/navigation_controller.dart';

class MainNavigationScreen extends StatelessWidget {
  const MainNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final NavigationController controller = Get.find();

    final List<Widget> pages = [
      const DashboardView(),
      const PropertiesListView(),
      _buildSectionPlaceholder(
        title: 'سجل المستأجرين والعقود',
        subtitle: 'سيتم بناء الشاشة التفصيلية في المرحلة 5 وفق تسلسل التنفيذ',
        icon: Icons.people_alt,
      ),
      _buildSectionPlaceholder(
        title: 'سجل المقبوضات والدفعات',
        subtitle: 'سيتم بناء الشاشة التفصيلية في المرحلة 6 وفق تسلسل التنفيذ',
        icon: Icons.account_balance_wallet,
      ),
      const MoreView(),
    ];

    return Obx(
      () => Scaffold(
        body: IndexedStack(
          index: controller.selectedIndex.value,
          children: pages,
        ),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: AppColors.border, width: 1)),
          ),
          child: BottomNavigationBar(
            currentIndex: controller.selectedIndex.value,
            onTap: controller.changeIndex,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: AppColors.textSecondary,
            backgroundColor: AppColors.surface,
            elevation: 0,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard_outlined),
                activeIcon: Icon(Icons.dashboard),
                label: 'الرئيسية',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.apartment_outlined),
                activeIcon: Icon(Icons.apartment),
                label: 'العقارات',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.people_outline),
                activeIcon: Icon(Icons.people),
                label: 'المستأجرون',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_balance_wallet_outlined),
                activeIcon: Icon(Icons.account_balance_wallet),
                label: 'الدفعات',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.grid_view_outlined),
                activeIcon: Icon(Icons.grid_view),
                label: 'المزيد',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionPlaceholder({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 48, color: AppColors.primary),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
