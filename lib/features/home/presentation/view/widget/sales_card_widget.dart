import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_locale_key.dart';
import 'new_entry_bottom_sheet_widget.dart';

class SalesCardWidget extends StatefulWidget {
  const SalesCardWidget({super.key});

  @override
  State<SalesCardWidget> createState() => _SalesCardWidgetState();
}

class _SalesCardWidgetState extends State<SalesCardWidget> {
  int _currentPeriodIndex = 0;
  int _selectedBarIndex = 0;

  final List<Map<String, dynamic>> _chartPeriods = [
    {
      'title': 'أغسطس - سبتمبر 2026',
      'bars': [
        {'label': 'مستحق', 'height': 0.85, 'amount': '45,200 ر.س'},
        {'label': '10 - 16 أغسطس', 'height': 0.45, 'amount': '18,400 ر.س'},
        {'label': 'هذا الأسبوع', 'height': 0.30, 'amount': '12,100 ر.س'},
        {'label': '24 - 30 أغسطس', 'height': 0.70, 'amount': '32,500 ر.س'},
        {'label': '31 أغسطس - 6 سبتمبر', 'height': 0.20, 'amount': '8,600 ر.س'},
        {'label': 'غير مستحق', 'height': 0.35, 'amount': '15,000 ر.س'},
      ]
    },
    {
      'title': 'يوليو - أغسطس 2026',
      'bars': [
        {'label': 'مستحق', 'height': 0.60, 'amount': '28,000 ر.س'},
        {'label': '1 - 7 يوليو', 'height': 0.50, 'amount': '21,300 ر.س'},
        {'label': '8 - 14 يوليو', 'height': 0.75, 'amount': '39,000 ر.س'},
        {'label': '15 - 21 يوليو', 'height': 0.40, 'amount': '16,800 ر.س'},
        {'label': '22 - 31 يوليو', 'height': 0.55, 'amount': '24,200 ر.س'},
        {'label': 'غير مستحق', 'height': 0.25, 'amount': '9,500 ر.س'},
      ]
    },
  ];

  @override
  Widget build(BuildContext context) {
    final currentPeriod = _chartPeriods[_currentPeriodIndex];
    final List<Map<String, dynamic>> barData = currentPeriod['bars'] as List<Map<String, dynamic>>;

    return FadeInUp(
      duration: const Duration(milliseconds: 350),
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: AppColor.darkCardBackground,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: AppColor.whiteColor(context).withValues(alpha: 0.08),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      AppLocaleKey.salesCard.tr(),
                      style: AppTextStyle.text16SDark(context).copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColor.emeraldTeal,
                      ),
                    ),
                    Gap(10.w),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: AppColor.darkSurface,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: () => setState(() {
                              _currentPeriodIndex = (_currentPeriodIndex + 1) % _chartPeriods.length;
                            }),
                            child: Icon(
                              Icons.chevron_left_rounded,
                              color: AppColor.emeraldTeal,
                              size: 18.r,
                            ),
                          ),
                          Gap(4.w),
                          Text(
                            currentPeriod['title'] as String,
                            style: AppTextStyle.text10SDark(context).copyWith(
                              fontSize: 9.sp,
                              color: AppColor.whiteColor(context).withValues(alpha: 0.7),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Gap(4.w),
                          InkWell(
                            onTap: () => setState(() {
                              _currentPeriodIndex = (_currentPeriodIndex - 1 + _chartPeriods.length) % _chartPeriods.length;
                            }),
                            child: Icon(
                              Icons.chevron_right_rounded,
                              color: AppColor.emeraldTeal,
                              size: 18.r,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Icon(
                  Icons.more_vert_rounded,
                  color: AppColor.whiteColor(context).withValues(alpha: 0.7),
                  size: 20.r,
                ),
              ],
            ),
            Gap(6.h),
            Text(
              AppLocaleKey.salesDesc.tr(),
              style: AppTextStyle.text10SDark(context).copyWith(
                color: AppColor.whiteColor(context).withValues(alpha: 0.6),
                height: 1.4,
              ),
            ),
            Gap(14.h),
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () => NewEntryBottomSheetWidget.show(context, AppLocaleKey.salesCard.tr()),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [const Color(0xFF8E44AD), AppColor.purpleAccent],
                    ),
                    borderRadius: BorderRadius.circular(10.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.purpleAccent.withValues(alpha: 0.4),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    AppLocaleKey.newBtn.tr(),
                    style: AppTextStyle.text12SDark(context).copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColor.whiteColor(context),
                    ),
                  ),
                ),
              ),
            ),
            Gap(16.h),
            if (_selectedBarIndex < barData.length)
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(bottom: 10.h),
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppColor.purpleAccent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: AppColor.purpleAccent.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${barData[_selectedBarIndex]['label']}:',
                      style: AppTextStyle.text10SDark(context).copyWith(
                        color: AppColor.whiteColor(context).withValues(alpha: 0.7),
                      ),
                    ),
                    Text(
                      barData[_selectedBarIndex]['amount'] as String,
                      style: AppTextStyle.text10SDark(context).copyWith(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColor.mintTeal,
                      ),
                    ),
                  ],
                ),
              ),
            Container(
              height: 140.h,
              padding: EdgeInsets.only(top: 10.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(barData.length, (index) {
                  final data = barData[index];
                  final double heightFactor = data['height'] as double;
                  final String label = data['label'] as String;
                  final bool isSelected = _selectedBarIndex == index;

                  return Flexible(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedBarIndex = index),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: isSelected ? 36.w : 30.w,
                            height: 90.h * heightFactor,
                            decoration: BoxDecoration(
                              gradient: isSelected
                                  ? LinearGradient(
                                      colors: [AppColor.purpleAccent, AppColor.emeraldTeal],
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                    )
                                  : null,
                              color: isSelected ? null : const Color(0xFF2C3E50),
                              borderRadius: BorderRadius.circular(4.r),
                              border: Border.all(
                                color: isSelected
                                    ? AppColor.emeraldTeal
                                    : AppColor.whiteColor(context).withValues(alpha: 0.12),
                                width: isSelected ? 1.5 : 1,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: AppColor.emeraldTeal.withValues(alpha: 0.4),
                                        blurRadius: 8,
                                      ),
                                    ]
                                  : [],
                            ),
                          ),
                          Gap(8.h),
                          SizedBox(
                            height: 32.h,
                            child: Text(
                              label,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyle.text10SDark(context).copyWith(
                                fontSize: 8.sp,
                                color: isSelected
                                    ? AppColor.emeraldTeal
                                    : AppColor.whiteColor(context).withValues(alpha: 0.54),
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
