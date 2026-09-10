import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/features/onboarding/data/model/on_boarding_type.dart';
import 'package:my_template/features/onboarding/presentation/view/widget/all_in_one_illustration_widget.dart';
import 'package:my_template/features/onboarding/presentation/view/widget/analytics_illustration_widget.dart';
import 'package:my_template/features/onboarding/presentation/view/widget/automation_illustration_widget.dart';

class PageSlideWidget extends StatelessWidget {
  const PageSlideWidget({super.key, required this.item});

  final OnboardingItemModel item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Graphic Illustration Card with glassmorphic container
          Expanded(
            flex: 6,
            child: Center(
              child: Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: const Color(0xFF141D2B),
                  borderRadius: BorderRadius.circular(24.r),
                  border: Border.all(
                    color: item.accentColor.withValues(alpha: 0.25),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: item.accentColor.withValues(alpha: 0.15),
                      blurRadius: 24.r,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: _buildGraphicIllustration(item),
              ),
            ),
          ),
          Gap(24.h),

          // Title & Description
          Expanded(
            flex: 4,
            child: Column(
              children: [
                FadeInUp(
                  key: ValueKey('title_${item.type}'),
                  duration: const Duration(milliseconds: 400),
                  child: Text(
                    item.titleKey.tr(),
                    textAlign: TextAlign.center,
                    style: AppTextStyle.bodyMedium(context).copyWith(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.3,
                    ),
                  ),
                ),
                Gap(12.h),
                FadeInUp(
                  key: ValueKey('subtitle_${item.type}'),
                  duration: const Duration(milliseconds: 500),
                  child: Text(
                    item.subtitleKey.tr(),
                    textAlign: TextAlign.center,
                    style: AppTextStyle.bodyMedium(context).copyWith(
                      fontSize: 13.sp,
                      color: AppColor.whiteColor(context).withValues(alpha: 0.65),
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGraphicIllustration(OnboardingItemModel item) {
    switch (item.type) {
      case OnboardingType.allInOne:
        return AllinOneillustrationWidget(color: item.accentColor);
      case OnboardingType.analytics:
        return AnalyticsIllustrationWidget(color: item.accentColor);
      case OnboardingType.automation:
        return AutomationIllustrationWidget(color: item.accentColor);
    }
  }
}