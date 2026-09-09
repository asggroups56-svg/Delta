import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/theme/app_decorations.dart';
import 'package:my_template/core/theme/app_shadows.dart';
import 'package:my_template/core/utils/app_locale_key.dart';
import 'ai_chat_bottom_sheet_widget.dart';

class DashboardTopHeaderWidget extends StatelessWidget {
  final VoidCallback onToggleLanguage;
  final VoidCallback onOpenDrawer;
  final String? title;
  final String? subtitle;

  const DashboardTopHeaderWidget({
    super.key,
    required this.onToggleLanguage,
    required this.onOpenDrawer,
    this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final displayTitle = title ?? AppLocaleKey.dashboardLabel.tr();
    final displaySubtitle = subtitle ?? 'Delta ERP Solutions';

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      decoration: AppDecorations.headerDecoration(
        gradient: AppGradients.dashboardHeader,
        radius: 20,
        boxShadow: AppShadows.header,
        border: Border(
          bottom: BorderSide(
            color: AppColor.whiteColor(context).withValues(alpha: 0.08),
            width: 1.2,
          ),
        ),
      ),
      child: Row(
        children: [
          // ── Left/RTL Section: User Profile & Title (Expanded to prevent overflow) ──
          Expanded(
            child: GestureDetector(
              onTap: onOpenDrawer,
              child: Row(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        padding: EdgeInsets.all(2.r),
                        decoration: AppDecorations.circularGradient(
                          gradient: AppGradients.avatarGradient,
                        ),
                        child: CircleAvatar(
                          radius: 16.r,
                          backgroundColor: AppColor.darkSurface,
                          child: Text(
                            'A',
                            style: AppTextStyle.label(context).copyWith(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColor.whiteColor(context),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 1.h,
                        right: 1.w,
                        child: Container(
                          width: 9.w,
                          height: 9.h,
                          decoration: AppDecorations.circularDecoration(
                            backgroundColor: const Color(0xFF00E676),
                            border: Border.all(
                              color: const Color(0xFF16202E),
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Gap(8.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          displayTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyle.bodyMedium(context).copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 13.sp,
                            color: AppColor.whiteColor(context),
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              width: 4.w,
                              height: 4.h,
                              decoration: const BoxDecoration(
                                color: AppColor.emeraldTeal,
                                shape: BoxShape.circle,
                              ),
                            ),
                            Gap(4.w),
                            Expanded(
                              child: Text(
                                displaySubtitle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyle.bodySmall(context).copyWith(
                                  fontSize: 9.5.sp,
                                  color: AppColor.whiteColor(context).withValues(alpha: 0.55),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          Gap(6.w),

          // ── Right/Actions Section: Glassmorphism Action Bar ──
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 1) AI Assistant Pill Button
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (ctx) => const AiChatBottomSheetWidget(),
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
                  decoration: AppDecorations.roundedGradient(
                    gradient: AppGradients.purpleAccent,
                    radius: 10,
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.purpleAccent.withValues(alpha: 0.3),
                        blurRadius: 6.r,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.auto_awesome_rounded,
                        color: AppColor.whiteColor(context),
                        size: 12.r,
                      ),
                      Gap(3.w),
                      Text(
                        'AI',
                        style: AppTextStyle.label(context).copyWith(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColor.whiteColor(context),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Gap(5.w),

              // 2) Notification/Chat Badge Button
              Stack(
                clipBehavior: Clip.none,
                children: [
                  InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (ctx) => const AiChatBottomSheetWidget(),
                      );
                    },
                    borderRadius: BorderRadius.circular(10.r),
                    child: Container(
                      padding: EdgeInsets.all(6.r),
                      decoration: AppDecorations.roundedContainer(
                        backgroundColor: const Color(0xFF1F2B3E),
                        radius: 10,
                        border: Border.all(
                          color: AppColor.whiteColor(context).withValues(alpha: 0.08),
                        ),
                      ),
                      child: Icon(
                        Icons.notifications_none_rounded,
                        color: AppColor.whiteColor(context).withValues(alpha: 0.85),
                        size: 16.r,
                      ),
                    ),
                  ),
                  Positioned(
                    top: -2.h,
                    right: -2.w,
                    child: Container(
                      width: 13.w,
                      height: 13.h,
                      decoration: AppDecorations.circularDecoration(
                        backgroundColor: const Color(0xFFFF5252),
                        border: Border.all(
                          color: const Color(0xFF16202E),
                          width: 1.2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '1',
                          style: AppTextStyle.caption(context).copyWith(
                            fontSize: 7.5.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Gap(5.w),

              // 3) Language Switcher Chip
              InkWell(
                onTap: onToggleLanguage,
                borderRadius: BorderRadius.circular(10.r),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 5.h),
                  decoration: AppDecorations.roundedContainer(
                    backgroundColor: const Color(0xFF1F2B3E),
                    radius: 10,
                    border: Border.all(
                      color: AppColor.whiteColor(context).withValues(alpha: 0.08),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.language_rounded,
                        color: AppColor.emeraldTeal,
                        size: 13.r,
                      ),
                      Gap(3.w),
                      Text(
                        AppLocaleKey.langSwitchShort.tr(),
                        style: AppTextStyle.bodySmall(context).copyWith(
                          color: AppColor.whiteColor(context),
                          fontWeight: FontWeight.bold,
                          fontSize: 10.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Gap(5.w),

              // 4) Navigation Menu Button
              InkWell(
                onTap: onOpenDrawer,
                borderRadius: BorderRadius.circular(10.r),
                child: Container(
                  padding: EdgeInsets.all(6.r),
                  decoration: AppDecorations.roundedContainer(
                    backgroundColor: const Color(0xFF1F2B3E),
                    radius: 10,
                    border: Border.all(
                      color: AppColor.whiteColor(context).withValues(alpha: 0.08),
                    ),
                  ),
                  child: Icon(
                    Icons.menu_rounded,
                    color: AppColor.whiteColor(context),
                    size: 16.r,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
