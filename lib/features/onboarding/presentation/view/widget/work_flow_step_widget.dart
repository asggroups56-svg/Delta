
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_text_style.dart';

class WorkFlowStepWidget extends StatelessWidget {
  const WorkFlowStepWidget({super.key,
    required this.icon, required this.titleKey, required this.statusKey, required this.stepColor, required this.isCompleted,});

  final IconData icon;
  final String titleKey;
  final String statusKey;
  final Color stepColor;
  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: stepColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 18.r, color: stepColor),
        ),
        Gap(12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titleKey.tr(),
                style: AppTextStyle.text12SDark(
                 context
                ).copyWith(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                statusKey.tr(),
                style: AppTextStyle.text10SDark(context).copyWith(
                  fontSize: 10.sp,
                  color: stepColor,
                ),
              ),
            ],
          ),
        ),
        Icon(
          Icons.check_circle_rounded,
          size: 18.r,
          color: Colors.green,
        ),
      ],
    );
  }
}