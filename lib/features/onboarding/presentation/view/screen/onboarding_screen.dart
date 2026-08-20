import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/routes/routes_name.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/utils/navigator_methods.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<OnboardingItemModel> _items = [
    OnboardingItemModel(
      title: 'إدارة شاملة لجميع أعمالك',
      subtitle:
          'منصة واحدة متكاملة تجمع بين المبيعات، إدارة المخزون، الحسابات، وتتبع العملاء بكل سهولة وسلاسة.',
      accentColor: const Color(0xFF714B67), // Odoo Purple Accent
      type: OnboardingType.allInOne,
    ),
    OnboardingItemModel(
      title: 'تحليلات وتقارير لحظية',
      subtitle:
          'متابعة أداء منظومتك ورسوماتك البيانية أولاً بأول لاتخاذ القرارات الاستراتيجية في الوقت المناسب.',
      accentColor: const Color(0xFF017E84), // Odoo Teal Accent
      type: OnboardingType.analytics,
    ),
    OnboardingItemModel(
      title: 'أتمتة وسرعة في الإنجاز',
      subtitle:
          'وفّر وقتك وجهدك عبر أتمتة دورات العمل اليومية والمهام المكررة لأداء أكثر كفاءة وإنتاجية.',
      accentColor: const Color(0xFF0B409C), // Deep Indigo Accent
      type: OnboardingType.automation,
    ),
  ];

  void _onNext() {
    if (_currentIndex < _items.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToLogin();
    }
  }

  void _navigateToLogin() {
    NavigatorMethods.pushReplacementNamed(context, RoutesName.loginScreen);
  }

  @override
  Widget build(BuildContext context) {
    final currentItem = _items[_currentIndex];

    return Scaffold(
      backgroundColor: AppColor.scaffoldColor(context),
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar with Skip Button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 10.w,
                        height: 10.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: currentItem.accentColor,
                        ),
                      ),
                      Gap(8.w),
                      Text(
                        'DELTA ERP',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                          color: AppColor.titleFormFiledColor(context),
                        ),
                      ),
                    ],
                  ),
                  if (_currentIndex < _items.length - 1)
                    TextButton(
                      onPressed: _navigateToLogin,
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 6.h),
                        backgroundColor:
                            currentItem.accentColor.withOpacity(0.08),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                      ),
                      child: Text(
                        'تخطي',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: currentItem.accentColor,
                        ),
                      ),
                    )
                  else
                    SizedBox(height: 32.h),
                ],
              ),
            ),

            // PageView Slider
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _items.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return _buildPageSlide(_items[index]);
                },
              ),
            ),

            // Bottom Navigation Controls
            Padding(
              padding: EdgeInsets.all(24.r),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Animated Page Indicators
                  Row(
                    children: List.generate(
                      _items.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: EdgeInsets.only(right: 6.w),
                        height: 8.h,
                        width: _currentIndex == index ? 28.w : 8.w,
                        decoration: BoxDecoration(
                          color: _currentIndex == index
                              ? currentItem.accentColor
                              : currentItem.accentColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                    ),
                  ),

                  // Next / Get Started Button
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    child: ElevatedButton(
                      onPressed: _onNext,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal:
                              _currentIndex == _items.length - 1 ? 28.w : 22.w,
                          vertical: 14.h,
                        ),
                        backgroundColor: currentItem.accentColor,
                        elevation: 4,
                        shadowColor: currentItem.accentColor.withOpacity(0.4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _currentIndex == _items.length - 1
                                ? 'ابدأ الآن'
                                : 'التالي',
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Gap(8.w),
                          Icon(
                            _currentIndex == _items.length - 1
                                ? Icons.rocket_launch_rounded
                                : Icons.arrow_forward_rounded,
                            size: 18.r,
                            color: Colors.white,
                          ),
                        ],
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

  Widget _buildPageSlide(OnboardingItemModel item) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Graphic Illustration Card
          Expanded(
            flex: 6,
            child: Center(
              child: _buildGraphicIllustration(item),
            ),
          ),
          Gap(20.h),

          // Title & Description
          Expanded(
            flex: 4,
            child: Column(
              children: [
                FadeInUp(
                  key: ValueKey('title_${item.type}'),
                  duration: const Duration(milliseconds: 400),
                  child: Text(
                    item.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColor.titleFormFiledColor(context),
                      height: 1.3,
                    ),
                  ),
                ),
                Gap(12.h),
                FadeInUp(
                  key: ValueKey('subtitle_${item.type}'),
                  duration: const Duration(milliseconds: 500),
                  child: Text(
                    item.subtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: AppColor.darkTextColor(context),
                      height: 1.6,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGraphicIllustration(OnboardingItemModel item) {
    switch (item.type) {
      case OnboardingType.allInOne:
        return _buildAllInOneIllustration(item.accentColor);
      case OnboardingType.analytics:
        return _buildAnalyticsIllustration(item.accentColor);
      case OnboardingType.automation:
        return _buildAutomationIllustration(item.accentColor);
    }
  }

  // Slide 1 Illustration: Floating Odoo Modules Grid
  Widget _buildAllInOneIllustration(Color color) {
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
              color: color.withOpacity(0.06),
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
                colors: [color, color.withOpacity(0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.35),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                )
              ],
            ),
            child: Icon(Icons.hub_rounded, size: 48.r, color: Colors.white),
          ),
        ),

        // Top Left Module Card (Sales)
        Positioned(
          top: 20.h,
          left: 10.w,
          child: FadeInLeft(
            duration: const Duration(milliseconds: 700),
            child: _buildModuleBadge(
              icon: Icons.point_of_sale_rounded,
              title: 'المبيعات',
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
            child: _buildModuleBadge(
              icon: Icons.inventory_2_rounded,
              title: 'المخزون',
              badgeColor: const Color(0xFFFF9F1A),
            ),
          ),
        ),

        // Bottom Left Module Card (Accounting)
        Positioned(
          bottom: 30.h,
          left: 15.w,
          child: FadeInLeft(
            duration: const Duration(milliseconds: 900),
            child: _buildModuleBadge(
              icon: Icons.account_balance_rounded,
              title: 'المحاسبة',
              badgeColor: const Color(0xFF2ED573),
            ),
          ),
        ),

        // Bottom Right Module Card (CRM)
        Positioned(
          bottom: 20.h,
          right: 15.w,
          child: FadeInRight(
            duration: const Duration(milliseconds: 1000),
            child: _buildModuleBadge(
              icon: Icons.people_alt_rounded,
              title: 'العملاء CRM',
              badgeColor: const Color(0xFF1E90FF),
            ),
          ),
        ),
      ],
    );
  }

  // Slide 2 Illustration: Live Analytics Dashboard Card
  Widget _buildAnalyticsIllustration(Color color) {
    return FadeIn(
      duration: const Duration(milliseconds: 600),
      child: Container(
        padding: EdgeInsets.all(20.r),
        width: 280.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.12),
              blurRadius: 25,
              offset: const Offset(0, 10),
            )
          ],
          border: Border.all(color: color.withOpacity(0.15), width: 1.5),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.r),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Icon(Icons.analytics_rounded,
                          size: 20.r, color: color),
                    ),
                    Gap(10.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'المبيعات الأسبوعية',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          'محدث الآن',
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.trending_up_rounded,
                          size: 14.r, color: Colors.green),
                      Gap(4.w),
                      Text(
                        '+28%',
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Gap(20.h),

            // Animated Bar Chart Simulation
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildChartBar(height: 40.h, color: color.withOpacity(0.4)),
                _buildChartBar(height: 70.h, color: color.withOpacity(0.6)),
                _buildChartBar(height: 50.h, color: color.withOpacity(0.5)),
                _buildChartBar(height: 95.h, color: color),
                _buildChartBar(height: 65.h, color: color.withOpacity(0.7)),
              ],
            ),
            Gap(16.h),

            // Metrics Summary Line
            Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('إجمالي الأرباح:',
                      style: TextStyle(fontSize: 12.sp, color: Colors.grey[700])),
                  Text('\$48,920.00',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                        color: color,
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Slide 3 Illustration: Automated Pipeline & Integration Workflow
  Widget _buildAutomationIllustration(Color color) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Flow card container
        FadeInUp(
          duration: const Duration(milliseconds: 600),
          child: Container(
            width: 270.w,
            padding: EdgeInsets.all(20.r),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24.r),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.12),
                  blurRadius: 25,
                  offset: const Offset(0, 10),
                )
              ],
              border: Border.all(color: color.withOpacity(0.15), width: 1.5),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildWorkflowStep(
                  icon: Icons.add_shopping_cart_rounded,
                  title: 'طلب شراء جديد',
                  status: 'تم الاستلام تلقائياً',
                  stepColor: const Color(0xFF0B409C),
                  isCompleted: true,
                ),
                Padding(
                  padding: EdgeInsets.only(right: 20.w),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: 2.w,
                      height: 24.h,
                      color: Colors.green,
                    ),
                  ),
                ),
                _buildWorkflowStep(
                  icon: Icons.receipt_long_rounded,
                  title: 'إصدار الفاتورة وتحديث المخزن',
                  status: 'جاري المعالجة الحظية',
                  stepColor: Colors.orange,
                  isCompleted: true,
                ),
                Padding(
                  padding: EdgeInsets.only(right: 20.w),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: 2.w,
                      height: 24.h,
                      color: Colors.green,
                    ),
                  ),
                ),
                _buildWorkflowStep(
                  icon: Icons.mark_email_read_rounded,
                  title: 'إرسال التقرير للعميل',
                  status: 'تم الإرسال بنجاح',
                  stepColor: Colors.green,
                  isCompleted: true,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildModuleBadge({
    required IconData icon,
    required String title,
    required Color badgeColor,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(6.r),
            decoration: BoxDecoration(
              color: badgeColor.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16.r, color: badgeColor),
          ),
          Gap(8.w),
          Text(
            title,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartBar({required double height, required Color color}) {
    return Container(
      width: 18.w,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6.r),
      ),
    );
  }

  Widget _buildWorkflowStep({
    required IconData icon,
    required String title,
    required String status,
    required Color stepColor,
    required bool isCompleted,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: stepColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 18.r, color: stepColor),
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
                status,
                style: TextStyle(
                  fontSize: 10.sp,
                  color: stepColor,
                ),
              ),
            ],
          ),
        ),
        Icon(
          Icons.check_circle_rounded,
          size: 18.r,
          color: Colors.green,
        ),
      ],
    );
  }
}

enum OnboardingType { allInOne, analytics, automation }

class OnboardingItemModel {
  final String title;
  final String subtitle;
  final Color accentColor;
  final OnboardingType type;

  OnboardingItemModel({
    required this.title,
    required this.subtitle,
    required this.accentColor,
    required this.type,
  });
}
