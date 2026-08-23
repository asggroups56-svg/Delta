import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/features/onboarding/data/model/on_boarding_type.dart';
import 'package:my_template/features/onboarding/presentation/view/widget/allIn_oneIllustration_widget.dart';
import 'package:my_template/features/onboarding/presentation/view/widget/analytics_Illustration_widget.dart';
import 'package:my_template/features/onboarding/presentation/view/widget/automation_Illustration_widget.dart';

class PageSlideWidget extends StatelessWidget {
  const PageSlideWidget({super.key , required this.item});
final OnboardingItemModel item;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Graphic Illustration Card
          Expanded(
            flex: 6,
            child: Center(
              child: _buildGraphicIllustration(item),
            ),
          ),
          Gap(20.h),

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
                      color: AppColor.titleFormFiledColor(context),
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
                      color: AppColor.darkTextColor(context),
                      height: 1.6,
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
        return AutomationIllustrationWidget( color: item.accentColor);
    }
  }
}