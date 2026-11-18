import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/utils/app_locale_key.dart';


class BrandingPanel extends StatelessWidget {
  const BrandingPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF1E3A8A), Color(0xFF1E40AF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          const _DecorativeCircles(),
          Positioned.fill(child: CustomPaint(painter: _GridPainter())),
          Padding(
            padding: EdgeInsets.all(48.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const _BrandingLogo(),
                _BrandingContent(),
                _StatsBar(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DecorativeCircles extends StatelessWidget {
  const _DecorativeCircles();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _circle(
          top: -80,
          right: -80,
          size: 280,
          color: AppColor.whiteColor(context).withValues(alpha: 0.04),
        ),
        _circle(
          bottom: -120,
          left: -100,
          size: 360,
          color: AppColor.whiteColor(context).withValues(alpha: 0.03),
        ),
        _circle(
          top: 120,
          left: -60,
          size: 180,
          color: const Color(0xFF3B82F6).withValues(alpha: 0.08),
        ),
      ],
    );
  }

  Widget _circle({
    double? top,
    double? bottom,
    double? left,
    double? right,
    required double size,
    required Color color,
  }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      ),
    );
  }
}

class _BrandingLogo extends StatelessWidget {
  const _BrandingLogo();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(10.r),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF3B82F6), Color(0xFF60A5FA)],
            ),
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF3B82F6).withValues(alpha: 0.4),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Icon(Icons.hub_rounded, color: AppColor.whiteColor(context), size: 22.r),
        ),
        Gap(14.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'DELTA ASG',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
                color: AppColor.whiteColor(context),
              ),
            ),
            Text(
              'Enterprise Cloud ERP',
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF93C5FD),
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _BrandingContent extends StatelessWidget {
  const _BrandingContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StatusPill(),
        Gap(24.h),
        Text(
          AppLocaleKey.brandingTitle.tr(),
          style: TextStyle(
            fontSize: 34.sp,
            fontWeight: FontWeight.w900,
            color: AppColor.whiteColor(context),
            height: 1.15,
            letterSpacing: -0.8,
          ),
        ),
        Gap(18.h),
        Text(
          AppLocaleKey.brandingDescription.tr(),
          style: TextStyle(
            fontSize: 13.sp,
            color: AppColor.whiteColor(context).withValues(alpha: 0.7),
            height: 1.7,
          ),
        ),
        Gap(32.h),
        Wrap(
          spacing: 10.w,
          runSpacing: 10.h,
          children: [
            _FeatureChip(
              icon: Icons.inventory_2_rounded,
              label: AppLocaleKey.brandingInventory.tr(),
            ),
            _FeatureChip(
              icon: Icons.account_balance_wallet_rounded,
              label: AppLocaleKey.brandingFinance.tr(),
            ),
            _FeatureChip(
              icon: Icons.groups_rounded,
              label: AppLocaleKey.brandingHr.tr(),
            ),
            _FeatureChip(
              icon: Icons.local_shipping_rounded,
              label: AppLocaleKey.brandingSupplyChain.tr(),
            ),
            _FeatureChip(
              icon: Icons.insights_rounded,
              label: AppLocaleKey.brandingAnalytics.tr(),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColor.whiteColor(context).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(30.r),
        border: Border.all(color: AppColor.whiteColor(context).withValues(alpha: 0.15)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6.r,
            height: 6.r,
            decoration: const BoxDecoration(
              color: Color(0xFF34D399),
              shape: BoxShape.circle,
            ),
          ),
          Gap(8.w),
          Text(
            AppLocaleKey.brandingStatus.tr(),
            style: TextStyle(
              fontSize: 10.5.sp,
              fontWeight: FontWeight.w700,
              color: AppColor.whiteColor(context).withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _FeatureChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColor.whiteColor(context).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColor.whiteColor(context).withValues(alpha: 0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.r, color: const Color(0xFF93C5FD)),
          Gap(6.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              color: AppColor.whiteColor(context).withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsBar extends StatelessWidget {
  const _StatsBar();

  @override
  Widget build(BuildContext context) {
    final divider = Container(
      width: 1,
      height: 34,
      color: AppColor.whiteColor(context).withValues(alpha: 0.1),
    );

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 18.h),
      decoration: BoxDecoration(
        color: AppColor.whiteColor(context).withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColor.whiteColor(context).withValues(alpha: 0.08)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _Stat(
              value: '99.9%',
              label: AppLocaleKey.brandingUptime.tr(),
            ),
          ),
          divider,
          Expanded(
            child: _Stat(
              value: '256-bit',
              label: AppLocaleKey.brandingEncryption.tr(),
            ),
          ),
          divider,
          Expanded(
            child: _Stat(
              value: '24/7',
              label: AppLocaleKey.brandingSupport.tr(),
            ),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String value;
  final String label;
  const _Stat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          textDirection: ui.TextDirection.ltr,
          style: TextStyle(
            fontSize: 17.sp,
            fontWeight: FontWeight.w900,
            color: AppColor.whiteColor(context),
          ),
        ),
        Gap(3.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 10.sp,
            fontWeight: FontWeight.w600,
            color: AppColor.whiteColor(context).withValues(alpha: 0.55),
          ),
        ),
      ],
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.03)
      ..strokeWidth = 1;

    const spacing = 45.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}