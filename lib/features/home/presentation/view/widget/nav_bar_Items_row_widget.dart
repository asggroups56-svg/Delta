
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/features/home/data/models/_nav_item_data_widget.dart';

class NavBarItemsRowWidget extends StatelessWidget {
  const NavBarItemsRowWidget({
    super.key,
    required List<NavItemData> items,
    required this.currentIndex,
    required this.onTap,
    required this.accentColor,
    required this.inactiveColor,
  }) : _items = items;

  final List<NavItemData> _items;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final Color accentColor;
  final Color inactiveColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                splashColor: const Color(
                  0xFF1E40AF,
                ).withValues(alpha: 0.1),
                highlightColor: Colors.transparent,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.h),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Icon with light ambient container when active
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        padding: EdgeInsets.symmetric(
                          horizontal: isSelected ? 12.w : 6.w,
                          vertical: 3.h,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? accentColor.withValues(alpha: 0.1)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        child: AnimatedScale(
                          scale: isSelected ? 1.1 : 1.0,
                          duration: const Duration(
                            milliseconds: 250,
                          ),
                          curve: Curves.easeOutBack,
                          child: Icon(
                            isSelected
                                ? item.icon
                                : item.inactiveIcon,
                            size: isSelected ? 22.r : 20.r,
                            color: isSelected
                                ? accentColor
                                : inactiveColor,
                          ),
                        ),
                      ),
                      Gap(2.h),
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 200),
                        style: TextStyle(
                          fontSize: isSelected ? 10.5.sp : 9.5.sp,
                          fontWeight: isSelected
                              ? FontWeight.w800
                              : FontWeight.w600,
                          color: isSelected
                              ? accentColor
                              : inactiveColor,
                          fontFamily: 'Tajawal',
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
    );
  }
}