import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/images/app_images.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/features/splash/presentation/view/widget/bottom_progress_indicator_footer_widget.dart';
import 'package:my_template/features/splash/presentation/view/widget/chip_badge_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
   // _navigateToNext();
  }

  // void _navigateToNext() {
  //   Future.delayed(const Duration(milliseconds: 3200)).then(
  //     (value) {
  //       if (mounted) {
  //         NavigatorMethods.pushReplacementNamed(
  //           context,
  //           RoutesName.onboardingScreen,
  //         );
  //       }
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration:  BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColor.DeepColor(context), // Deep Odoo Dark Purple
              AppColor.DeepIndigoColor(context), // Delta Deep Indigo
              AppColor.AccentPurpleColor(context), // Odoo Accent Purple
            ],
            stops: [0.0, 0.6, 1.0],
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Ambient Decorative Glow Elements
            Positioned(
              top: -80.h,
              right: -60.w,
              child: Container(
                width: 260.w,
                height: 260.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColor.whiteColor(context).withValues(alpha: 0.04),
                ),
              ),
            ),
            Positioned(
              bottom: -100.h,
              left: -80.w,
              child: Container(
                width: 320.w,
                height: 320.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF017E84).withValues(alpha: 0.12),
                ),
              ),
            ),

            // Central Animated Content
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App Brand Logo Container with Glow effect
                ZoomIn(
                  duration: const Duration(milliseconds: 900),
                  child: Container(
                    padding: EdgeInsets.all(22.r),
                    decoration: BoxDecoration(
                      color: AppColor.whiteColor(context).withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF714B67).withValues(alpha: 0.5),
                          blurRadius: 35,
                          spreadRadius: 8,
                        ),
                        BoxShadow(
                          color: Colors.blueAccent.withValues(alpha: 0.3),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Image.asset(
                      AppImages.assetsGlobalIconLogoAnimated,
                      width: 68.w,
                      height: 68.h,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.widgets_rounded,
                        size: 64.r,
                        color: AppColor.AccentIndigoColor(context),
                      ),
                    ),
                  ),
                ),
                Gap(28.h),

                // Brand Title
                FadeInUp(
                  duration: const Duration(milliseconds: 600),
                  delay: const Duration(milliseconds: 300),
                  child: Text(
                    'DELTA ERP',
                    style: TextStyle(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.5,
                      color: AppColor.whiteColor(context),
                      shadows: [
                        Shadow(
                           color: AppColor.BackColor(context).withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                  ),
                ),
                Gap(8.h),

                // Subtitle / Slogan
                FadeInUp(
                  duration: const Duration(milliseconds: 600),
                  delay: const Duration(milliseconds: 500),
                  child: Text(
                    'Integrated Business Management System',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColor.whiteColor(context).withValues(alpha: 0.85),
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                Gap(36.h),
                // Floating Modules Badges Preview
                FadeInUp(
                  duration: const Duration(milliseconds: 700),
                  delay: const Duration(milliseconds: 700),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ChipBadgeWidget(icon:  Icons.shopping_bag_rounded, label: 'المبيعات'),
                      Gap(8.w),
                      ChipBadgeWidget(icon: Icons.inventory_rounded, label: 'المخزون'),
                      Gap(8.w),
                      ChipBadgeWidget(icon: Icons.calculate_rounded, label: 'المحاسبة'),
                    ],
                  ),
                ),
              ],
            ),
            BottomProgressIndicatorFooterWidget(),
          ],
        ),
      ),
    );
  }
}

