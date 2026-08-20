import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class BottomProgressIndicatorFooterWidget extends StatelessWidget {
  const BottomProgressIndicatorFooterWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
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
    );
  }
}
