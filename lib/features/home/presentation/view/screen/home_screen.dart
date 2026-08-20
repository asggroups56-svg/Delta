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
  int _selectedTab = 0;

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

    final List<Map<String, dynamic>> enterpriseApps = [
      {
        'title': 'sales'.tr(),
        'icon': Icons.shopping_bag_rounded,
        'color': const Color(0xFF0D9488),
        'count': '14',
      },
      {
        'title': 'inventory'.tr(),
        'icon': Icons.inventory_2_rounded,
        'color': const Color(0xFF0284C7),
        'count': '280',
      },
      {
        'title': 'accounting'.tr(),
        'icon': Icons.account_balance_rounded,
        'color': const Color(0xFF10B981),
        'count': '3',
      },
      {
        'title': 'crm'.tr(),
        'icon': Icons.people_alt_rounded,
        'color': const Color(0xFF6366F1),
        'count': '42',
      },
      {
        'title': 'invoicing'.tr(),
        'icon': Icons.receipt_long_rounded,
        'color': const Color(0xFF8B5CF6),
        'count': '8',
      },
      {
        'title': 'employees'.tr(),
        'icon': Icons.badge_rounded,
        'color': const Color(0xFFF59E0B),
        'count': '19',
      },
      {
        'title': 'pos'.tr(),
        'icon': Icons.storefront_rounded,
        'color': const Color(0xFFEC4899),
        'count': 'Live',
      },
      {
        'title': 'reports'.tr(),
        'icon': Icons.analytics_rounded,
        'color': const Color(0xFF06B6D4),
        'count': 'New',
      },
      {
        'title': 'purchases'.tr(),
        'icon': Icons.local_shipping_rounded,
        'color': const Color(0xFF84CC16),
        'count': '5',
      },
      {
        'title': 'settings'.tr(),
        'icon': Icons.settings_rounded,
        'color': const Color(0xFF64748B),
        'count': '',
      },
    ];

    return Scaffold(
      backgroundColor: AppColor.scaffoldColor(context),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Premium Header Bar
                    _buildHeader(isArabic),

                    Gap(20.h),

                    // Quick Actions Section
                    _buildQuickActions(),

                    Gap(24.h),

                    // KPI Performance Cards
                    _buildKpiSection(),

                    Gap(24.h),

                    // Enterprise Apps Grid Section
                    _buildAppsGrid(enterpriseApps),

                    Gap(24.h),

                    // Recent Activity Timeline Section
                    _buildRecentActivitySection(),

                    Gap(30.h),
                  ],
                ),
              ),
            ),

            // Bottom Navigation Bar
            _buildBottomNavBar(isArabic),
          ],
        ),
      ),
    );
  }

  // 1. Premium Header Bar Widget
  Widget _buildHeader(bool isArabic) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF042F2C), // Deep Emerald Night
            Color(0xFF0D9488), // Primary Emerald Teal
            Color(0xFF0284C7), // Ocean Blue
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.r),
          bottomRight: Radius.circular(30.r),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0D9488).withValues(alpha: 0.25),
            blurRadius: 25,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(
        children: [
          // User Info & Controls Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(2.r),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2.w),
                    ),
                    child: CircleAvatar(
                      radius: 20.r,
                      backgroundColor: Colors.white24,
                      child: Icon(
                        Icons.person_rounded,
                        color: Colors.white,
                        size: 24.r,
                      ),
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
                      Row(
                        children: [
                          Text(
                            isArabic ? 'محمد خالد' : 'Mohamed Khaled',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Gap(6.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 6.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Text(
                              'PRO',
                              style: TextStyle(
                                fontSize: 9.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),

              // Header Action Controls
              Row(
                children: [
                  // Language Switcher Button
                  InkWell(
                    onTap: _toggleLanguage,
                    borderRadius: BorderRadius.circular(20.r),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                            color: Colors.white.withValues(alpha: 0.25)),
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
                  // Notification Button with Badge
                  Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.r),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.notifications_none_rounded,
                          color: Colors.white,
                          size: 20.r,
                        ),
                      ),
                      Positioned(
                        top: 6.h,
                        right: 6.w,
                        child: Container(
                          width: 8.w,
                          height: 8.h,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFFF9F1A),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Gap(6.w),
                  IconButton(
                    onPressed: _logout,
                    icon: Icon(
                      Icons.logout_rounded,
                      color: Colors.white70,
                      size: 20.r,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Gap(20.h),

          // Search Bar Input
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                )
              ],
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'searchApps'.tr(),
                hintStyle: TextStyle(
                  fontSize: 13.sp,
                  color: Colors.grey[400],
                ),
                icon: Icon(
                  Icons.search_rounded,
                  color: const Color(0xFF0D9488),
                  size: 22.r,
                ),
                suffixIcon: Icon(
                  Icons.tune_rounded,
                  color: Colors.grey[400],
                  size: 20.r,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 2. Quick Actions Section
  Widget _buildQuickActions() {
    final List<Map<String, dynamic>> actions = [
      {'title': 'createInvoice'.tr(), 'icon': Icons.add_chart_rounded, 'color': const Color(0xFF0D9488)},
      {'title': 'addProduct'.tr(), 'icon': Icons.add_box_rounded, 'color': const Color(0xFF0284C7)},
      {'title': 'newCustomer'.tr(), 'icon': Icons.person_add_alt_1_rounded, 'color': const Color(0xFF8B5CF6)},
      {'title': 'viewReport'.tr(), 'icon': Icons.assessment_rounded, 'color': const Color(0xFFF59E0B)},
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'quickActions'.tr(),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: AppColor.titleFormFiledColor(context),
            ),
          ),
          Gap(12.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: actions.map((act) {
                final color = act['color'] as Color;
                return Container(
                  margin: EdgeInsets.only(right: 12.w),
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: color.withValues(alpha: 0.2)),
                    boxShadow: [
                      BoxShadow(
                        color: color.withValues(alpha: 0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(6.r),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(act['icon'] as IconData, size: 16.r, color: color),
                      ),
                      Gap(8.w),
                      Text(
                        act['title'] as String,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColor.titleFormFiledColor(context),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // 3. KPI Performance Cards Section
  Widget _buildKpiSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'kpiOverview'.tr(),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: AppColor.titleFormFiledColor(context),
            ),
          ),
          Gap(12.h),
          Row(
            children: [
              Expanded(
                child: _buildKpiCard(
                  title: 'totalRevenue'.tr(),
                  value: '\$128,400',
                  subtitle: '+14.2% ↗',
                  icon: Icons.trending_up_rounded,
                  color: const Color(0xFF0D9488),
                ),
              ),
              Gap(12.w),
              Expanded(
                child: _buildKpiCard(
                  title: 'activeOrders'.tr(),
                  value: '48 طلب',
                  subtitle: '12 جاري الشحن 🚚',
                  icon: Icons.shopping_bag_outlined,
                  color: const Color(0xFF0284C7),
                ),
              ),
            ],
          ),
        ],
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
          Gap(6.h),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // 4. Enterprise Applications Grid Section
  Widget _buildAppsGrid(List<Map<String, dynamic>> apps) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'appsTitle'.tr(),
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColor.titleFormFiledColor(context),
                ),
              ),
              Text(
                '10 تطبيقات',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: const Color(0xFF0D9488),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Gap(14.h),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: apps.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              crossAxisSpacing: 10.w,
              mainAxisSpacing: 16.h,
              childAspectRatio: 0.72,
            ),
            itemBuilder: (context, index) {
              final app = apps[index];
              return FadeInUp(
                delay: Duration(milliseconds: 60 * index),
                duration: const Duration(milliseconds: 400),
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
                            padding: EdgeInsets.all(12.r),
                            decoration: BoxDecoration(
                              color: (app['color'] as Color)
                                  .withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(16.r),
                              border: Border.all(
                                color: (app['color'] as Color)
                                    .withValues(alpha: 0.3),
                                width: 1.2,
                              ),
                            ),
                            child: Icon(
                              app['icon'] as IconData,
                              size: 24.r,
                              color: app['color'] as Color,
                            ),
                          ),
                          if ((app['count'] as String).isNotEmpty)
                            Positioned(
                              top: -4.h,
                              right: -4.w,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 5.w, vertical: 2.h),
                                decoration: BoxDecoration(
                                  color: app['color'] as Color,
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: Text(
                                  app['count'] as String,
                                  style: TextStyle(
                                    fontSize: 8.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      Gap(6.h),
                      Text(
                        app['title'] as String,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 10.sp,
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
    );
  }

  // 5. Recent Activity Timeline Section
  Widget _buildRecentActivitySection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'recentActivities'.tr(),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: AppColor.titleFormFiledColor(context),
            ),
          ),
          Gap(12.h),
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
                _buildActivityRow(
                  icon: Icons.receipt_long_rounded,
                  title: 'newInvoiceIssued'.tr(),
                  time: 'منذ 10 دقائق',
                  status: 'تم الدفع 🟢',
                  color: const Color(0xFF0D9488),
                ),
                Divider(height: 20.h, color: Colors.grey[200]),
                _buildActivityRow(
                  icon: Icons.inventory_2_rounded,
                  title: 'stockUpdated'.tr(),
                  time: 'منذ ساعة',
                  status: 'مكتمل 🔵',
                  color: const Color(0xFF0284C7),
                ),
                Divider(height: 20.h, color: Colors.grey[200]),
                _buildActivityRow(
                  icon: Icons.person_add_alt_1_rounded,
                  title: 'newLeadAdded'.tr(),
                  time: 'منذ ساعتين',
                  status: 'جديد 🟡',
                  color: const Color(0xFF8B5CF6),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityRow({
    required IconData icon,
    required String title,
    required String time,
    required String status,
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
        Text(
          status,
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  // 6. Bottom Navigation Bar Widget
  Widget _buildBottomNavBar(bool isArabic) {
    final List<Map<String, dynamic>> tabs = [
      {'title': 'homeTab'.tr(), 'icon': Icons.grid_view_rounded},
      {'title': 'appsTab'.tr(), 'icon': Icons.widgets_outlined},
      {'title': 'analyticsTab'.tr(), 'icon': Icons.insights_rounded},
      {'title': 'profileTab'.tr(), 'icon': Icons.person_outline_rounded},
    ];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, -5),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(tabs.length, (index) {
          final isSelected = _selectedTab == index;
          final tab = tabs[index];
          return InkWell(
            onTap: () {
              setState(() {
                _selectedTab = index;
              });
            },
            borderRadius: BorderRadius.circular(16.r),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF0D9488).withValues(alpha: 0.12)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Row(
                children: [
                  Icon(
                    tab['icon'] as IconData,
                    size: 20.r,
                    color: isSelected
                        ? const Color(0xFF0D9488)
                        : Colors.grey[500],
                  ),
                  if (isSelected) ...[
                    Gap(6.w),
                    Text(
                      tab['title'] as String,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF0D9488),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
