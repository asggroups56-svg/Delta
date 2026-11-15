import 'dart:math' as math;

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
  const PageSlideWidget({
    super.key,
    required this.item,
    this.isCompact = false,
  });

  final OnboardingItemModel item;

  /// Side-by-side layout used on short, wide screens (phone landscape).
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    if (isCompact) {
      return Padding(
        padding: EdgeInsets.fromLTRB(24.w, 4.h, 24.w, 0),
        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTitle(context, fontSize: 19.sp),
                  Gap(8.h),
                  _buildSubtitle(context, fontSize: 11.5.sp),
                ],
              ),
            ),
            Gap(24.w),
            Expanded(
              flex: 5,
              child: _buildPreviewPanel(context, scaleDown: true),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 10.h, 24.w, 0),
      child: Column(
        children: [
          // Illustration inside a premium "product preview" panel.
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Keep the panel close to square instead of letting it stretch
                // into a tall strip on phones and tablets.
                final panelHeight = math.min(
                  constraints.maxHeight,
                  constraints.maxWidth * 1.15,
                );

                return Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    width: double.infinity,
                    height: panelHeight,
                    child: _buildPreviewPanel(context),
                  ),
                );
              },
            ),
          ),
          Gap(26.h),
          _buildTitle(context, fontSize: 23.sp),
          Gap(10.h),
          _buildSubtitle(context, fontSize: 13.sp),
          Gap(20.h),
        ],
      ),
    );
  }

  Widget _buildTitle(BuildContext context, {required double fontSize}) {
    return FadeInUp(
      key: ValueKey('title_${item.type}'),
      duration: const Duration(milliseconds: 400),
      child: Text(
        item.titleKey.tr(),
        textAlign: TextAlign.center,
        style: AppTextStyle.bodyMedium(context).copyWith(
          fontSize: fontSize,
          fontWeight: FontWeight.w900,
          height: 1.3,
          letterSpacing: -0.2,
          color: AppColor.titleFormFiledColor(context),
        ),
      ),
    );
  }

  Widget _buildSubtitle(BuildContext context, {required double fontSize}) {
    return FadeInUp(
      key: ValueKey('subtitle_${item.type}'),
      duration: const Duration(milliseconds: 500),
      child: Text(
        item.subtitleKey.tr(),
        textAlign: TextAlign.center,
        style: AppTextStyle.bodyMedium(context).copyWith(
          fontSize: fontSize,
          fontWeight: FontWeight.w400,
          color: AppColor.darkTextColor(context),
          height: 1.6,
        ),
      ),
    );
  }

  Widget _buildPreviewPanel(BuildContext context, {bool scaleDown = false}) {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF0B1220),
            Color.lerp(const Color(0xFF0F1A2E), item.accentColor, 0.24) ??
                const Color(0xFF0F1A2E),
          ],
        ),
        borderRadius: BorderRadius.circular(28.r),
        border: Border.all(color: item.accentColor.withValues(alpha: 0.24)),
        boxShadow: [
          BoxShadow(
            color: item.accentColor.withValues(alpha: 0.18),
            blurRadius: 30,
            offset: const Offset(0, 14),
          ),
          BoxShadow(
            color: const Color(0xFF0B1220).withValues(alpha: 0.12),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative rings
          Positioned(
            top: -70.r,
            right: -60.r,
            child: Container(
              width: 190.r,
              height: 190.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: item.accentColor.withValues(alpha: 0.16),
                  width: 1.5,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -80.r,
            left: -50.r,
            child: Container(
              width: 170.r,
              height: 170.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: item.accentColor.withValues(alpha: 0.07),
              ),
            ),
          ),
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.all(14.r),
              child: Center(
                child: scaleDown
                    ? FittedBox(
                        fit: BoxFit.scaleDown,
                        child: _buildGraphicIllustration(item),
                      )
                    : _buildGraphicIllustration(item),
              ),
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
