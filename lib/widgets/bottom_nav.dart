import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../config/constants.dart';

/// 底部导航组件
class BottomNavBar extends StatelessWidget {
  final int currentIndex;

  const BottomNavBar({
    super.key,
    this.currentIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.text.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: '🏠',
                label: '首页',
                isSelected: currentIndex == 0,
                onTap: () => context.go('/home'),
              ),
              _NavItem(
                icon: '📖',
                label: '词库',
                isSelected: currentIndex == 1,
                onTap: () => context.go('/vocabulary'),
              ),
              _NavItem(
                icon: '🏆',
                label: '成就',
                isSelected: currentIndex == 2,
                onTap: () => context.go('/achievements'),
              ),
              _NavItem(
                icon: '👤',
                label: '我的',
                isSelected: currentIndex == 3,
                onTap: () => context.go('/profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            icon,
            style: TextStyle(fontSize: 22),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: isSelected ? AppColors.primary : AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

/// 响应式布局检测
class ResponsiveHelper {
  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width > 600;
  }

  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width <= 600;
  }

  static double getLionSize(BuildContext context) {
    return isTablet(context) ? AppSizes.tabletLionSize : AppSizes.mobileLionSize;
  }

  static double getCardWidth(BuildContext context) {
    return isTablet(context) ? AppSizes.tabletCardWidth : AppSizes.mobileCardWidth;
  }

  static double getFontSize(BuildContext context) {
    return isTablet(context) ? AppSizes.tabletFontSize : AppSizes.mobileFontSize;
  }
}
