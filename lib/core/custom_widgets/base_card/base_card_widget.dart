import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_decorations.dart';
import 'package:my_template/core/theme/app_padding.dart';
import 'package:my_template/core/theme/app_shadows.dart';


/// Base widget for dashboard-style cards
/// Eliminates duplication across similar card widgets (SalesCard, TaxCard, etc.)
class BaseCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final double? radius;
  final List<BoxShadow>? shadows;
  final Gradient? gradient;
  final void Function()? onTap;
  final BorderRadiusGeometry? borderRadius;

  const BaseCard({
    super.key,
    required this.child,
    this.padding,
    this.backgroundColor,
    this.radius = 16,
    this.shadows,
    this.gradient,
    this.onTap,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding ?? AppPadding.cardPadding,
        decoration: gradient != null
            ? AppDecorations.roundedGradient(
                gradient: gradient!,
                radius: radius ?? 16,
                boxShadow: shadows,
              )
            : AppDecorations.cardDecoration(
                backgroundColor: backgroundColor ?? AppColors.darkCardBackground,
                radius: radius ?? 16,
                boxShadow: shadows ?? AppShadows.card,
              ),
        child: child,
      ),
    );
  }
}

/// Card with header and body sections (common pattern in dashboard)
class StructuredCard extends StatelessWidget {
  final Widget? header;
  final Widget body;
  final Widget? footer;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final double radius;
  final MainAxisAlignment headerAlignment;

  const StructuredCard({
    super.key,
    this.header,
    required this.body,
    this.footer,
    this.padding,
    this.backgroundColor,
    this.radius = 16,
    this.headerAlignment = MainAxisAlignment.spaceBetween,
  });

  @override
  Widget build(BuildContext context) {
    return BaseCard(
      backgroundColor: backgroundColor,
      radius: radius,
      padding: padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (header != null) ...[
            header!,
            SizedBox(height: AppSpacing.md.h),
          ],
          body,
          if (footer != null) ...[
            SizedBox(height: AppSpacing.md.h),
            footer!,
          ],
        ],
      ),
    );
  }
}

/// Section header component used in multiple places
class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? action;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;

  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.action,
    this.titleStyle,
    this.subtitleStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: titleStyle),
              if (subtitle != null) ...[
                SizedBox(height: AppSpacing.xs.h),
                Text(subtitle!, style: subtitleStyle),
              ],
            ],
          ),
        ),
        if (action != null) ...[
          SizedBox(width: AppSpacing.md.w),
          action!,
        ],
      ],
    );
  }
}

/// Metric/stat display component (used in cards for displaying values)
class MetricDisplay extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle? valueStyle;
  final TextStyle? labelStyle;
  final Color? backgroundColor;
  final double radius;

  const MetricDisplay({
    super.key,
    required this.label,
    required this.value,
    this.valueStyle,
    this.labelStyle,
    this.backgroundColor,
    this.radius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppPadding.allMd,
      decoration: AppDecorations.roundedContainer(
        backgroundColor: backgroundColor,
        radius: radius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: labelStyle),
          SizedBox(height: AppSpacing.sm.h),
          Text(value, style: valueStyle),
        ],
      ),
    );
  }
}

/// Status badge component (for displaying status like Active, Pending, etc)
class StatusBadge extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final double radius;
  final EdgeInsets? padding;

  const StatusBadge({
    super.key,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    this.radius = 20,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: AppDecorations.roundedContainer(
        backgroundColor: backgroundColor,
        radius: radius,
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 11.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// Constant colors for card components
class AppColors {
  static const Color darkCardBackground = Color(0xFF131B26);
}

/// Spacing helper for cards
class AppSpacing {
  static final double xs = 4.h;
  static final double sm = 8.h;
  static final double md = 12.h;
  static final double lg = 16.h;
  static final double xl = 20.h;
}
