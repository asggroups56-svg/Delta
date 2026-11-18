import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/utils/app_locale_key.dart';
import 'package:my_template/features/auth/data/model/workspace_module.dart';


class LoginWelcomeHeader extends StatelessWidget {
  final WorkspaceModule? workspace;

  const LoginWelcomeHeader({
    super.key,
    required this.workspace,
  });

  @override
  Widget build(BuildContext context) {
    final ws = workspace;

    return FadeInUp(
      duration: const Duration(milliseconds: 500),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8.w,
            runSpacing: 6.h,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _SecurePortalBadge(),
              if (ws != null)
                _WorkspaceBadge(workspace: ws)
              else
                _DemoBadge(),
            ],
          ),
          Gap(12.h),
          Text(
            AppLocaleKey.loginWelcomeBack.tr(),
            style: TextStyle(
              fontSize: 26.sp,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF0F172A),
              letterSpacing: -0.5,
              height: 1.1,
            ),
          ),
          Gap(6.h),
          Text(
            AppLocaleKey.loginSubtitle.tr(),
            style: TextStyle(
              fontSize: 12.5.sp,
              color: const Color(0xFF64748B),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _SecurePortalBadge extends StatelessWidget {
  const _SecurePortalBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: const Color(0xFFDBEAFE),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        AppLocaleKey.loginSecurePortal.tr(),
        style: TextStyle(
          fontSize: 9.sp,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.5,
          color: const Color(0xFF1E40AF),
        ),
      ),
    );
  }
}

class _WorkspaceBadge extends StatelessWidget {
  final WorkspaceModule workspace;

  const _WorkspaceBadge({required this.workspace});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: workspace.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: workspace.color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(workspace.icon, size: 11.r, color: workspace.color),
          Gap(5.w),
          Text(
            workspace.title(context.locale.languageCode == 'ar'),
            style: TextStyle(
              fontSize: 9.sp,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
              color: workspace.color,
            ),
          ),
        ],
      ),
    );
  }
}

class _DemoBadge extends StatelessWidget {
  const _DemoBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: const Color(0xFFE0F2FE),
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: const Color(0xFF7DD3FC)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.science_outlined,
            size: 11.r,
            color: const Color(0xFF0284C7),
          ),
          Gap(5.w),
          Text(
            AppLocaleKey.loginDemoAccount.tr(),
            style: TextStyle(
              fontSize: 9.sp,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
              color: const Color(0xFF0369A1),
            ),
          ),
        ],
      ),
    );
  }
}