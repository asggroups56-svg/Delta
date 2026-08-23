import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';

class CustomErpInputFieldWidget extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final bool isNumber;
  final int maxLines;

  const CustomErpInputFieldWidget({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.isNumber = false,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
            color: AppColor.whiteColor(context).withValues(alpha: 0.7),
          ),
        ),
        Gap(6.h),
        TextField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          maxLines: maxLines,
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: 12.sp,
            color: AppColor.whiteColor(context),
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              fontSize: 11.sp,
              color: AppColor.whiteColor(context).withValues(alpha: 0.3),
            ),
            filled: true,
            fillColor: AppColor.darkSurface,
            contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
