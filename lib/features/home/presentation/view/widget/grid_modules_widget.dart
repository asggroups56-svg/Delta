import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/routes/routes_name.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/navigator_methods.dart';

class GridModulesWidget extends StatelessWidget {
  const GridModulesWidget({super.key, required this.modules});

  final List<Map<String, dynamic>> modules;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: modules.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 10.w,
        mainAxisSpacing: 14.h,
        childAspectRatio: 0.85,
      ),
      itemBuilder: (context, index) {
        final mod = modules[index];
        final gradient = mod['gradient'] as List<Color>;
        return FadeInUp(
          delay: Duration(milliseconds: 60 * index),
          duration: const Duration(milliseconds: 400),
          child: InkWell(
            onTap: () {
              if (mod['id'] == 'accounting') {
                NavigatorMethods.pushNamed(context, RoutesName.accountingDashboardScreen);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(mod['title'] as String),
                  backgroundColor: gradient.first,
                  duration: const Duration(seconds: 1),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                ));
              }
            },
            borderRadius: BorderRadius.circular(16.r),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 54.w, height: 54.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1B2431),
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(color: AppColor.whiteColor(context).withValues(alpha: 0.08)),
                    boxShadow: [BoxShadow(color: gradient.first.withValues(alpha: 0.25), blurRadius: 12, offset: const Offset(0, 4))],
                  ),
                  child: ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(colors: gradient, begin: Alignment.topLeft, end: Alignment.bottomRight).createShader(bounds),
                    child: Icon(mod['icon'] as IconData, size: 26.r, color: AppColor.whiteColor(context)),
                  ),
                ),
                Gap(6.h),
                Text(
                  mod['title'] as String,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.text10SDark(context).copyWith(color: AppColor.whiteColor(context).withValues(alpha: 0.85)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}