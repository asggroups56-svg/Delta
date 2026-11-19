import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/custom_widgets/exception_widget/exception_widget.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_locale_key.dart';
import '../../../data/models/company_model.dart';
import '../../../data/models/journal_config.dart';
import '../cubit/company_cubit.dart';
import '../cubit/company_state.dart';
import '../widget/company_info_section.dart';
class CompanyProfileScreen extends StatefulWidget {
  final Future<void> Function()? onLogout;
  final VoidCallback? onToggleLanguage;
  const CompanyProfileScreen({super.key, this.onLogout, this.onToggleLanguage});
  @override
  State<CompanyProfileScreen> createState() => _CompanyProfileScreenState();
}
class _CompanyProfileScreenState extends State<CompanyProfileScreen> {
  bool get _isAr => context.locale.languageCode == 'ar';
  String _t(String ar, String en) => _isAr ? ar : en;
  bool _isLoggingOut = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CompanyCubit>().getCompany(
        languageCode: context.locale.languageCode,
      );
    });
    
  }

  Future<void> _load() => context.read<CompanyCubit>().getCompany(
    languageCode: context.locale.languageCode,
  );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CompanyCubit, CompanyState>(
      builder: (context, state) {
        final status = state.status;
        final company = status.isSuccess ? status.data?.first : null;
        return Scaffold(
          backgroundColor: AppColor.scaffoldColor(context),
          body: RefreshIndicator(
            color: AppColor.primaryColor(context),
            onRefresh: _load,
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              slivers: [
                // ── Hero Header ──────────────────────────────────────
                _buildHeroSliver(context, company),
                // ── Body Content ─────────────────────────────────────
                SliverPadding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.h,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      if (status.isLoading || status.isInitial)
                        _loadingPlaceholder(context),

                      if (status.isFailure)
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 40.h),
                          child: ExceptionWidget(
                            message: status.error,
                            onReload: _load,
                          ),
                        ),

                      if (company != null) ...[
                        // 1. Quick KPI Highlights
                        _buildQuickStats(context, company),
                        Gap(16.h),

                        // 2. Fiscal Year (priority company setting)
                        CompanyInfoSection(
                          icon: Icons.calendar_month_rounded,
                          color: const Color(0xFF6C5CE7),
                          title: _t('السنة المالية', 'Fiscal Year'),
                          rows: _fiscalRows(context, company),
                        ),
                        Gap(14.h),

                        // 3. Journal Settings
                        //    (currency & cost centers follow vouichCurrCntr)
                        CompanyInfoSection(
                          icon: Icons.menu_book_rounded,
                          color: const Color(0xFF0891B2),
                          title: _t('إعدادات اليومية', 'Journal Settings'),
                          rows: _journalRows(context, company),
                        ),
                        Gap(14.h),

                        // 4. National Address & Communications
                        CompanyInfoSection(
                          icon: Icons.location_on_rounded,
                          color: const Color(0xFF0984E3),
                          title: _t(
                            'العنوان الوطني وبيانات الاتصال',
                            'National Address & Contact',
                          ),
                          rows: _addressRows(context, company),
                        ),
                        Gap(14.h),

                        // 5. Tax & Commercial Registration
                        CompanyInfoSection(
                          icon: Icons.receipt_long_rounded,
                          color: const Color(0xFFE17055),
                          title: _t(
                            'الضرائب والسجل التجاري',
                            'Tax & Commercial Registration',
                          ),
                          rows: _taxRows(context, company),
                        ),
                        Gap(14.h),

                        // 6. System Configuration & Document Signs
                        CompanyInfoSection(
                          icon: Icons.tune_rounded,
                          color: const Color(0xFF475569),
                          title: _t(
                            'خصائص النظام ورموز المستندات',
                            'System Configuration & Document Signs',
                          ),
                          rows: _systemRows(context, company),
                        ),
                        Gap(20.h),

                        // 7. Logout Button
                        _buildLogoutButton(context),
                        Gap(80.h),
                      ],
                    ]),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ── Hero SliverAppBar ───────────────────────────────────────────────────────
  Widget _buildHeroSliver(BuildContext context, CompanyModel? c) {
    final companyNameAr = c?.companyName ?? '';
    final companyNameEn = c?.companyEname ?? '';
    final primaryName = _isAr
        ? (companyNameAr.isNotEmpty ? companyNameAr : companyNameEn)
        : (companyNameEn.isNotEmpty ? companyNameEn : companyNameAr);

    final addressPreview = [
      c?.cityName,
      c?.countryName,
    ].where((e) => e != null && e.isNotEmpty).join(' · ');

    return SliverAppBar(
      expandedHeight: 230.h,
      floating: false,
      pinned: true,
      backgroundColor: AppColor.primaryColor(context),
      surfaceTintColor: Colors.transparent,
      automaticallyImplyLeading: false,
      actions: [
        if (widget.onToggleLanguage != null)
          IconButton(
            onPressed: widget.onToggleLanguage,
            icon: const Icon(
              Icons.language_rounded,
              size: 20,
              color: Colors.white,
            ),
            tooltip: _t('تغيير اللغة', 'Toggle Language'),
          ),
        IconButton(
          onPressed: _load,
          icon: const Icon(
            Icons.refresh_rounded,
            size: 20,
            color: Colors.white,
          ),
          tooltip: _t('تحديث', 'Refresh'),
        ),
        SizedBox(width: 6.w),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColor.primaryColor(context),
                AppColor.secondAppColor(context),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(18.w, 12.h, 18.w, 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Monogram Icon
                      Container(
                        width: 56.r,
                        height: 56.r,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.4),
                            width: 1.5,
                          ),
                        ),
                        child: Icon(
                          Icons.apartment_rounded,
                          size: 30.r,
                          color: Colors.white,
                        ),
                      ),
                      Gap(12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              primaryName.isNotEmpty
                                  ? primaryName
                                  : _t('ملف الشركة', 'Company File'),
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                fontFamily: 'Tajawal',
                                height: 1.25,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (companyNameEn.isNotEmpty && _isAr) ...[
                              Gap(2.h),
                              Text(
                                companyNameEn,
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: Colors.white.withValues(alpha: 0.75),
                                  fontFamily: 'Tajawal',
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                            if (addressPreview.isNotEmpty) ...[
                              Gap(4.h),
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on_rounded,
                                    size: 12.r,
                                    color: const Color(0xFF67E8F9),
                                  ),
                                  Gap(4.w),
                                  Text(
                                    addressPreview,
                                    style: TextStyle(
                                      fontSize: 10.5.sp,
                                      color: Colors.white.withValues(
                                        alpha: 0.9,
                                      ),
                                      fontFamily: 'Tajawal',
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                  Gap(12.h),
                  // Badges: CR, VAT, Delta Config
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 6.h,
                    children: [
                      if (c?.tradeReg != null)
                        _heroBadge(
                          Icons.business_center_rounded,
                          'س.ت: ${c!.tradeReg}',
                        ),
                      if (c?.taxReg != null)
                        _heroBadge(
                          Icons.receipt_rounded,
                          'الضريبي: ${c!.taxReg}',
                        ),
                      if (c?.deltaconfig != null)
                        _heroBadge(
                          Icons.tune_rounded,
                          'تهيئة: ${c!.deltaconfig}',
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _heroBadge(IconData icon, String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11.r, color: Colors.white),
          Gap(4.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 10.sp,
              color: Colors.white,
              fontFamily: 'Tajawal',
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  // ── Quick Stats Highlights ──────────────────────────────────────────────────
  String _fmtDate(DateTime? d) => d != null
      ? '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}'
      : '—';

  Widget _buildQuickStats(BuildContext context, CompanyModel c) {
    final taxPct = (c.taxNew ?? c.taxVal ?? 15.0).toStringAsFixed(0);
    final fiscalYear = c.fiscalYearBegin != null
        ? '${c.fiscalYearBegin!.year}'
        : '2026';
    final currencyLabel = c.currency ?? 'ريال سعودي';

    return Row(
      children: [
        _statCard(
          context,
          value: '$taxPct%',
          subValue: 'السابقة: ${(c.taxVal ?? 5.0).toStringAsFixed(0)}%',
          label: _t('نسبة الضريبة', 'VAT Rate'),
          icon: Icons.percent_rounded,
          color: const Color(0xFFE17055),
        ),
        Gap(10.w),
        _statCard(
          context,
          value: currencyLabel,
          subValue: c.currencyFraction ?? 'هلله',
          label: _t('العملة والكسر', 'Currency'),
          icon: Icons.monetization_on_outlined,
          color: const Color(0xFF0984E3),
        ),
        Gap(10.w),
        _statCard(
          context,
          value: fiscalYear,
          subValue: c.fiscalYearEnd != null
              ? '${_t('ينتهي', 'Ends')} ${_fmtDate(c.fiscalYearEnd)}'
              : _t('غير محددة', 'Not set'),
          label: _t('السنة المالية', 'Fiscal Year'),
          icon: Icons.calendar_today_rounded,
          color: const Color(0xFF6C5CE7),
        ),
      ],
    );
  }

  Widget _statCard(
    BuildContext context, {
    required String value,
    required String subValue,
    required String label,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
        decoration: BoxDecoration(
          color: AppColor.cardColor(context),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: color.withValues(alpha: 0.2)),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(6.r),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 14.r, color: color),
            ),
            Gap(6.h),
            Text(
              value,
              style: AppTextStyle.bodyLarge(context).copyWith(
                fontSize: 12.sp,
                fontWeight: FontWeight.w800,
                color: AppColor.titleFormFiledColor(context),
                fontFamily: 'Tajawal',
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            Text(
              subValue,
              style: TextStyle(
                fontSize: 9.sp,
                color: color,
                fontWeight: FontWeight.w600,
                fontFamily: 'Tajawal',
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            Gap(2.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 9.sp,
                color: AppColor.darkTextColor(context),
                fontFamily: 'Tajawal',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // ── Info Row Widget ─────────────────────────────────────────────────────────
  Widget _infoRow(
    BuildContext context, {
    required String label,
    required String? value,
    required IconData icon,
    required Color iconColor,
    bool copyable = false,
  }) {
    final displayVal = (value != null && value.trim().isNotEmpty)
        ? value.trim()
        : '—';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(6.r),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(icon, size: 14.r, color: iconColor),
        ),
        Gap(12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 10.sp,
                  color: AppColor.darkTextColor(context),
                  fontFamily: 'Tajawal',
                ),
              ),
              Gap(2.h),
              Text(
                displayVal,
                style: TextStyle(
                  fontSize: 12.5.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColor.titleFormFiledColor(context),
                  fontFamily: 'Tajawal',
                ),
              ),
            ],
          ),
        ),
        if (copyable && displayVal != '—')
          GestureDetector(
            onTap: () {
              Clipboard.setData(ClipboardData(text: displayVal));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    _t('تم النسخ: $displayVal', 'Copied: $displayVal'),
                    style: const TextStyle(fontFamily: 'Tajawal'),
                  ),
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 1),
                  backgroundColor: AppColor.primaryColor(context),
                ),
              );
            },
            child: Padding(
              padding: EdgeInsets.only(top: 4.h),
              child: Icon(
                Icons.copy_rounded,
                size: 15.r,
                color: AppColor.darkTextColor(context).withValues(alpha: 0.5),
              ),
            ),
          ),
      ],
    );
  }

  // ── Section 1: Address & Contacts Rows ──────────────────────────────────────
  List<Widget> _addressRows(BuildContext context, CompanyModel c) {
    const color = Color(0xFF0984E3);
    return [
      _infoRow(
        context,
        label: _t('العنوان المسجل (عربي)', 'Registered Address (AR)'),
        value: c.address,
        icon: Icons.store_rounded,
        iconColor: color,
      ),
      _infoRow(
        context,
        label: _t('العنوان المسجل (إنجليزي)', 'Registered Address (EN)'),
        value: c.addressE,
        icon: Icons.language_rounded,
        iconColor: color,
      ),
      _infoRow(
        context,
        label: _t('الشارع', 'Street Name'),
        value: c.streetName,
        icon: Icons.signpost_rounded,
        iconColor: color,
      ),
      _infoRow(
        context,
        label: _t('الحي', 'District Name'),
        value: _isAr ? c.districtName : (c.districtEname ?? c.districtName),
        icon: Icons.map_rounded,
        iconColor: color,
      ),
      _infoRow(
        context,
        label: _t('رقم المبنى', 'Building Number'),
        value: c.buildingNo,
        icon: Icons.home_rounded,
        iconColor: color,
      ),
      _infoRow(
        context,
        label: _t('الرمز البريدي', 'Postal Code'),
        value: c.postalNo,
        icon: Icons.markunread_mailbox_rounded,
        iconColor: color,
      ),
      _infoRow(
        context,
        label: _t('الرقم الإضافي', 'Additional Number'),
        value: c.additionNo,
        icon: Icons.numbers_rounded,
        iconColor: color,
      ),
      _infoRow(
        context,
        label: _t('المدينة', 'City'),
        value: '${c.cityName ?? '—'} (كود: ${c.cityCode ?? '—'})',
        icon: Icons.location_city_rounded,
        iconColor: color,
      ),
      _infoRow(
        context,
        label: _t('الدولة', 'Country'),
        value: '${c.countryName ?? '—'} (كود: ${c.countryCode ?? '—'})',
        icon: Icons.flag_rounded,
        iconColor: color,
      ),
      _infoRow(
        context,
        label: _t('رقم الهاتف 1', 'Phone 1'),
        value: c.telNo1,
        icon: Icons.phone_rounded,
        iconColor: const Color(0xFF00B894),
        copyable: true,
      ),
      _infoRow(
        context,
        label: _t('رقم الهاتف 2', 'Phone 2'),
        value: c.telNo2,
        icon: Icons.phone_rounded,
        iconColor: const Color(0xFF00B894),
        copyable: true,
      ),
      _infoRow(
        context,
        label: _t('البريد الإلكتروني', 'Email'),
        value: c.eMail,
        icon: Icons.email_rounded,
        iconColor: const Color(0xFF6C5CE7),
        copyable: true,
      ),
      _infoRow(
        context,
        label: _t('طبيعة المستند / النشاط', 'Document / Business Nature'),
        value: c.docNature?.toString(),
        icon: Icons.badge_rounded,
        iconColor: color,
      ),
    ];
  }

  // ── Section 2: Tax & Registration Rows ──────────────────────────────────────
  List<Widget> _taxRows(BuildContext context, CompanyModel c) {
    const color = Color(0xFFE17055);
    return [
      _infoRow(
        context,
        label: _t(
          'الرقم الضريبي (VAT Registration)',
          'VAT Registration Number',
        ),
        value: c.taxReg,
        icon: Icons.receipt_long_rounded,
        iconColor: color,
        copyable: true,
      ),
      _infoRow(
        context,
        label: _t(
          'السجل التجاري (Commercial Registration)',
          'Commercial Registration Number',
        ),
        value: c.tradeReg,
        icon: Icons.business_center_rounded,
        iconColor: color,
        copyable: true,
      ),
      _infoRow(
        context,
        label: _t(
          'نسبة الضريبة الجديدة / الحالية (taxNew)',
          'Current VAT Rate',
        ),
        value: c.taxNew != null ? '${c.taxNew!.toStringAsFixed(2)}%' : '15%',
        icon: Icons.percent_rounded,
        iconColor: const Color(0xFFFD79A8),
      ),
      _infoRow(
        context,
        label: _t(
          'نسبة الضريبة الأساسية / السابقة (taxVal)',
          'Base/Previous VAT Rate',
        ),
        value: c.taxVal != null ? '${c.taxVal!.toStringAsFixed(2)}%' : '5%',
        icon: Icons.percent_rounded,
        iconColor: const Color(0xFFBDC3C7),
      ),
      _infoRow(
        context,
        label: _t('الفترة الضريبية (taxTerm)', 'Tax Period Term'),
        value: c.taxTerm != null ? '${c.taxTerm} (ربع سنوي)' : '—',
        icon: Icons.event_repeat_rounded,
        iconColor: color,
      ),
    ];
  }

  // ── Section 3: Fiscal Year Rows ─────────────────────────────────────────────
  List<Widget> _fiscalRows(BuildContext context, CompanyModel c) {
    const color = Color(0xFF6C5CE7);

    return [
      _infoRow(
        context,
        label: _t('بداية السنة المالية (fiscalYearBegin)', 'Fiscal Year Begin'),
        value: _fmtDate(c.fiscalYearBegin),
        icon: Icons.play_circle_rounded,
        iconColor: color,
      ),
      _infoRow(
        context,
        label: _t('نهاية السنة المالية (fiscalYearEnd)', 'Fiscal Year End'),
        value: _fmtDate(c.fiscalYearEnd),
        icon: Icons.stop_circle_rounded,
        iconColor: const Color(0xFFE17055),
      ),
    ];
  }

  // ── Section 4: Journal Settings Rows ────────────────────────────────────────
  List<Widget> _journalRows(BuildContext context, CompanyModel c) {
    const color = Color(0xFF0891B2);
    final config = c.journalConfig;

    return [
      _journalConfigCard(context, config),
      _infoRow(
        context,
        label: _t(
          'معرّف تهيئة اليومية (vouichCurrCntr)',
          'Journal Configuration ID (vouichCurrCntr)',
        ),
        value: config.id?.toString(),
        icon: Icons.tag_rounded,
        iconColor: color,
      ),
      _infoRow(
        context,
        label: _t(
          'تحديث اليومية التلقائي (jrlUpdate)',
          'Daily Journal Auto Update (jrlUpdate)',
        ),
        value: c.jrlUpdate == 1
            ? _t('مفعل (1)', 'Enabled (1)')
            : _t('معطل (0)', 'Disabled (0)'),
        icon: Icons.auto_mode_rounded,
        iconColor: color,
      ),
      _infoRow(
        context,
        label: _t('العملة الأساسية (currency)', 'Base Currency (currency)'),
        value: c.currency,
        icon: Icons.monetization_on_rounded,
        iconColor: const Color(0xFF00B894),
      ),
      _infoRow(
        context,
        label: _t(
          'كسر العملة (currencyFraction)',
          'Currency Fraction (currencyFraction)',
        ),
        value: c.currencyFraction,
        icon: Icons.money_rounded,
        iconColor: const Color(0xFF00B894),
      ),
      if (config.usesCurrency && c.ecurrency != null)
        _infoRow(
          context,
          label: _t(
            'العملة الأجنبية (ecurrency)',
            'Foreign Currency (ecurrency)',
          ),
          value: c.ecurrency,
          icon: Icons.currency_exchange_rounded,
          iconColor: color,
        ),
    ];
  }

  /// Summary card that visualises the id-driven journal configuration.
  Widget _journalConfigCard(BuildContext context, JournalConfig config) {
    const color = Color(0xFF0891B2);
    final costCenterLabel = switch (config.costCenters) {
      CostCenterMode.none => _t('بدون مراكز تكلفة', 'No cost centers'),
      CostCenterMode.multiple => _t('مع مراكز التكلفة', 'With cost centers'),
      CostCenterMode.single => _t('مركز تكلفة واحد', 'One cost center'),
    };

    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: 0.12),
            color.withValues(alpha: 0.035),
          ],
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
        ),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: color.withValues(alpha: 0.22)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 34.r,
                height: 34.r,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(Icons.menu_book_rounded, size: 17.r, color: color),
              ),
              Gap(9.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _t('تهيئة اليومية', 'Journal configuration'),
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w800,
                        color: AppColor.titleFormFiledColor(context),
                        fontFamily: 'Tajawal',
                      ),
                    ),
                    Gap(2.h),
                    Text(
                      config.isKnown
                          ? _t(
                              'مبنية على المعرّف ${config.id}',
                              'Based on configuration id ${config.id}',
                            )
                          : _t(
                              'معرّف غير معروف — الإعدادات الافتراضية',
                              'Unknown id — default settings',
                            ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 9.5.sp,
                        color: AppColor.darkTextColor(context),
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ],
                ),
              ),
              Gap(8.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  '#${config.id ?? '—'}',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    fontFamily: 'Tajawal',
                  ),
                ),
              ),
            ],
          ),
          Gap(10.h),
          Row(
            children: [
              Expanded(
                child: _journalFeatureTile(
                  context,
                  icon: Icons.monetization_on_rounded,
                  label: _t('العملة', 'Currency'),
                  value: config.usesCurrency
                      ? _t('مفعلة', 'Enabled')
                      : _t('غير مفعلة', 'Disabled'),
                  enabled: config.usesCurrency,
                  color: color,
                ),
              ),
              Gap(8.w),
              Expanded(
                child: _journalFeatureTile(
                  context,
                  icon: Icons.hub_rounded,
                  label: _t('مراكز التكلفة', 'Cost centers'),
                  value: costCenterLabel,
                  enabled: config.usesCostCenters,
                  color: color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _journalFeatureTile(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required bool enabled,
    required Color color,
  }) {
    final tone = enabled
        ? color
        : AppColor.darkTextColor(context).withValues(alpha: 0.55);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColor.cardColor(context).withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: tone.withValues(alpha: 0.22)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14.r, color: tone),
          Gap(6.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 8.5.sp,
                    color: AppColor.darkTextColor(context),
                    fontFamily: 'Tajawal',
                  ),
                ),
                Gap(1.h),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                    color: tone,
                    fontFamily: 'Tajawal',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Section 5: System Configuration & Document Signs ────────────────────────
  List<Widget> _systemRows(BuildContext context, CompanyModel c) {
    const color = Color(0xFF475569);
    String yn(int? v) =>
        v == 1 ? _t('مفعل (1)', 'Enabled (1)') : _t('معطل (0)', 'Disabled (0)');

    return [
      // Document Signs
      _infoRow(
        context,
        label: _t('رمز الفاتورة (invoiceSign)', 'Invoice Sign'),
        value: c.invoiceSign,
        icon: Icons.tag_rounded,
        iconColor: const Color(0xFF0984E3),
      ),
      _infoRow(
        context,
        label: _t('رمز إشعار المدين (debitSign)', 'Debit Note Sign'),
        value: c.debitSign,
        icon: Icons.tag_rounded,
        iconColor: const Color(0xFF0984E3),
      ),
      _infoRow(
        context,
        label: _t('رمز إشعار الدائن (creditSign)', 'Credit Note Sign'),
        value: c.creditSign,
        icon: Icons.tag_rounded,
        iconColor: const Color(0xFF0984E3),
      ),
      _infoRow(
        context,
        label: _t('رمز الدفعة المقدمة (advanceSign)', 'Advance Payment Sign'),
        value: c.advanceSign,
        icon: Icons.tag_rounded,
        iconColor: const Color(0xFF00B894),
      ),
      _infoRow(
        context,
        label: _t(
          'رمز إشعار دائن دفعة مقدمة (advCrnSign)',
          'Advance Credit Note Sign',
        ),
        value: c.advCrnSign,
        icon: Icons.tag_rounded,
        iconColor: const Color(0xFF00B894),
      ),

      // Core System Flags
      _infoRow(
        context,
        label: _t('رقم تهيئة دلتا (deltaconfig)', 'Delta Configuration ID'),
        value: c.deltaconfig,
        icon: Icons.settings_rounded,
        iconColor: color,
      ),
      _infoRow(
        context,
        label: _t(
          'صلاحية حذف السندات (delVoucher)',
          'Delete Voucher Permission',
        ),
        value: yn(c.delVoucher),
        icon: Icons.delete_sweep_rounded,
        iconColor: color,
      ),
      _infoRow(
        context,
        label: _t('التثبيت مرة أخرى (instAgain)', 'Install Again'),
        value: yn(c.instAgain),
        icon: Icons.repeat_rounded,
        iconColor: color,
      ),
      _infoRow(
        context,
        label: _t(
          'عدد مستويات شجرة الحسابات (noOfLevels)',
          'Account Tree Levels',
        ),
        value: c.noOfLevels?.toString(),
        icon: Icons.account_tree_rounded,
        iconColor: color,
      ),
      _infoRow(
        context,
        label: _t(
          'إظهار الحساب المساعد (showAssistant)',
          'Show Assistant Account',
        ),
        value: yn(c.showAssistant),
        icon: Icons.assistant_rounded,
        iconColor: color,
      ),
      _infoRow(
        context,
        label: _t('استخدام الفواصل الرقمية (separator)', 'Number Separator'),
        value: yn(c.separator),
        icon: Icons.space_bar_rounded,
        iconColor: color,
      ),
      _infoRow(
        context,
        label: _t(
          'الخانات العشرية للمبالغ (decimal3)',
          'Decimal Places (Amounts)',
        ),
        value: c.decimal3?.toString(),
        icon: Icons.pin_rounded,
        iconColor: color,
      ),
      _infoRow(
        context,
        label: _t(
          'الخانات العشرية للكميات (decimal4)',
          'Decimal Places (Quantities)',
        ),
        value: c.decimal4?.toString(),
        icon: Icons.pin_rounded,
        iconColor: color,
      ),
      _infoRow(
        context,
        label: _t(
          'الخانات العشرية للأسعار (decimal5)',
          'Decimal Places (Prices)',
        ),
        value: c.decimal5?.toString(),
        icon: Icons.pin_rounded,
        iconColor: color,
      ),
      _infoRow(
        context,
        label: _t('ميزان مراجعة الحسابات (accBal)', 'Accounts Balance Check'),
        value: yn(c.accBal),
        icon: Icons.balance_rounded,
        iconColor: color,
      ),
      _infoRow(
        context,
        label: _t('ميزان مراكز التكلفة (cenBal)', 'Cost Centers Balance Check'),
        value: yn(c.cenBal),
        icon: Icons.balance_rounded,
        iconColor: color,
      ),
      _infoRow(
        context,
        label: _t(
          'ميزان الحسابات والمراكز المشترك (cenAccBal)',
          'Combined Acc/Center Bal Check',
        ),
        value: yn(c.cenAccBal),
        icon: Icons.balance_rounded,
        iconColor: color,
      ),
    ];
  }

  // ── Logout Action ───────────────────────────────────────────────────────────
  Future<void> _handleLogout() async {
    if (_isLoggingOut || widget.onLogout == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColor.cardColor(context),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: const Color(0xFFFF7675).withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.logout_rounded,
                color: Color(0xFFFF7675),
                size: 20,
              ),
            ),
            Gap(10.w),
            Text(
              _t('تسجيل الخروج', 'Logout'),
              style: AppTextStyle.bodyLarge(context).copyWith(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                fontFamily: 'Tajawal',
              ),
            ),
          ],
        ),
        content: Text(
          _t(
            'هل أنت متأكد من رغبتك في تسجيل الخروج؟',
            'Are you sure you want to log out?',
          ),
          style: AppTextStyle.bodyMedium(context).copyWith(
            fontSize: 13.sp,
            color: AppColor.darkTextColor(context),
            fontFamily: 'Tajawal',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              _t('إلغاء', 'Cancel'),
              style: TextStyle(
                fontFamily: 'Tajawal',
                color: AppColor.darkTextColor(context),
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF7675),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              _t('تأكيد الخروج', 'Confirm'),
              style: const TextStyle(
                fontFamily: 'Tajawal',
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isLoggingOut = true);
    try {
      await widget.onLogout!();
    } finally {
      if (mounted) {
        setState(() => _isLoggingOut = false);
      }
    }
  }

  Widget _buildLogoutButton(BuildContext context) {
    return GestureDetector(
      onTap: _isLoggingOut ? null : _handleLogout,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          color: const Color(0xFFFF7675).withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: const Color(0xFFFF7675).withValues(alpha: 0.25),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isLoggingOut) ...[
              SizedBox(
                width: 18.r,
                height: 18.r,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Color(0xFFFF7675),
                ),
              ),
              Gap(10.w),
              Text(
                _t('جاري تسجيل الخروج...', 'Logging out...'),
                style: AppTextStyle.bodySmall(context).copyWith(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFFFF7675),
                  fontFamily: 'Tajawal',
                ),
              ),
            ] else ...[
              const Icon(
                Icons.logout_rounded,
                color: Color(0xFFFF7675),
                size: 18,
              ),
              Gap(8.w),
              Text(
                AppLocaleKey.logout.tr(),
                style: AppTextStyle.bodySmall(context).copyWith(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFFFF7675),
                  fontFamily: 'Tajawal',
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _loadingPlaceholder(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 60.h),
      child: Center(
        child: Column(
          children: [
            SizedBox(
              width: 36.r,
              height: 36.r,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: AppColor.primaryColor(context),
              ),
            ),
            Gap(14.h),
            Text(
              _t(
                'جاري تحميل بيانات ملف الشركة...',
                'Loading company profile data...',
              ),
              style: TextStyle(
                fontFamily: 'Tajawal',
                color: AppColor.darkTextColor(context),
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
