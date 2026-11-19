import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:my_template/core/cache/shared_pref/shared_pref.dart';
import 'package:my_template/core/services/services_locator.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/features/company/data/models/company_model.dart';
import 'package:my_template/features/company/presentation/view/cubit/company_cubit.dart';
import 'package:my_template/features/company/presentation/view/cubit/company_state.dart';

class DeltaWelcomeBannerWidget extends StatelessWidget {
  const DeltaWelcomeBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    try {
      context.read<CompanyCubit>();
      return const _DeltaWelcomeBannerContent();
    } catch (_) {
      return BlocProvider<CompanyCubit>(
        create: (ctx) => sl<CompanyCubit>()
          ..getCompany(languageCode: ctx.locale.languageCode),
        child: const _DeltaWelcomeBannerContent(),
      );
    }
  }
}

class _DeltaWelcomeBannerContent extends StatefulWidget {
  const _DeltaWelcomeBannerContent();

  @override
  State<_DeltaWelcomeBannerContent> createState() =>
      _DeltaWelcomeBannerContentState();
}

class _DeltaWelcomeBannerContentState extends State<_DeltaWelcomeBannerContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';
    final now = DateTime.now();

    // 1. تاريخ اليوم المنسق
    final todayFormatted = isArabic
        ? DateFormat('EEEE، d MMMM yyyy', 'ar').format(now)
        : DateFormat('EEEE, MMM d, yyyy', 'en').format(now);

    // 2. اسم قاعدة البيانات من الـ Cache
    final rawDb = CacheHelper.sharedPreferences
        .getString(CacheHelper.connectionNameKey);

    return BlocBuilder<CompanyCubit, CompanyState>(
      builder: (context, state) {
        final company =
            state.status.isSuccess ? state.status.data?.first : null;

        // اسم قاعدة البيانات النهائي
        final dbName = (rawDb != null && rawDb.trim().isNotEmpty)
            ? rawDb.trim()
            : (company?.companyName ??
                (isArabic ? 'Delta_DB' : 'Delta_DB'));

        // 3. اليومية من بيانات الشركة
        final journalConfig = company?.deltaconfig ?? '1';
        final isJrlUpdated = company?.jrlUpdate == 1;
        final journalText = isArabic
            ? 'اليومية: $journalConfig${isJrlUpdated ? ' (محدثة)' : ''}'
            : 'Journal: $journalConfig${isJrlUpdated ? ' (Active)' : ''}';

        // اسم الشركة للعنوان
        final welcomeTitle = company != null
            ? (isArabic
                ? (company.companyName ?? 'نظام دلتا ASG')
                : (company.companyEname ?? company.companyName ?? 'Delta ASG'))
            : (isArabic ? 'نظام دلتا ASG' : 'Delta ASG System');

        return Container(
          width: double.infinity,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF1E3A8A), // Deep Royal Navy
                  Color(0xFF1D4ED8), // Vibrant Indigo Blue
                  Color(0xFF2563EB), // Delta Accent Blue
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(22.r),
              border: Border.all(
                color: const Color(0xFF60A5FA).withValues(alpha: 0.35),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1E3A8A).withValues(alpha: 0.45),
                  blurRadius: 20.r,
                  offset: const Offset(0, 8),
                ),
                BoxShadow(
                  color: const Color(0xFF2563EB).withValues(alpha: 0.25),
                  blurRadius: 30.r,
                  spreadRadius: 2,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22.r),
              child: Stack(
                children: [
                  // Ambient Decorative Glows
                  Positioned(
                    top: -40.r,
                    right: isArabic ? null : -40.r,
                    left: isArabic ? -40.r : null,
                    child: Container(
                      width: 160.r,
                      height: 160.r,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            const Color(0xFF60A5FA).withValues(alpha: 0.35),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -30.r,
                    left: isArabic ? null : -30.r,
                    right: isArabic ? -30.r : null,
                    child: Container(
                      width: 140.r,
                      height: 140.r,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            const Color(0xFF06B6D4).withValues(alpha: 0.25),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.all(18.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Top Header Row with Badges ──
                        Row(
                          children: [
                            // Main Dashboard Badge
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 5.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColor.buttonTextColor(context)
                                    .withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(20.r),
                                border: Border.all(
                                  color: AppColor.buttonTextColor(context)
                                      .withValues(alpha: 0.25),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.dashboard_outlined,
                                    size: 13.r,
                                    color: AppColor.buttonTextColor(context),
                                  ),
                                  Gap(5.w),
                                  Text(
                                    isArabic
                                        ? 'لوحة التحكم الرئيسية'
                                        : 'Main Dashboard',
                                    style:
                                        AppTextStyle.caption(context).copyWith(
                                      fontSize: 10.5.sp,
                                      fontWeight: FontWeight.w700,
                                      color:
                                          AppColor.buttonTextColor(context),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            // Database Badge (اسم قاعدة البيانات)
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 5.h,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF06B6D4)
                                    .withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(20.r),
                                border: Border.all(
                                  color: const Color(0xFF67E8F9)
                                      .withValues(alpha: 0.4),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.storage_rounded,
                                    size: 12.r,
                                    color: const Color(0xFF67E8F9),
                                  ),
                                  Gap(5.w),
                                  ConstrainedBox(
                                    constraints:
                                        BoxConstraints(maxWidth: 130.w),
                                    child: Text(
                                      dbName,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFFE0F2FE),
                                        fontFamily: 'Tajawal',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        Gap(14.h),

                        // ── Main Row: Headline & Orbit Graphic ──
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    isArabic
                                        ? 'مرحبًا بك في $welcomeTitle'
                                        : 'Welcome to $welcomeTitle',
                                    style: AppTextStyle.titleBold(
                                      context,
                                      fontSize: 17,
                                      color: Colors.white,
                                    ).copyWith(
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: -0.3,
                                      height: 1.25,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Gap(6.h),
                                  Text(
                                    isArabic
                                        ? 'مساحة عمل موحدة لإدارة الحسابات، الحركات اليومية، المنشأة ومراكز التكلفة.'
                                        : 'A unified workspace for managing accounts, daily transactions, and cost centers.',
                                    style:
                                        AppTextStyle.bodySmall(context).copyWith(
                                      fontSize: 11.sp,
                                      color: AppColor.buttonTextColor(context)
                                          .withValues(alpha: 0.85),
                                      height: 1.35,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Gap(10.w),
                            _buildOrbitGraphic(context, isArabic),
                          ],
                        ),

                        Gap(16.h),

                        // ── Bottom Chips Row: Date, Database, Journal, Status ──
                        Wrap(
                          spacing: 8.w,
                          runSpacing: 8.h,
                          children: [
                            // 1. تاريخ اليوم
                            _buildStatusChip(
                              context,
                              icon: Icons.calendar_today_rounded,
                              iconColor: const Color(0xFF93C5FD),
                              borderColor: const Color(0xFF60A5FA)
                                  .withValues(alpha: 0.25),
                              label: todayFormatted,
                            ),

                            // 2. اليومية من بيانات الشركة
                            _buildStatusChip(
                              context,
                              icon: Icons.menu_book_rounded,
                              iconColor: const Color(0xFFFDE047),
                              borderColor: const Color(0xFFFDE047)
                                  .withValues(alpha: 0.3),
                              label: journalText,
                            ),

                            // 3. قاعدة البيانات
                            _buildStatusChip(
                              context,
                              icon: Icons.dns_rounded,
                              iconColor: const Color(0xFF67E8F9),
                              borderColor: const Color(0xFF06B6D4)
                                  .withValues(alpha: 0.3),
                              label: isArabic
                                  ? 'قاعدة البيانات: $dbName'
                                  : 'DB: $dbName',
                            ),

                            // 4. حالة النظام (System Ready)
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 6.h,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0F172A)
                                    .withValues(alpha: 0.35),
                                borderRadius: BorderRadius.circular(10.r),
                                border: Border.all(
                                  color: const Color(0xFF10B981)
                                      .withValues(alpha: 0.35),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 7.r,
                                    height: 7.r,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF00E676),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color(0xFF00E676),
                                          blurRadius: 6,
                                          spreadRadius: 1,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Gap(6.w),
                                  Text(
                                    isArabic
                                        ? 'النظام متصل'
                                        : 'System Online',
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF6EE7B7),
                                      fontFamily: 'Tajawal',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
    );
  }

  Widget _buildStatusChip(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required Color borderColor,
    required String label,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A).withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: borderColor,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12.r,
            color: iconColor,
          ),
          Gap(6.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 10.5.sp,
              fontWeight: FontWeight.w600,
              color: AppColor.buttonTextColor(context).withValues(alpha: 0.95),
              fontFamily: 'Tajawal',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrbitGraphic(BuildContext context, bool isArabic) {
    return ScaleTransition(
      scale: _pulseAnimation,
      child: Container(
        width: 78.r,
        height: 78.r,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColor.buttonTextColor(context).withValues(alpha: 0.1),
          border: Border.all(
            color: AppColor.buttonTextColor(context).withValues(alpha: 0.25),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF38BDF8).withValues(alpha: 0.2),
              blurRadius: 16.r,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Outer dashed ring effect
            Container(
              width: 66.r,
              height: 66.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF93C5FD).withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
            ),
            // Center Core
            Container(
              width: 44.r,
              height: 44.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFF38BDF8), Color(0xFF2563EB)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1D4ED8).withValues(alpha: 0.5),
                    blurRadius: 8.r,
                  ),
                ],
              ),
              child: Icon(
                Icons.account_balance_rounded,
                color: AppColor.buttonTextColor(context),
                size: 22.r,
              ),
            ),
            // Satellite Icon 1 (Wallet)
            Positioned(
              top: 3.r,
              right: 6.r,
              child: Container(
                padding: EdgeInsets.all(3.r),
                decoration: const BoxDecoration(
                  color: Color(0xFF1E293B),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.account_balance_wallet_outlined,
                  size: 10,
                  color: Color(0xFF60A5FA),
                ),
              ),
            ),
            // Satellite Icon 2 (Analytics)
            Positioned(
              bottom: 3.r,
              left: 6.r,
              child: Container(
                padding: EdgeInsets.all(3.r),
                decoration: const BoxDecoration(
                  color: Color(0xFF1E293B),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.bar_chart_rounded,
                  size: 10,
                  color: Color(0xFF34D399),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
