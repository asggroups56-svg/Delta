import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';

class BottomNavBarWidget extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavBarWidget({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const List<_NavItemData> _items = [
    _NavItemData(
      icon: Icons.grid_view_rounded,
      inactiveIcon: Icons.grid_view_outlined,
      labelAr: 'الرئيسية',
      labelEn: 'Home',
    ),
    _NavItemData(
      icon: Icons.account_balance_wallet_rounded,
      inactiveIcon: Icons.account_balance_wallet_outlined,
      labelAr: 'الحسابات',
      labelEn: 'Accounts',
    ),
    _NavItemData(
      icon: Icons.analytics_rounded,
      inactiveIcon: Icons.analytics_outlined,
      labelAr: 'التقارير',
      labelEn: 'Reports',
    ),
    _NavItemData(
      icon: Icons.auto_stories_rounded,
      inactiveIcon: Icons.auto_stories_outlined,
      labelAr: 'المعرفة',
      labelEn: 'Knowledge',
    ),
    _NavItemData(
      icon: Icons.person_rounded,
      inactiveIcon: Icons.person_outline_rounded,
      labelAr: 'الملف',
      labelEn: 'Profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF0B0F19),
        border: Border(
          top: BorderSide(
            color: Colors.white.withValues(alpha: 0.08),
            width: 1.0,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.45),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
          BoxShadow(
            color: AppColor.royalIndigo.withValues(alpha: 0.08),
            blurRadius: 30,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            color: const Color(0xFF0F172A).withValues(alpha: 0.92),
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
                final leftIndicatorOffset = (activeIndex * itemWidth) + (itemWidth - 36.w) / 2;

                return Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    // ── Active Top Glow Line Indicator ────────────────────
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
                              Color(0xFF4F46E5), // Royal Indigo
                              Color(0xFF06B6D4), // Electric Cyan
                            ],
                          ),
                          borderRadius: BorderRadius.circular(3.r),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF06B6D4).withValues(alpha: 0.8),
                              blurRadius: 10,
                              spreadRadius: 1,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // ── Nav Bar Items Row ─────────────────────────────────
                    Padding(
                      padding: EdgeInsets.only(top: 4.h),
                      child: Row(
                        children: List.generate(_items.length, (index) {
                          final item = _items[index];
                          final isSelected = currentIndex == index;
                          final isArabic =
                              Localizations.localeOf(context).languageCode == 'ar';
                          final label = isArabic ? item.labelAr : item.labelEn;

                          return Expanded(
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  HapticFeedback.selectionClick();
                                  onTap(index);
                                },
                                borderRadius: BorderRadius.circular(16.r),
                                splashColor: AppColor.royalIndigo.withValues(alpha: 0.15),
                                highlightColor: Colors.transparent,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 4.h),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Icon with ambient background highlight when active
                                      AnimatedContainer(
                                        duration: const Duration(milliseconds: 250),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: isSelected ? 12.w : 6.w,
                                          vertical: 3.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? AppColor.royalIndigo.withValues(alpha: 0.16)
                                              : Colors.transparent,
                                          borderRadius: BorderRadius.circular(14.r),
                                        ),
                                        child: AnimatedScale(
                                          scale: isSelected ? 1.12 : 1.0,
                                          duration: const Duration(milliseconds: 250),
                                          curve: Curves.easeOutBack,
                                          child: Icon(
                                            isSelected
                                                ? item.icon
                                                : item.inactiveIcon,
                                            size: isSelected ? 22.r : 20.r,
                                            color: isSelected
                                                ? const Color(0xFF38BDF8)
                                                : const Color(0xFF94A3B8)
                                                    .withValues(alpha: 0.7),
                                          ),
                                        ),
                                      ),
                                      Gap(2.h),
                                      AnimatedDefaultTextStyle(
                                        duration: const Duration(milliseconds: 200),
                                        style: TextStyle(
                                          fontSize: isSelected ? 10.sp : 9.5.sp,
                                          fontWeight: isSelected
                                              ? FontWeight.w700
                                              : FontWeight.w500,
                                          color: isSelected
                                              ? Colors.white
                                              : const Color(0xFF94A3B8)
                                                  .withValues(alpha: 0.65),
                                          fontFamily: 'Tajawal',
                                          letterSpacing:
                                              isSelected ? 0.2 : 0.0,
                                        ),
                                        child: Text(
                                          label,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItemData {
  final IconData icon;
  final IconData inactiveIcon;
  final String labelAr;
  final String labelEn;

  const _NavItemData({
    required this.icon,
    required this.inactiveIcon,
    required this.labelAr,
    required this.labelEn,
  });
}
