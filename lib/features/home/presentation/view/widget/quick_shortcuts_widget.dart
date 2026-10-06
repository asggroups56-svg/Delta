import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/routes/routes_name.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/utils/app_locale_key.dart';
import 'package:my_template/core/utils/navigator_methods.dart';

class QuickShortcutsWidget extends StatelessWidget {
  final VoidCallback onAiTap;

  const QuickShortcutsWidget({super.key, required this.onAiTap});

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';

    final shortcuts = [
      {
        'title': AppLocaleKey.createInvoice.tr(),
        'subtitle': isArabic ? 'فاتورة بيع إلكترونية' : 'E-Invoice',
        'icon': Icons.receipt_long_rounded,
        'gradient': [const Color(0xFF1E40AF), const Color(0xFF2563EB)],
        'onTap': () =>
            NavigatorMethods.pushNamed(context, RoutesName.createInvoiceScreen),
      },
      {
        'title': isArabic ? 'مسح الفواتير OCR' : 'OCR Scan Bill',
        'subtitle': isArabic ? 'استخراج ذكي للبيانات' : 'Smart Extraction',
        'icon': Icons.document_scanner_rounded,
        'gradient': [const Color(0xFF047857), const Color(0xFF10B981)],
        'onTap': () =>
            NavigatorMethods.pushNamed(context, RoutesName.purchaseOcrScreen),
      },
      {
        'title': isArabic ? 'عميل جديد' : 'New Customer',
        'subtitle': isArabic ? 'إضافة شريك عمل' : 'Add Partner',
        'icon': Icons.person_add_alt_1_rounded,
        'gradient': [const Color(0xFF0369A1), const Color(0xFF0EA5E9)],
        'onTap': () =>
            NavigatorMethods.pushNamed(context, RoutesName.addLeadScreen),
      },
      {
        'title': isArabic ? 'التقارير والقوائم' : 'Financial Reports',
        'subtitle': isArabic ? 'تحليلات لحظية' : 'Live Analytics',
        'icon': Icons.analytics_outlined,
        'gradient': [const Color(0xFF6D28D9), const Color(0xFF8B5CF6)],
        'onTap': () =>
            NavigatorMethods.pushNamed(context, RoutesName.reportsScreen),
      },
      {
        'title': isArabic ? 'لوحة المحاسبة' : 'Accounting Dashboard',
        'subtitle': isArabic ? 'إدارة القيود والضرائب' : 'Tax & Ledger',
        'icon': Icons.account_balance_outlined,
        'gradient': [const Color(0xFFB45309), const Color(0xFFF59E0B)],
        'onTap': () => NavigatorMethods.pushNamed(
          context,
          RoutesName.accountingDashboardScreen,
        ),
      },
      {
        'title': 'AI Copilot',
        'subtitle': isArabic ? 'مساعد دلتا الذكي' : 'Delta Assistant',
        'icon': Icons.auto_awesome_rounded,
        'gradient': [const Color(0xFFBE123C), const Color(0xFFF43F5E)],
        'onTap': () =>
            NavigatorMethods.pushNamed(context, RoutesName.aiCopilotScreen),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Section Header ───────────────────────────────────────────────────
        FadeInDown(
          duration: const Duration(milliseconds: 300),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6.r,
                    height: 6.r,
                    decoration: const BoxDecoration(
                      color: Color(0xFF059669),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Gap(5.w),
                  Text(
                    isArabic ? 'اختصارات العمل' : 'Work Shortcuts',
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF059669),
                    ),
                  ),
                ],
              ),
              Gap(3.h),
              Text(
                isArabic ? 'الوصول السريع' : 'Quick Access',
                style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w900,
                  color: AppColor.titleFormFiledColor(context),
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
        ),

        Gap(12.h),

        // ── Grid of Shortcuts ────────────────────────────────────────────────
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: shortcuts.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10.w,
            mainAxisSpacing: 10.h,
            childAspectRatio: 2.2,
          ),
          itemBuilder: (context, index) {
            final item = shortcuts[index];
            final gradientColors = item['gradient'] as List<Color>;

            return FadeInUp(
              delay: Duration(milliseconds: 50 * index),
              duration: const Duration(milliseconds: 300),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: item['onTap'] as VoidCallback,
                  borderRadius: BorderRadius.circular(16.r),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColor.cardColor(context),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: AppColor.borderColor(context),
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(
                            0xFF0F172A,
                          ).withValues(alpha: 0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Gradient Icon
                        Container(
                          padding: EdgeInsets.all(8.r),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: gradientColors,
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12.r),
                            boxShadow: [
                              BoxShadow(
                                color: gradientColors.first.withValues(
                                  alpha: 0.25,
                                ),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: Icon(
                            item['icon'] as IconData,
                            size: 16.r,
                            color: Colors.white,
                          ),
                        ),
                        Gap(8.w),
                        // Titles
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                item['title'] as String,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 11.5.sp,
                                  fontWeight: FontWeight.w800,
                                  color: AppColor.titleFormFiledColor(context),
                                ),
                              ),
                              Gap(2.h),
                              Text(
                                item['subtitle'] as String,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 9.5.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.darkTextColor(context),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
