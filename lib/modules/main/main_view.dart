import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/values/app_colors.dart';
import '../../core/widgets/lazy_indexed_stack.dart';
import '../home/home_view.dart';
import '../explore/explore_view.dart';
import '../bookings/bookings_view.dart';
import '../chats/chats_view.dart';
import '../profile/profile_view.dart';
import 'main_controller.dart';

class MainView extends GetView<MainController> {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody:
          true, // Essential for showing curved bottom bar overlay nicely
      body: Obx(
        () => LazyIndexedStack(
          index: controller.currentIndex.value,
          builders: [
            (context) => const HomeView(),
            (context) => const ExploreView(),
            (context) => const BookingsView(),
            (context) => const ChatsView(),
            (context) => const ProfileView(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return Obx(() {
      final int currentIndex = controller.currentIndex.value;

      return SafeArea(
        bottom: true,
        child: Container(
          // Outer margins & constraints to center & fit screen widths beautifully
          margin: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 12.0),
          width:
              390, // Follows Figma design constraint if possible, otherwise responsive
          height: 67,
          decoration: BoxDecoration(
            color: AppColors.navBarBackground,
            borderRadius: BorderRadius.circular(36),
            boxShadow: const [
              BoxShadow(
                color: AppColors.navBarShadow,
                blurRadius: 20.0,
                spreadRadius: 0,
                offset: Offset(0, -4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 10.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildNavItem(
                  index: 0,
                  icon: Icons.home_rounded,
                  label: 'Home',
                  isActive: currentIndex == 0,
                ),
                _buildNavItem(
                  index: 1,
                  icon: Icons.explore_rounded,
                  label: 'Explore',
                  isActive: currentIndex == 1,
                ),
                _buildNavItem(
                  index: 2,
                  icon: Icons.calendar_today_rounded,
                  label: 'Bookings',
                  isActive: currentIndex == 2,
                ),
                _buildNavItem(
                  index: 3,
                  icon: Icons.chat_bubble_outline_rounded,
                  label: 'Chats',
                  isActive: currentIndex == 3,
                ),
                _buildNavItem(
                  index: 4,
                  icon: Icons.person_outline_rounded,
                  label: 'Profile',
                  isActive: currentIndex == 4,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
    required bool isActive,
  }) {
    // Dynamic styling based on the Figma Specs
    final Color itemColor = isActive
        ? AppColors.activeLabel
        : AppColors.inactiveLabel;
    final Color iconColor = isActive
        ? AppColors.activeIcon
        : AppColors.inactiveIcon;
    final Color pillBackground = isActive
        ? AppColors.activePill
        : Colors.transparent;

    // Figma horizontal paddings are 16px (active) and 8px (inactive)
    final double paddingHorizontal = isActive ? 16.0 : 8.0;
    const double paddingVertical = 4.0;

    return GestureDetector(
      onTap: () => controller.changePage(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          horizontal: paddingHorizontal,
          vertical: paddingVertical,
        ),
        decoration: BoxDecoration(
          color: pillBackground,
          borderRadius: BorderRadius.circular(9999), // Fully rounded capsule
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            
            Icon(icon, size: 20, color: iconColor),
            // Show label inside the active pill (or if active, animate it open)
            AnimatedSize(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              child: isActive
                  ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal:8),
                    child: Text(
                      label,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: itemColor,
                        height: 1.5,
                      ),
                    ),
                  )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
