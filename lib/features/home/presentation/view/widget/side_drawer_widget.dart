import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/routes/routes_name.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_locale_key.dart';
import 'package:my_template/core/utils/navigator_methods.dart';
import 'package:my_template/features/home/presentation/view/widget/drawer_tile_widget.dart';

class SideDrawerWidget extends StatelessWidget {
  const SideDrawerWidget({super.key, this.onTap, this.openAiChatTap});

  final void Function()? onTap;
  final void Function()? openAiChatTap;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF0D121B),
      child: SafeArea(
        child: Column(
          children: [
            // ── User Profile & Company Header ──
            Container(
              padding: EdgeInsets.all(18.r),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF162338), Color(0xFF101926)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border(
                  bottom: BorderSide(
                    color: AppColor.whiteColor(context).withValues(alpha: 0.08),
                  ),
                ),
              ),
              child: Row(
                children: [
                  Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.all(2.5.r),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [AppColor.emeraldTeal, AppColor.oceanBlue],
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 22.r,
                          backgroundColor: const Color(0xFF1B2431),
                          child: Text(
                            'A',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 12.r,
                          height: 12.r,
                          decoration: BoxDecoration(
                            color: const Color(0xFF00E676),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFF0D121B),
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Gap(12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Alex Johnson',
                          style: AppTextStyle.bodyMedium(context).copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 15.sp,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Gap(2.h),
                        Text(
                          'Delta Global Enterprise',
                          style: AppTextStyle.caption(context).copyWith(
                            fontSize: 11.sp,
                            color: AppColor.emeraldTeal,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Navigation Menu List ──
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                children: [
                  _buildSectionHeader(context, 'CORE MODULES'),
                  DrawerTileWidget(
                    icons: Icons.dashboard_outlined,
                    title: AppLocaleKey.allApps.tr(),
                    isActive: true,
                    onTap: () => Navigator.pop(context),
                  ),
                  DrawerTileWidget(
                    icons: Icons.account_balance_outlined,
                    title: AppLocaleKey.accountingAndFinance.tr(),
                    color: AppColor.emeraldTeal,
                    onTap: () {
                      Navigator.pop(context);
                      NavigatorMethods.pushNamed(context, RoutesName.accountingDashboardScreen);
                    },
                  ),
                  DrawerTileWidget(
                    icons: Icons.bar_chart_rounded,
                    title: AppLocaleKey.reportsDashboardTitle.tr(),
                    color: AppColor.oceanBlue,
                    onTap: () {
                      Navigator.pop(context);
                      NavigatorMethods.pushNamed(context, RoutesName.reportsScreen);
                    },
                  ),
                  DrawerTileWidget(
                    icons: Icons.folder_special_outlined,
                    title: AppLocaleKey.documentsFiles.tr(),
                    onTap: () => Navigator.pop(context),
                  ),
                  DrawerTileWidget(
                    icons: Icons.collections_bookmark_outlined,
                    title: AppLocaleKey.knowledgeBaseTitle.tr(),
                    color: AppColor.mintTeal,
                    onTap: () {
                      Navigator.pop(context);
                      NavigatorMethods.pushNamed(context, RoutesName.knowledgeScreen);
                    },
                  ),

                  Gap(12.h),
                  _buildSectionHeader(context, 'INTELLIGENCE & TOOLS'),
                  DrawerTileWidget(
                    icons: Icons.auto_awesome_rounded,
                    title: AppLocaleKey.aiAssistant.tr(),
                    color: AppColor.purpleAccent,
                    badge: 'AI 2.0',
                    onTap: () {
                      Navigator.pop(context);
                      openAiChatTap?.call();
                    },
                  ),
                  DrawerTileWidget(
                    icons: Icons.people_outline_rounded,
                    title: AppLocaleKey.clientsLabel.tr(),
                    onTap: () => Navigator.pop(context),
                  ),

                  Gap(12.h),
                  _buildSectionHeader(context, 'PREFERENCES'),
                  DrawerTileWidget(
                    icons: Icons.settings_outlined,
                    title: AppLocaleKey.systemSettings.tr(),
                    onTap: () => Navigator.pop(context),
                  ),

                  Divider(
                    color: AppColor.whiteColor(context).withValues(alpha: 0.08),
                    height: 24.h,
                  ),

                  DrawerTileWidget(
                    icons: Icons.logout_rounded,
                    title: AppLocaleKey.logoutLabel.tr(),
                    onTap: onTap ?? () {},
                    color: const Color(0xFFFF7675),
                  ),
                ],
              ),
            ),

            // ── Footer: Version Info ──
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: AppColor.whiteColor(context).withValues(alpha: 0.06),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Delta ERP v3.2.0',
                    style: TextStyle(
                      fontSize: 10.5.sp,
                      color: AppColor.whiteColor(context).withValues(alpha: 0.4),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: AppColor.emeraldTeal.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Text(
                      'ENTERPRISE',
                      style: TextStyle(
                        fontSize: 9.sp,
                        color: AppColor.emeraldTeal,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 9.5.sp,
          fontWeight: FontWeight.w700,
          color: AppColor.whiteColor(context).withValues(alpha: 0.35),
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}