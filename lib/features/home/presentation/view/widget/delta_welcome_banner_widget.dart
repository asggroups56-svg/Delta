import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';

class DeltaWelcomeBannerWidget extends StatefulWidget {
  const DeltaWelcomeBannerWidget({super.key});

  @override
  State<DeltaWelcomeBannerWidget> createState() => _DeltaWelcomeBannerWidgetState();
}

class _DeltaWelcomeBannerWidgetState extends State<DeltaWelcomeBannerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';

    return FadeInDown(
      duration: const Duration(milliseconds: 550),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFF1E3A8A), // Deep Royal Navy
              Color(0xFF1D4ED8), // Vibrant Indigo Blue
              Color(0xFF2563EB), // Delta Accent Blue
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(22.r),
          border: Border.all(
            color: const Color(0xFF60A5FA).withValues(alpha: 0.35),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1E3A8A).withValues(alpha: 0.45),
              blurRadius: 20.r,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: const Color(0xFF2563EB).withValues(alpha: 0.25),
              blurRadius: 30.r,
              spreadRadius: 2,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22.r),
          child: Stack(
            children: [
              // Ambient Decorative Glows
              Positioned(
                top: -40.r,
                right: isArabic ? null : -40.r,
                left: isArabic ? -40.r : null,
                child: Container(
                  width: 160.r,
                  height: 160.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFF60A5FA).withValues(alpha: 0.35),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -30.r,
                left: isArabic ? null : -30.r,
                right: isArabic ? -30.r : null,
                child: Container(
                  width: 140.r,
                  height: 140.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFF06B6D4).withValues(alpha: 0.25),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.all(18.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Badge: Dashboard Pill
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                      decoration: BoxDecoration(
                        color: AppColor.whiteColor(context).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: AppColor.whiteColor(context).withValues(alpha: 0.25),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.dashboard_outlined,
                            size: 13.r,
                            color: AppColor.whiteColor(context),
                          ),
                          Gap(5.w),
                          Text(
                            isArabic ? 'لوحة التحكم الرئيسية' : 'Main Dashboard',
                            style: AppTextStyle.caption(context).copyWith(
                              fontSize: 10.5.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColor.whiteColor(context),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Gap(14.h),

                    // Main Row: Headline & Orbital Finance Icon
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isArabic ? 'مرحبًا بك في نظام دلتا ASG' : 'Welcome to Delta ASG System',
                                style: AppTextStyle.titleBold(context, fontSize: 18, color: Colors.white).copyWith(
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -0.3,
                                  height: 1.25,
                                ),
                              ),
                              Gap(6.h),
                              Text(
                                isArabic
                                    ? 'مساحة عمل موحدة لإدارة الحسابات، الحركات اليومية، المنشأة ومراكز التكلفة بكفاءة ووضوح.'
                                    : 'A unified workspace for managing accounts, daily transactions, organization, and cost centers with high efficiency and clarity.',
                                style: AppTextStyle.bodySmall(context).copyWith(
                                  fontSize: 11.sp,
                                  color: AppColor.whiteColor(context).withValues(alpha: 0.85),
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Gap(10.w),
                        _buildOrbitGraphic(context, isArabic),
                      ],
                    ),

                    Gap(16.h),

                    // Bottom Status Chips Row
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: [
                        // Date Chip
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0F172A).withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(
                              color: AppColor.whiteColor(context).withValues(alpha: 0.15),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.calendar_today_rounded,
                                size: 12.r,
                                color: const Color(0xFF93C5FD),
                              ),
                              Gap(5.w),
                              Text(
                                isArabic ? 'الأربعاء 30 سبتمبر 2026' : 'Wednesday, Sep 30, 2026',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColor.whiteColor(context).withValues(alpha: 0.95),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // System Active Chip
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0F172A).withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(
                              color: const Color(0xFF10B981).withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 7.r,
                                height: 7.r,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF00E676),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0xFF00E676),
                                      blurRadius: 6,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                              ),
                              Gap(6.w),
                              Text(
                                isArabic ? 'النظام جاهز للعمل' : 'System Ready',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF6EE7B7),
                                ),
                              ),
                            ],
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
    );
  }

  Widget _buildOrbitGraphic(BuildContext context, bool isArabic) {
    return ScaleTransition(
      scale: _pulseAnimation,
      child: Container(
        width: 78.r,
        height: 78.r,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColor.whiteColor(context).withValues(alpha: 0.1),
          border: Border.all(
            color: AppColor.whiteColor(context).withValues(alpha: 0.25),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF38BDF8).withValues(alpha: 0.2),
              blurRadius: 16.r,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Outer dashed ring effect
            Container(
              width: 66.r,
              height: 66.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF93C5FD).withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
            ),
            // Center Core
            Container(
              width: 44.r,
              height: 44.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFF38BDF8), Color(0xFF2563EB)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1D4ED8).withValues(alpha: 0.5),
                    blurRadius: 8.r,
                  ),
                ],
              ),
              child: Icon(
                Icons.account_balance_rounded,
                color: AppColor.whiteColor(context),
                size: 22.r,
              ),
            ),
            // Satellite Icon 1 (Wallet)
            Positioned(
              top: 3.r,
              right: 6.r,
              child: Container(
                padding: EdgeInsets.all(3.r),
                decoration: const BoxDecoration(
                  color: Color(0xFF1E293B),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.account_balance_wallet_outlined,
                  size: 10.r,
                  color: Color(0xFF60A5FA),
                ),
              ),
            ),
            // Satellite Icon 2 (Analytics)
            Positioned(
              bottom: 3.r,
              left: 6.r,
              child: Container(
                padding: EdgeInsets.all(3.r),
                decoration: const BoxDecoration(
                  color: Color(0xFF1E293B),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.bar_chart_rounded,
                  size: 10.r,
                  color: Color(0xFF34D399),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
