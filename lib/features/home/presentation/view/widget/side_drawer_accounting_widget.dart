import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/features/home/presentation/view/widget/drawer_tile_widget.dart';

class SideDrawerAccountingWidget extends StatelessWidget {
  const SideDrawerAccountingWidget({super.key, this.onTap, this.openAiChatTap});

  final void Function()? onTap;
  final void Function()? openAiChatTap;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF0D121B),
      child: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20.r),
              color: const Color(0xFF131B26),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10.r),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFF00B894), Color(0xFF0984E3)]),
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    child: Icon(Icons.account_balance_outlined, color: AppColor.whiteColor(context), size: 22.r),
                  ),
                  Gap(12.w),
                  Expanded(
                    child: Text(
                      'accountingAndFinance'.tr(),
                      style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold, color: AppColor.whiteColor(context)),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(16.r),
                children: [
                  DrawerTileWidget(icons: Icons.dashboard_outlined, title: 'dashboardDrawer'.tr(), onTap: () => Navigator.pop(context)),
                  DrawerTileWidget(icons: Icons.shopping_cart_outlined, title: 'salesAndInvoices'.tr()),
                  DrawerTileWidget(icons: Icons.shopping_bag_outlined, title: 'purchasesLabel'.tr()),
                  DrawerTileWidget(icons: Icons.receipt_long_rounded, title: 'taxAndReturns'.tr()),
                  DrawerTileWidget(icons: Icons.account_balance_rounded, title: 'bankAndCash'.tr()),
                  DrawerTileWidget(
                      icons: Icons.auto_awesome_rounded,
                      title: 'aiAssistant'.tr(),
                      onTap: openAiChatTap ?? () {}),
                  Divider(color: AppColor.whiteColor(context).withValues(alpha: 0.1), height: 24.h),
                  DrawerTileWidget(
                      icons: Icons.arrow_back_rounded,
                      title: 'backToHome'.tr(),
                      onTap: () => Navigator.pop(context)),
                  DrawerTileWidget(
                      icons: Icons.logout_rounded,
                      title: 'logoutLabel'.tr(),
                      onTap: onTap ?? () {},
                      color: Colors.redAccent),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}