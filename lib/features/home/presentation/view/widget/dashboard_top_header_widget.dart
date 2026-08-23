import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_locale_key.dart';
import 'ai_chat_bottom_sheet_widget.dart';

class DashboardTopHeaderWidget extends StatelessWidget {
  final VoidCallback onToggleLanguage;
  final VoidCallback onOpenDrawer;

  const DashboardTopHeaderWidget({
    super.key,
    required this.onToggleLanguage,
    required this.onOpenDrawer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      color: AppColor.darkCardBackground,
      child: Row(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(
                radius: 16.r,
                backgroundColor: AppColor.emeraldTeal,
                child: Text(
                  'A',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColor.whiteColor(context),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 8.w,
                  height: 8.h,
                  decoration: BoxDecoration(
                    color: Colors.greenAccent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColor.darkCardBackground,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Gap(6.w),
          InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(8.r),
            child: Padding(
              padding: EdgeInsets.all(4.r),
              child: Icon(
                Icons.access_time_rounded,
                color: AppColor.whiteColor(context).withValues(alpha: 0.7),
                size: 18.r,
              ),
            ),
          ),
          Stack(
            clipBehavior: Clip.none,
            children: [
              InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(8.r),
                child: Padding(
                  padding: EdgeInsets.all(4.r),
                  child: Icon(
                    Icons.chat_bubble_outline_rounded,
                    color: AppColor.whiteColor(context).withValues(alpha: 0.7),
                    size: 18.r,
                  ),
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 12.w,
                  height: 12.h,
                  decoration: const BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '1',
                      style: AppTextStyle.bodySmall(context).copyWith(
                        fontSize: 7.sp,
                        color: AppColor.whiteColor(context),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Gap(4.w),
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
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColor.purpleAccent, AppColor.emeraldTeal],
                ),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.auto_awesome_rounded,
                    color: AppColor.whiteColor(context),
                    size: 11.r,
                  ),
                  Gap(2.w),
                  Text(
                    'AI',
                    style: AppTextStyle.bodySmall(context).copyWith(
                      fontSize: 9.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColor.whiteColor(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Gap(6.w),
          Expanded(
            child: Text(
              AppLocaleKey.dashboardLabel.tr(),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyle.bodyMedium(context).copyWith(
                fontWeight: FontWeight.bold,
                color: AppColor.whiteColor(context),
              ),
            ),
          ),
          Gap(6.w),
          InkWell(
            onTap: onToggleLanguage,
            borderRadius: BorderRadius.circular(8.r),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: AppColor.whiteColor(context).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                AppLocaleKey.langSwitchShort.tr(),
                style: AppTextStyle.bodySmall(context).copyWith(
                  color: AppColor.whiteColor(context),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Gap(4.w),
          InkWell(
            onTap: onOpenDrawer,
            borderRadius: BorderRadius.circular(8.r),
            child: Padding(
              padding: EdgeInsets.all(4.r),
              child: Icon(
                Icons.menu_rounded,
                color: AppColor.whiteColor(context),
                size: 20.r,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
