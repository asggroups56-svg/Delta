import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/routes/routes_name.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/utils/app_locale_key.dart';
import 'package:my_template/core/utils/navigator_methods.dart';


class LoginSubmitButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const LoginSubmitButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52.h,
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1E40AF), Color(0xFF3B82F6)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1E40AF).withValues(alpha: 0.35),
              blurRadius: 20.r,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14.r),
            ),
          ),
          child: isLoading
              ? SizedBox(
                  width: 22.r,
                  height: 22.r,
                  child:  CircularProgressIndicator(
                    color: AppColor.whiteColor(context),
                    strokeWidth: 2.2,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppLocaleKey.loginBtn.tr(),
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w800,
                        color: AppColor.whiteColor(context),
                        letterSpacing: 0.5,
                      ),
                    ),
                    Gap(8.w),
                    Icon(
                      Directionality.of(context) == TextDirection.RTL
                          ? Icons.arrow_back_rounded
                          : Icons.arrow_forward_rounded,
                      color: AppColor.whiteColor(context),
                      size: 18.r,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class ChangeWorkspaceButton extends StatelessWidget {
  const ChangeWorkspaceButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 46.h,
      child: OutlinedButton.icon(
        onPressed: () => NavigatorMethods.pushReplacementNamed(
          context,
          RoutesName.accountAccessScreen,
        ),
        icon: Icon(
          Icons.grid_view_rounded,
          size: 16.r,
          color: const Color(0xFF1E40AF),
        ),
        label: Text(
          AppLocaleKey.loginChangeWorkspace.tr(),
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 11.5.sp, fontWeight: FontWeight.w700),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF1E40AF),
          backgroundColor: const Color(0xFFF0F7FF),
          side: const BorderSide(color: Color(0xFFBFDBFE)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
      ),
    );
  }
}

class LoginVersionText extends StatelessWidget {
  const LoginVersionText({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        AppLocaleKey.versionPoweredBy.tr(),
        style: TextStyle(
          fontSize: 11.sp,
          color: const Color(0xFF94A3B8),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}