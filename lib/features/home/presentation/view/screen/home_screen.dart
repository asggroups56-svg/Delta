import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/routes/routes_name.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/utils/navigator_methods.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  void _toggleLanguage() {
    if (context.locale.languageCode == 'ar') {
      context.setLocale(const Locale('en'));
    } else {
      context.setLocale(const Locale('ar'));
    }
  }

  void _logout() {
    NavigatorMethods.pushReplacementNamed(context, RoutesName.loginScreen);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';

    final List<Map<String, dynamic>> odooApps = [
      {
        'title': 'sales'.tr(),
        'icon': Icons.point_of_sale_rounded,
        'color': const Color(0xFFE056FD),
        'count': '14',
      },
      {
        'title': 'inventory'.tr(),
        'icon': Icons.inventory_2_rounded,
        'color': const Color(0xFFFF9F1A),
        'count': '280',
      },
      {
        'title': 'accounting'.tr(),
        'icon': Icons.account_balance_rounded,
        'color': const Color(0xFF2ED573),
        'count': '3',
      },
      {
        'title': 'crm'.tr(),
        'icon': Icons.people_alt_rounded,
        'color': const Color(0xFF1E90FF),
        'count': '42',
      },
      {
        'title': 'invoicing'.tr(),
        'icon': Icons.receipt_long_rounded,
        'color': const Color(0xFF714B67),
        'count': '8',
      },
      {
        'title': 'employees'.tr(),
        'icon': Icons.badge_rounded,
        'color': const Color(0xFF017E84),
        'count': '19',
      },
      {
        'title': 'pos'.tr(),
        'icon': Icons.storefront_rounded,
        'color': const Color(0xFFFF4757),
        'count': 'Live',
      },
      {
        'title': 'settings'.tr(),
        'icon': Icons.settings_applications_rounded,
        'color': const Color(0xFF57606F),
        'count': '',
      },
    ];

    return Scaffold(
      backgroundColor: AppColor.scaffoldColor(context),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Enterprise Header Bar
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF1E1B2E),
                      Color(0xFF0B409C),
                      Color(0xFF714B67),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(28.r),
                    bottomRight: Radius.circular(28.r),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF714B67).withValues(alpha: 0.25),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 22.r,
                              backgroundColor: Colors.white24,
                              child: Icon(
                                Icons.person_rounded,
                                color: Colors.white,
                                size: 26.r,
                              ),
                            ),
                            Gap(12.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'welcomeUser'.tr(),
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    color: Colors.white70,
                                  ),
                                ),
                                Text(
                                  isArabic ? 'محمد خالد' : 'Mohamed Khaled',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        // Language Switcher & Logout
                        Row(
                          children: [
                            InkWell(
                              onTap: _toggleLanguage,
                              borderRadius: BorderRadius.circular(20.r),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.w, vertical: 6.h),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.language_rounded,
                                      size: 14.r,
                                      color: Colors.white,
                                    ),
                                    Gap(4.w),
                                    Text(
                                      isArabic ? 'EN' : 'عربي',
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Gap(8.w),
                            IconButton(
                              onPressed: _logout,
                              icon: Icon(
                                Icons.logout_rounded,
                                color: Colors.white70,
                                size: 22.r,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Gap(20.h),

                    // Search Bar inside Header
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 14.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'searchApps'.tr(),
                          hintStyle: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.grey[500],
                          ),
                          icon: Icon(
                            Icons.search_rounded,
                            color: const Color(0xFF714B67),
                            size: 22.r,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Gap(24.h),

              // Main Section 1: Odoo Enterprise Applications Grid
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'odooApps'.tr(),
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColor.titleFormFiledColor(context),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFF714B67).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            'Odoo v17.0',
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF714B67),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Gap(16.h),

                    // App Grid View
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: odooApps.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 12.w,
                        mainAxisSpacing: 16.h,
                        childAspectRatio: 0.82,
                      ),
                      itemBuilder: (context, index) {
                        final app = odooApps[index];
                        return FadeInUp(
                          delay: Duration(milliseconds: 100 * index),
                          duration: const Duration(milliseconds: 500),
                          child: InkWell(
                            onTap: () {},
                            borderRadius: BorderRadius.circular(16.r),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(14.r),
                                      decoration: BoxDecoration(
                                        color: (app['color'] as Color)
                                            .withValues(alpha: 0.12),
                                        borderRadius: BorderRadius.circular(18.r),
                                        border: Border.all(
                                          color: (app['color'] as Color)
                                              .withValues(alpha: 0.3),
                                          width: 1.2,
                                        ),
                                      ),
                                      child: Icon(
                                        app['icon'] as IconData,
                                        size: 26.r,
                                        color: app['color'] as Color,
                                      ),
                                    ),
                                    if ((app['count'] as String).isNotEmpty)
                                      Positioned(
                                        top: -4.h,
                                        right: -4.w,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 6.w, vertical: 2.h),
                                          decoration: BoxDecoration(
                                            color: app['color'] as Color,
                                            borderRadius:
                                                BorderRadius.circular(10.r),
                                          ),
                                          child: Text(
                                            app['count'] as String,
                                            style: TextStyle(
                                              fontSize: 9.sp,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                Gap(8.h),
                                Text(
                                  app['title'] as String,
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColor.titleFormFiledColor(context),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Gap(24.h),

              // Main Section 2: Performance Overview (KPI Cards)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'kpiOverview'.tr(),
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColor.titleFormFiledColor(context),
                      ),
                    ),
                    Gap(14.h),
                    Row(
                      children: [
                        Expanded(
                          child: _buildKpiCard(
                            title: 'totalRevenue'.tr(),
                            value: '\$128,400',
                            subtitle: '+14.2% هذا الشهر',
                            icon: Icons.trending_up_rounded,
                            color: const Color(0xFF2ED573),
                          ),
                        ),
                        Gap(12.w),
                        Expanded(
                          child: _buildKpiCard(
                            title: 'activeOrders'.tr(),
                            value: '48 طلب',
                            subtitle: 'نشط الآن',
                            icon: Icons.shopping_cart_outlined,
                            color: const Color(0xFF1E90FF),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Gap(24.h),

              // Main Section 3: Recent Activity Feed
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'recentActivities'.tr(),
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColor.titleFormFiledColor(context),
                      ),
                    ),
                    Gap(14.h),
                    Container(
                      padding: EdgeInsets.all(16.r),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildActivityItem(
                            icon: Icons.receipt_long_rounded,
                            title: 'newInvoiceIssued'.tr(),
                            time: 'منذ 10 دقائق',
                            color: const Color(0xFF714B67),
                          ),
                          Divider(height: 20.h, color: Colors.grey[200]),
                          _buildActivityItem(
                            icon: Icons.inventory_2_rounded,
                            title: 'stockUpdated'.tr(),
                            time: 'منذ ساعة',
                            color: const Color(0xFFFF9F1A),
                          ),
                          Divider(height: 20.h, color: Colors.grey[200]),
                          _buildActivityItem(
                            icon: Icons.person_add_alt_1_rounded,
                            title: 'newLeadAdded'.tr(),
                            time: 'منذ ساعتين',
                            color: const Color(0xFF1E90FF),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Gap(32.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKpiCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          )
        ],
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(icon, size: 18.r, color: color),
              ),
              Icon(Icons.more_horiz_rounded,
                  size: 18.r, color: Colors.grey[400]),
            ],
          ),
          Gap(12.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 11.sp,
              color: Colors.grey[600],
            ),
          ),
          Gap(4.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppColor.titleFormFiledColor(context),
            ),
          ),
          Gap(4.h),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem({
    required IconData icon,
    required String title,
    required String time,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 18.r, color: color),
        ),
        Gap(12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                time,
                style: TextStyle(
                  fontSize: 10.sp,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
        Icon(
          Icons.arrow_forward_ios_rounded,
          size: 14.r,
          color: Colors.grey[400],
        ),
      ],
    );
  }
}
