import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/routes/routes_name.dart';
import 'package:my_template/core/utils/navigator_methods.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  void _navigateToNext() {
    Future.delayed(const Duration(milliseconds: 3200)).then(
      (value) {
        if (mounted) {
          NavigatorMethods.pushReplacementNamed(
            context,
            RoutesName.onboardingScreen,
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1E1B2E), // Deep Odoo Dark Purple
              Color(0xFF0B409C), // Delta Deep Indigo
              Color(0xFF714B67), // Odoo Accent Purple
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
                  color: Colors.white.withOpacity(0.04),
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
                  color: const Color(0xFF017E84).withOpacity(0.12),
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
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF714B67).withOpacity(0.5),
                          blurRadius: 35,
                          spreadRadius: 8,
                        ),
                        BoxShadow(
                          color: Colors.blueAccent.withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'assets/global_icon/logo.png',
                      width: 68.w,
                      height: 68.h,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.widgets_rounded,
                        size: 64.r,
                        color: const Color(0xFF0B409C),
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
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.3),
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
                      color: Colors.white.withOpacity(0.85),
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
                      _buildChipBadge(Icons.shopping_bag_rounded, 'المبيعات'),
                      Gap(8.w),
                      _buildChipBadge(Icons.inventory_rounded, 'المخزون'),
                      Gap(8.w),
                      _buildChipBadge(Icons.calculate_rounded, 'المحاسبة'),
                    ],
                  ),
                ),
              ],
            ),

            // Bottom Progress Indicator & Footer
            Positioned(
              bottom: 45.h,
              child: Column(
                children: [
                  FadeIn(
                    duration: const Duration(milliseconds: 500),
                    delay: const Duration(milliseconds: 900),
                    child: SizedBox(
                      width: 130.w,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.r),
                        child: const LinearProgressIndicator(
                          color: Color(0xFFFF9F1A),
                          backgroundColor: Colors.white24,
                          minHeight: 4,
                        ),
                      ),
                    ),
                  ),
                  Gap(14.h),
                  FadeIn(
                    duration: const Duration(milliseconds: 500),
                    delay: const Duration(milliseconds: 1100),
                    child: Text(
                      'v1.0.0 • Powered by Odoo Engine',
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: Colors.white54,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChipBadge(IconData icon, String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.white.withOpacity(0.18)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.r, color: Colors.white),
          Gap(6.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
