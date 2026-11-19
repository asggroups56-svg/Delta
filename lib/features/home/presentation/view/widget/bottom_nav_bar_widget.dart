import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/features/home/data/models/_nav_item_data_widget.dart';
import 'package:my_template/features/home/presentation/view/widget/nav_bar_Items_row_widget.dart';
class BottomNavBarWidget extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavBarWidget({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const List<NavItemData> _items = [
    NavItemData(
      icon: Icons.grid_view_rounded,
      inactiveIcon: Icons.grid_view_outlined,
      labelAr: 'الرئيسية',
      labelEn: 'Home',
    ),
    NavItemData(
      icon: Icons.account_balance_wallet_rounded,
      inactiveIcon: Icons.account_balance_wallet_outlined,
      labelAr: 'الحسابات',
      labelEn: 'Accounts',
    ),
    NavItemData(
      icon: Icons.analytics_rounded,
      inactiveIcon: Icons.analytics_outlined,
      labelAr: 'التقارير',
      labelEn: 'Reports',
    ),
    NavItemData(
      icon: Icons.auto_stories_rounded,
      inactiveIcon: Icons.auto_stories_outlined,
      labelAr: 'المعرفة',
      labelEn: 'Knowledge',
    ),
    NavItemData(
      icon: Icons.person_rounded,
      inactiveIcon: Icons.person_outline_rounded,
      labelAr: 'المنشاه',
      labelEn: 'Profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final accentColor = AppColor.primaryColor(context);
    final inactiveColor = AppColor.darkTextColor(context);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColor.cardColor(context),
        border: Border(
          top: BorderSide(color: AppColor.borderColor(context), width: 1.2),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Container(
        color: AppColor.cardColor(context),
        padding: EdgeInsets.only(
          top: 6.h,
          bottom: bottomPadding > 0 ? bottomPadding : 10.h,
          left: 8.w,
          right: 8.w,
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final itemWidth = constraints.maxWidth / _items.length;
            final activeIndex = isRtl
                ? (_items.length - 1 - currentIndex)
                : currentIndex;
            final leftIndicatorOffset =
                (activeIndex * itemWidth) + (itemWidth - 36.w) / 2;

            return Stack(
              alignment: Alignment.topCenter,
              children: [
                // ── Active Top Indicator Line ────────────────────────────
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                  top: 0,
                  left: leftIndicatorOffset,
                  width: 36.w,
                  height: 3.h,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF1E40AF), // Royal Navy
                          Color(0xFF2563EB), // Delta Blue
                        ],
                      ),
                      borderRadius: BorderRadius.circular(3.r),
                    ),
                  ),
                ),

                // ── Nav Bar Items Row ─────────────────────────────────────
                NavBarItemsRowWidget(items: _items, currentIndex: currentIndex, onTap: onTap, accentColor: accentColor, inactiveColor: inactiveColor),
              ],
            );
          },
        ),
      ),
    );
  }
}

