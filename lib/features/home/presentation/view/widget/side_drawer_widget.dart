import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/routes/routes_name.dart';
import 'package:my_template/core/theme/app_colors.dart';
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
                    child: Icon(Icons.grid_view_rounded, color: AppColor.whiteColor(context), size: 22.r),
                  ),
                  Gap(12.w),
                  Expanded(
                    child: Text(
                      'appsAndServices'.tr(),
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
                  DrawerTileWidget(icons: Icons.dashboard_outlined, title: 'allApps'.tr()),
                  DrawerTileWidget(icons: Icons.folder_outlined, title: 'documentsFiles'.tr()),
                  DrawerTileWidget(
                      icons: Icons.account_balance_wallet_outlined,
                      title: 'financeLabel'.tr(),
                      onTap: () {
                        Navigator.pop(context);
                        NavigatorMethods.pushNamed(context, RoutesName.accountingDashboardScreen);
                      }),
                  DrawerTileWidget(icons: Icons.people_outline_rounded, title: 'clientsLabel'.tr()),
                  DrawerTileWidget(
                      icons: Icons.auto_awesome_rounded,
                      title: 'aiAssistant'.tr(),
                      onTap: openAiChatTap ?? () {}),
                  DrawerTileWidget(icons: Icons.settings_outlined, title: 'systemSettings'.tr()),
                  Divider(color: AppColor.whiteColor(context), height: 24.h),
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