import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';

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
    // Initialize with the translated "All" key so it matches after locale changes
    if (_selectedCategory.isEmpty) {
      _selectedCategory = 'catAll'.tr();
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = [
      'catAll'.tr(),
      'catLegal'.tr(),
      'catFinancial'.tr(),
      'catContracts'.tr(),
      'catAdmin'.tr(),
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((cat) {
          final isSelected = _selectedCategory == cat;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = cat),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: EdgeInsets.only(right: 8.w),
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF00B894) : const Color(0xFF1B2431),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: isSelected ? const Color(0xFF00B894) : AppColor.whiteColor(context).withValues(alpha: 0.12)),
                boxShadow: isSelected ? [BoxShadow(color: const Color(0xFF00B894).withValues(alpha: 0.3), blurRadius: 10)] : [],
              ),
              child: Text(cat,
                  style: TextStyle(
                      fontSize: 12.sp,
                      color: isSelected ? AppColor.whiteColor(context) : AppColor.whiteColor(context).withValues(alpha: 0.6),
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
            ),
          );
        }).toList(),
      ),
    );
  }
}