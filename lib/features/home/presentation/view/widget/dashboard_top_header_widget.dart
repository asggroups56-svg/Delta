import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/utils/app_locale_key.dart';
import 'ai_chat_bottom_sheet_widget.dart';

class DashboardTopHeaderWidget extends StatelessWidget {
  final VoidCallback onToggleLanguage;
  final VoidCallback onOpenDrawer;
  final String? title;
  final String? subtitle;
  final bool showBackIcon;
  final VoidCallback? onBackTap;

  const DashboardTopHeaderWidget({
    super.key,
    required this.onToggleLanguage,
    required this.onOpenDrawer,
    this.title,
    this.subtitle,
    this.showBackIcon = false,
    this.onBackTap,
  });

  @override
  Widget build(BuildContext context) {
    final displayTitle = title ?? AppLocaleKey.dashboardLabel.tr();
    final displaySubtitle = subtitle ?? 'Delta ERP Enterprise';

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColor.cardColor(context),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20.r)),
        border: Border(
          bottom: BorderSide(color: AppColor.borderColor(context), width: 1.2),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: showBackIcon
                ? GestureDetector(
                    onTap: onBackTap ?? () => Navigator.pop(context),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8.r),
                          decoration: BoxDecoration(
                            color: AppColor.cardSurfaceColor(context),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColor.borderColor(context),
                            ),
                          ),
                          child: Icon(
                            context.locale.languageCode == 'ar'
                                ? Icons.arrow_forward_ios_rounded
                                : Icons.arrow_back_ios_new_rounded,
                            color: AppColor.titleFormFiledColor(context),
                            size: 14.r,
                          ),
                        ),
                        Gap(10.w),
                        Expanded(
                          child: _buildTitleColumn(
                            context,
                            displayTitle,
                            displaySubtitle,
                          ),
                        ),
                      ],
                    ),
                  )
                : GestureDetector(
                    onTap: onOpenDrawer,
                    child: Row(
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              padding: EdgeInsets.all(2.r),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFF1E40AF),
                                    Color(0xFF2563EB),
                                  ],
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 17.r,
                                backgroundColor: const Color(0xFF1E40AF),
                                child: Text(
                                  'A',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                    color: AppColor.buttonTextColor(context),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 1.h,
                              right: 1.w,
                              child: Container(
                                width: 9.r,
                                height: 9.r,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF10B981),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColor.buttonTextColor(context),
                                    width: 1.5,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Gap(10.w),
                        Expanded(
                          child: _buildTitleColumn(
                            context,
                            displayTitle,
                            displaySubtitle,
                          ),
                        ),
                      ],
                    ),
                  ),
          ),

          Gap(6.w),

          // ── Actions Section ───────────────────────────────────────────────
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
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1E40AF), Color(0xFF2563EB)],
                    ),
                    borderRadius: BorderRadius.circular(10.r),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF1E40AF).withValues(alpha: 0.25),
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
                        color: AppColor.buttonTextColor(context),
                        size: 13,
                      ),
                      Gap(4.w),
                      Text(
                        'AI',
                        style: TextStyle(
                          fontSize: 10.5.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColor.buttonTextColor(context),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Gap(6.w),

              // 2) Notification Button
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
                      decoration: BoxDecoration(
                        color: AppColor.cardSurfaceColor(context),
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Icon(
                        Icons.notifications_none_rounded,
                        color: AppColor.darkTextColor(context),
                        size: 18,
                      ),
                    ),
                  ),
                  Positioned(
                    top: -2.h,
                    right: -2.w,
                    child: Container(
                      width: 14.r,
                      height: 14.r,
                      decoration: BoxDecoration(
                        color: const Color(0xFFDC2626),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColor.whiteColor(context),
                          width: 1.2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '1',
                          style: TextStyle(
                            fontSize: 8.sp,
                            color: AppColor.whiteColor(context),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Gap(6.w),

              // 3) Language Switcher Chip
              InkWell(
                onTap: onToggleLanguage,
                borderRadius: BorderRadius.circular(10.r),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    color: AppColor.cardSurfaceColor(context),
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: AppColor.borderColor(context)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.language_rounded,
                        color: Color(0xFF2563EB),
                        size: 14,
                      ),
                      Gap(4.w),
                      Text(
                        AppLocaleKey.langSwitchShort.tr(),
                        style: TextStyle(
                          color: AppColor.titleFormFiledColor(context),
                          fontWeight: FontWeight.w800,
                          fontSize: 10.5.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Gap(6.w),

              // 4) Navigation Menu Button
              InkWell(
                onTap: onOpenDrawer,
                borderRadius: BorderRadius.circular(10.r),
                child: Container(
                  padding: EdgeInsets.all(6.r),
                  decoration: BoxDecoration(
                    color: AppColor.cardSurfaceColor(context),
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: AppColor.borderColor(context)),
                  ),
                  child: Icon(
                    Icons.menu_rounded,
                    color: AppColor.titleFormFiledColor(context),
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTitleColumn(
    BuildContext context,
    String displayTitle,
    String displaySubtitle,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          displayTitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 14.5.sp,
            color: AppColor.titleFormFiledColor(context),
            letterSpacing: -0.2,
          ),
        ),
        Row(
          children: [
            Container(
              width: 5.r,
              height: 5.r,
              decoration: const BoxDecoration(
                color: Color(0xFF10B981),
                shape: BoxShape.circle,
              ),
            ),
            Gap(5.w),
            Expanded(
              child: Text(
                displaySubtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColor.darkTextColor(context),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
