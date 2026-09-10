import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/utils/app_locale_key.dart';

class CategoryFiltersWidget extends StatefulWidget {
  const CategoryFiltersWidget({super.key});

  @override
  State<CategoryFiltersWidget> createState() => _CategoryFiltersWidgetState();
}

class _CategoryFiltersWidgetState extends State<CategoryFiltersWidget> {
  String _selectedCategory = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_selectedCategory.isEmpty) {
      _selectedCategory = AppLocaleKey.catAll.tr();
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = [
      {'key': AppLocaleKey.catAll.tr(), 'icon': Icons.tune_rounded},
      {'key': AppLocaleKey.catLegal.tr(), 'icon': Icons.gavel_rounded},
      {'key': AppLocaleKey.catFinancial.tr(), 'icon': Icons.account_balance_wallet_rounded},
      {'key': AppLocaleKey.catContracts.tr(), 'icon': Icons.description_rounded},
      {'key': AppLocaleKey.catAdmin.tr(), 'icon': Icons.admin_panel_settings_rounded},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: categories.map((catItem) {
          final title = catItem['key'] as String;
          final icon = catItem['icon'] as IconData;
          final isSelected = _selectedCategory == title;

          return Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => setState(() => _selectedCategory = title),
                borderRadius: BorderRadius.circular(20.r),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? const LinearGradient(
                            colors: [Color(0xFF00B894), Color(0xFF0984E3)],
                          )
                        : null,
                    color: isSelected ? null : const Color(0xFF141D2B),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: isSelected
                          ? AppColor.emeraldTeal.withValues(alpha: 0.6)
                          : AppColor.whiteColor(context).withValues(alpha: 0.08),
                      width: 1,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColor.emeraldTeal.withValues(alpha: 0.35),
                              blurRadius: 10.r,
                              offset: const Offset(0, 3),
                            ),
                          ]
                        : null,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        icon,
                        size: 13.r,
                        color: isSelected
                            ? Colors.white
                            : AppColor.whiteColor(context).withValues(alpha: 0.5),
                      ),
                      Gap(5.w),
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 11.5.sp,
                          color: isSelected
                              ? Colors.white
                              : AppColor.whiteColor(context).withValues(alpha: 0.7),
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}