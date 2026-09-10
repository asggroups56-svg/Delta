import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_locale_key.dart';

class WelcomeBannerWidget extends StatelessWidget {
  const WelcomeBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FadeInDown(
      duration: const Duration(milliseconds: 500),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFF1E293B),
              Color(0xFF111827),
              Color(0xFF0F172A),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: AppColor.royalIndigo.withValues(alpha: 0.35),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 18.r,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: AppColor.royalIndigo.withValues(alpha: 0.12),
              blurRadius: 28.r,
              spreadRadius: 2,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.r),
          child: Stack(
            children: [
              // Subtle background glow circle
              Positioned(
                top: -30.r,
                right: -30.r,
                child: Container(
                  width: 130.r,
                  height: 130.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColor.royalIndigo.withValues(alpha: 0.22),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -20.r,
                left: -20.r,
                child: Container(
                  width: 100.r,
                  height: 100.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColor.electricCyan.withValues(alpha: 0.18),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.all(16.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Row: Role badge & Status pill
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColor.royalIndigo.withValues(alpha: 0.35),
                                AppColor.electricCyan.withValues(alpha: 0.25),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(
                              color: AppColor.royalIndigo.withValues(alpha: 0.5),
                              width: 0.8,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 6.r,
                                height: 6.r,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF00E676),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Gap(5.w),
                              Text(
                                'Delta Cloud ERP',
                                style: AppTextStyle.caption(context).copyWith(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF38BDF8),
                                  letterSpacing: 0.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                          decoration: BoxDecoration(
                            color: AppColor.whiteColor(context).withValues(alpha: 0.06),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.verified_user_outlined,
                                size: 12.r,
                                color: AppColor.whiteColor(context).withValues(alpha: 0.6),
                              ),
                              Gap(4.w),
                              Text(
                                'Admin',
                                style: AppTextStyle.caption(context).copyWith(
                                  fontSize: 10.sp,
                                  color: AppColor.whiteColor(context).withValues(alpha: 0.7),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    Gap(12.h),

                    // Middle Row: Title & Analytics Icon
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocaleKey.welcomeBack.tr(),
                                style: AppTextStyle.text16SDark(context).copyWith(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w800,
                                  color: AppColor.whiteColor(context),
                                  letterSpacing: -0.3,
                                ),
                              ),
                              Gap(3.h),
                              Text(
                                AppLocaleKey.dashboardTitle.tr(),
                                style: AppTextStyle.text12SDark(context).copyWith(
                                  fontSize: 12.sp,
                                  color: AppColor.whiteColor(context).withValues(alpha: 0.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(12.r),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF4F46E5),
                                Color(0xFF06B6D4),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16.r),
                            boxShadow: [
                              BoxShadow(
                                color: AppColor.royalIndigo.withValues(alpha: 0.4),
                                blurRadius: 12.r,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.auto_graph_rounded,
                            color: Colors.white,
                            size: 24.r,
                          ),
                        ),
                      ],
                    ),

                    Gap(14.h),

                    // Divider
                    Container(
                      height: 1,
                      color: AppColor.whiteColor(context).withValues(alpha: 0.08),
                    ),

                    Gap(12.h),

                    // Bottom Row: Mini KPI metrics
                    Row(
                      children: [
                        _buildKpiItem(
                          context,
                          label: 'Monthly Growth',
                          value: '+24.8%',
                          icon: Icons.trending_up_rounded,
                          color: AppColor.emeraldTeal,
                        ),
                        _buildDivider(context),
                        _buildKpiItem(
                          context,
                          label: 'Active Tasks',
                          value: '18 Open',
                          icon: Icons.task_alt_rounded,
                          color: AppColor.royalIndigo,
                        ),
                        _buildDivider(context),
                        _buildKpiItem(
                          context,
                          label: 'System Status',
                          value: '99.9%',
                          icon: Icons.cloud_done_outlined,
                          color: AppColor.electricCyan,
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
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Container(
      width: 1,
      height: 24.h,
      color: AppColor.whiteColor(context).withValues(alpha: 0.08),
    );
  }

  Widget _buildKpiItem(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 12.r, color: color),
              Gap(3.w),
              Flexible(
                child: Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11.5.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColor.whiteColor(context),
                  ),
                ),
              ),
            ],
          ),
          Gap(2.h),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 9.sp,
              color: AppColor.whiteColor(context).withValues(alpha: 0.45),
            ),
          ),
        ],
      ),
    );
  }
}
