import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/features/onboarding/presentation/view/widget/module_badge_widget.dart';

class AllinOneillustrationWidget extends StatelessWidget {
  const AllinOneillustrationWidget({super.key, required this.color});
final Color color;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Background Circle Pulsing
        ZoomIn(
          duration: const Duration(milliseconds: 600),
          child: Container(
            width: 240.w,
            height: 240.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: 0.06),
            ),
          ),
        ),

        // Main Center Hub
        BounceInDown(
          duration: const Duration(milliseconds: 800),
          child: Container(
            width: 100.w,
            height: 100.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color, color.withValues(alpha: 0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.35),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                )
              ],
            ),
            child: Icon(Icons.hub_rounded, size: 48.r, color: AppColor.whiteColor(context)),
          ),
        ),

        // Top Left Module Card (Sales)
        Positioned(
          top: 20.h,
          left: 10.w,
          child: FadeInLeft(
            duration: const Duration(milliseconds: 700),
            child: ModuleBadgeWidget(
              icon: Icons.point_of_sale_rounded,
              titleKey: 'sales',
              badgeColor: const Color(0xFFE056FD),
            ),
          ),
        ),

        // Top Right Module Card (Inventory)
        Positioned(
          top: 30.h,
          right: 10.w,
          child: FadeInRight(
            duration: const Duration(milliseconds: 800),
            child: ModuleBadgeWidget(
              icon: Icons.inventory_2_rounded,
              titleKey: 'inventory',
              badgeColor: const Color(0xFFFF9F1A),
            ),
          ),
        ),

        // Bottom Left Module Card (Accounting)
        Positioned(
          bottom:20.h,
          left: 10.w,
          child: FadeInLeft(
            duration: const Duration(milliseconds: 900),
            child: ModuleBadgeWidget(
              icon: Icons.account_balance_rounded,
              titleKey: 'accounting',
              badgeColor: const Color(0xFF2ED573),
            ),
          ),
        ),

        // Bottom Right Module Card (CRM)
        Positioned(
          bottom: 30.h,
          right: 10.w,
          child: FadeInRight(
            duration: const Duration(milliseconds: 1000),
            child: ModuleBadgeWidget(
              icon: Icons.people_alt_rounded,
              titleKey: 'crm',
              badgeColor: const Color(0xFF1E90FF),
            ),
          ),
        ),
      ],
    );
  }
}