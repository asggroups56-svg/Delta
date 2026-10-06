import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/routes/routes_name.dart';
import 'package:my_template/core/theme/app_colors.dart';
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
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 16.h,
        childAspectRatio: 0.78,
      ),
      itemBuilder: (context, index) {
        final mod = modules[index];
        final gradient = mod['gradient'] as List<Color>;
        final String? badge = mod['badge'] as String?;

        return FadeInUp(
          delay: Duration(milliseconds: 40 * index),
          duration: const Duration(milliseconds: 350),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                if (mod['id'] == 'accounting') {
                  NavigatorMethods.pushNamed(
                    context,
                    RoutesName.accountingDashboardScreen,
                  );
                } else if (mod['id'] == 'dashboards') {
                  NavigatorMethods.pushNamed(context, RoutesName.reportsScreen);
                } else if (mod['id'] == 'knowledge') {
                  NavigatorMethods.pushNamed(
                    context,
                    RoutesName.knowledgeScreen,
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(mod['title'] as String),
                      backgroundColor: gradient.first,
                      duration: const Duration(seconds: 1),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  );
                }
              },
              borderRadius: BorderRadius.circular(16.r),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 4.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 58.w,
                          height: 58.h,
                          decoration: BoxDecoration(
                            color: AppColor.cardColor(context),
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(
                              color: AppColor.borderColor(context),
                              width: 1.2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFF0F172A,
                                ).withValues(alpha: 0.04),
                                blurRadius: 10.r,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Container(
                              padding: EdgeInsets.all(10.r),
                              decoration: BoxDecoration(
                                color: gradient.first.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: ShaderMask(
                                shaderCallback: (bounds) => LinearGradient(
                                  colors: gradient,
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ).createShader(bounds),
                                child: Icon(
                                  mod['icon'] as IconData,
                                  size: 22.r,
                                  color: AppColor.whiteColor(context),
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (badge != null)
                          Positioned(
                            top: -4.h,
                            right: -4.w,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6.w,
                                vertical: 2.h,
                              ),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFDC2626),
                                    Color(0xFFEA580C),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(10.r),
                                border: Border.all(
                                  color: AppColor.whiteColor(context),
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFFDC2626,
                                    ).withValues(alpha: 0.35),
                                    blurRadius: 4.r,
                                  ),
                                ],
                              ),
                              child: Text(
                                badge,
                                style: TextStyle(
                                  fontSize: 8.5.sp,
                                  fontWeight: FontWeight.w800,
                                  color: AppColor.whiteColor(context),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    Gap(8.h),
                    Flexible(
                      child: Text(
                        mod['title'] as String,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11.5.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColor.titleFormFiledColor(context),
                          letterSpacing: -0.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
