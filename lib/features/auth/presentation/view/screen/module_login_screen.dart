import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/custom_widgets/custom_form_field/custom_form_field.dart';
import 'package:my_template/core/custom_widgets/custom_toast/custom_toast.dart';
import 'package:my_template/core/routes/routes_name.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/utils/app_locale_key.dart';
import 'package:my_template/core/utils/common_methods.dart';
import 'package:my_template/core/utils/navigator_methods.dart';
import 'package:my_template/features/auth/presentation/view/cubit/auth_cubit.dart';

/// Single-page module portal: pick an ERP workspace, then sign in with the
/// account linked to it. The selected module drives the accent, copy and the
/// module id stored on [AuthCubit].
class ModuleLoginScreen extends StatefulWidget {
  const ModuleLoginScreen({super.key});

  @override
  State<ModuleLoginScreen> createState() => _ModuleLoginScreenState();
}

class _ModuleLoginScreenState extends State<ModuleLoginScreen> {
  final _formKey = GlobalKey<FormState>();

  _ErpModule _selectedModule = _erpModules.first;

  bool get _isArabic => context.locale.languageCode == 'ar';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<AuthCubit>().selectModule(_selectedModule.id);
  }

  Future<void> _toggleLanguage() async {
    if (_isArabic) {
      await context.setLocale(const Locale('en'));
    } else {
      await context.setLocale(const Locale('ar'));
    }
    if (mounted) setState(() {});
  }

  void _selectModule(_ErpModule module) {
    if (module.id == _selectedModule.id) return;
    setState(() => _selectedModule = module);
    context.read<AuthCubit>().selectModule(module.id);
  }

  void _submit(AuthCubit cubit) {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    cubit.selectModule(_selectedModule.id);
    cubit.login(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffoldColor(context),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state.loginStatus.isSuccess) {
            CommonMethods.showToast(
              message:
                  state.loginStatus.data?.message ??
                  (_isArabic
                      ? 'تم تسجيل الدخول بنجاح'
                      : 'Signed in successfully'),
            );
            NavigatorMethods.pushNamedAndRemoveUntil(
              context,
              RoutesName.mainShellScreen,
            );
          }
          if (state.loginStatus.isFailure) {
            CommonMethods.showToast(
              message:
                  state.loginStatus.error?.toString() ??
                  (_isArabic ? 'فشل تسجيل الدخول' : 'Login failed'),
              type: ToastType.error,
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<AuthCubit>();
          final isLoading = state.loginStatus.isLoading;

          return Stack(
            children: [
              const Positioned.fill(child: _PortalBackground()),
              SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 4.h),
                      child: _TopBar(
                        isArabic: _isArabic,
                        onToggleLanguage: _toggleLanguage,
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.fromLTRB(20.w, 18.h, 20.w, 28.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            FadeInUp(
                              duration: const Duration(milliseconds: 450),
                              child: _Hero(isArabic: _isArabic),
                            ),
                            Gap(28.h),
                            _ModulePicker(
                              isArabic: _isArabic,
                              selected: _selectedModule,
                              enabled: !isLoading,
                              onSelected: _selectModule,
                            ),
                            Gap(22.h),
                            _buildLoginCard(
                              context,
                              cubit,
                              isLoading: isLoading,
                              isArabic: _isArabic,
                            ),
                            Gap(22.h),
                            Center(
                              child: Text(
                                AppLocaleKey.versionPoweredBy.tr(),
                                style: TextStyle(
                                  fontSize: 10.5.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF94A3B8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  //  SIGN-IN CARD
  // ═══════════════════════════════════════════════════════════════════════
  Widget _buildLoginCard(
    BuildContext context,
    AuthCubit cubit, {
    required bool isLoading,
    required bool isArabic,
  }) {
    final module = _selectedModule;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return FadeInUp(
      duration: const Duration(milliseconds: 450),
      delay: const Duration(milliseconds: 90),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: AppColor.cardColor(context),
          borderRadius: BorderRadius.circular(26.r),
          border: Border.all(
            color: module.primary.withValues(alpha: isDark ? 0.3 : 0.16),
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(
                0xFF0F172A,
              ).withValues(alpha: isDark ? 0.4 : 0.08),
              blurRadius: 34,
              offset: const Offset(0, 18),
            ),
            BoxShadow(
              color: module.primary.withValues(alpha: isDark ? 0.16 : 0.08),
              blurRadius: 26,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Module accent strip
            AnimatedContainer(
              duration: const Duration(milliseconds: 280),
              height: 4,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [module.primary, module.secondary],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(24.w, 22.h, 24.w, 24.h),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildCardHeader(context, module, isArabic),
                    Gap(18.h),
                    Divider(
                      height: 1,
                      color: AppColor.borderColor(
                        context,
                      ).withValues(alpha: 0.7),
                    ),
                    Gap(18.h),

                    _label(context, isArabic ? 'اسم المستخدم' : 'Username'),
                    Gap(8.h),
                    CustomFormField(
                      controller: cubit.usernameController,
                      hintText: isArabic
                          ? 'أدخل اسم المستخدم'
                          : 'Enter your username',
                      textStyle: TextStyle(
                        fontSize: 13.5.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColor.textFormColor(context),
                      ),
                      prefixIcon: Icon(
                        Icons.person_outline_rounded,
                        color: module.primary,
                      ),
                      radius: 12.r,
                      fillColor: AppColor.textFormFillColor(context),
                      unFocusColor: AppColor.textFormBorderColor(context),
                      focusColor: module.primary,
                      validator: (value) => (value ?? '').trim().isEmpty
                          ? (isArabic
                                ? 'اسم المستخدم مطلوب'
                                : 'Username is required')
                          : null,
                    ),
                    Gap(15.h),

                    _label(context, AppLocaleKey.password.tr()),
                    Gap(8.h),
                    CustomFormField(
                      controller: cubit.passwordController,
                      hintText: isArabic
                          ? 'أدخل كلمة المرور'
                          : 'Enter your password',
                      textStyle: TextStyle(
                        fontSize: 13.5.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColor.textFormColor(context),
                      ),
                      prefixIcon: Icon(
                        Icons.lock_outline_rounded,
                        color: module.primary,
                      ),
                      isPassword: true,
                      passwordColor: AppColor.darkTextColor(context),
                      radius: 12.r,
                      fillColor: AppColor.textFormFillColor(context),
                      unFocusColor: AppColor.textFormBorderColor(context),
                      focusColor: module.primary,
                      validator: (value) => (value ?? '').isEmpty
                          ? (isArabic
                                ? 'كلمة المرور مطلوبة'
                                : 'Password is required')
                          : null,
                    ),
                    Gap(15.h),

                    _label(
                      context,
                      isArabic ? 'اسم الاتصال' : 'Connection name',
                    ),
                    Gap(8.h),
                    CustomFormField(
                      controller: cubit.connectionNameController,
                      hintText: isArabic
                          ? 'أدخل اسم الاتصال'
                          : 'Enter your connection name',
                      textStyle: TextStyle(
                        fontSize: 13.5.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColor.textFormColor(context),
                      ),
                      prefixIcon: Icon(
                        Icons.storage_rounded,
                        color: module.primary,
                      ),
                      radius: 12.r,
                      fillColor: AppColor.textFormFillColor(context),
                      unFocusColor: AppColor.textFormBorderColor(context),
                      focusColor: module.primary,
                      validator: (value) => (value ?? '').trim().isEmpty
                          ? (isArabic
                                ? 'اسم الاتصال مطلوب'
                                : 'Connection name is required')
                          : null,
                    ),

                    Gap(4.h),
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: TextButton(
                        onPressed: isLoading
                            ? null
                            : () => NavigatorMethods.pushNamed(
                                context,
                                RoutesName.forgotPasswordScreen,
                              ),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          minimumSize: const Size(0, 34),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          isArabic ? 'نسيت كلمة المرور؟' : 'Forgot password?',
                          style: TextStyle(
                            fontSize: 11.5.sp,
                            fontWeight: FontWeight.w700,
                            color: module.primary,
                          ),
                        ),
                      ),
                    ),
                    Gap(6.h),

                    SizedBox(
                      width: double.infinity,
                      height: 52.h,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 280),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [module.primary, module.secondary],
                            begin: AlignmentDirectional.centerStart,
                            end: AlignmentDirectional.centerEnd,
                          ),
                          borderRadius: BorderRadius.circular(14.r),
                          boxShadow: [
                            BoxShadow(
                              color: module.primary.withValues(alpha: 0.34),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          key: const Key('moduleLoginButton'),
                          onPressed: isLoading ? null : () => _submit(cubit),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            disabledBackgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14.r),
                            ),
                          ),
                          child: isLoading
                              ? SizedBox(
                                  width: 22.r,
                                  height: 22.r,
                                  child: const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.2,
                                  ),
                                )
                              : FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        isArabic
                                            ? 'تسجيل الدخول إلى ${module.nameAr}'
                                            : 'Sign in to ${module.nameEn}',
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white,
                                          letterSpacing: 0.2,
                                        ),
                                      ),
                                      Gap(8.w),
                                      Icon(
                                        isArabic
                                            ? Icons.arrow_back_rounded
                                            : Icons.arrow_forward_rounded,
                                        color: Colors.white,
                                        size: 18.r,
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                      ),
                    ),

                    Gap(14.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.verified_user_outlined,
                          size: 13.r,
                          color: AppColor.darkTextColor(context),
                        ),
                        Gap(6.w),
                        Flexible(
                          child: Text(
                            isArabic
                                ? 'اتصال مشفّر 256-bit · الوصول محدود بالوحدة المختارة'
                                : '256-bit encrypted · access scoped to the selected module',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 10.sp,
                              height: 1.35,
                              fontWeight: FontWeight.w500,
                              color: AppColor.darkTextColor(context),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardHeader(
    BuildContext context,
    _ErpModule module,
    bool isArabic,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 280),
          width: 48.r,
          height: 48.r,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [module.primary, module.secondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(14.r),
            boxShadow: [
              BoxShadow(
                color: module.primary.withValues(alpha: 0.3),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Icon(module.icon, color: Colors.white, size: 23.r),
        ),
        Gap(13.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isArabic ? 'الدخول إلى' : 'SIGN IN',
                style: TextStyle(
                  fontSize: 9.5.sp,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.4,
                  color: module.primary,
                ),
              ),
              Gap(3.h),
              Text(
                isArabic ? module.nameAr : 'Sign in to ${module.nameEn}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w900,
                  height: 1.15,
                  color: AppColor.titleFormFiledColor(context),
                ),
              ),
              Gap(4.h),
              Text(
                isArabic
                    ? 'استخدم الحساب المرتبط بهذه الوحدة'
                    : 'Use the account linked to this module',
                style: TextStyle(
                  fontSize: 10.5.sp,
                  fontWeight: FontWeight.w500,
                  height: 1.35,
                  color: AppColor.darkTextColor(context),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _label(BuildContext context, String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 11.5.sp,
        fontWeight: FontWeight.w700,
        color: AppColor.titleFormFiledColor(context),
        letterSpacing: 0.2,
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
//  MODULE PICKER
// ═══════════════════════════════════════════════════════════════════════════
class _ModulePicker extends StatelessWidget {
  final bool isArabic;
  final _ErpModule selected;
  final bool enabled;
  final ValueChanged<_ErpModule> onSelected;

  const _ModulePicker({
    required this.isArabic,
    required this.selected,
    required this.enabled,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      duration: const Duration(milliseconds: 450),
      delay: const Duration(milliseconds: 40),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // ScreenUtil scales every dimension with viewport width, so the
          // layout is designed in a fixed 360-wide space: two columns at most.
          final columns = constraints.maxWidth >= 300 ? 2 : 1;
          final rows = <Widget>[];
          for (var start = 0; start < _erpModules.length; start += columns) {
            final rowModules = _erpModules
                .skip(start)
                .take(columns)
                .toList(growable: false);
            rows.add(
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (var i = 0; i < columns; i++) ...[
                      if (i > 0) SizedBox(width: 12.w),
                      Expanded(
                        child: i < rowModules.length
                            ? _ModuleCard(
                                module: rowModules[i],
                                isArabic: isArabic,
                                selected: rowModules[i].id == selected.id,
                                enabled: enabled,
                                onTap: () => onSelected(rowModules[i]),
                              )
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ],
                ),
              ),
            );
            if (start + columns < _erpModules.length) {
              rows.add(Gap(12.h));
            }
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.layers_rounded,
                    size: 14.r,
                    color: const Color(0xFF3B82F6),
                  ),
                  Gap(7.w),
                  Text(
                    isArabic ? 'الوحدة المطلوبة' : 'SELECT YOUR MODULE',
                    style: TextStyle(
                      fontSize: 9.5.sp,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.3,
                      color: AppColor.darkTextColor(context),
                    ),
                  ),
                ],
              ),
              Gap(12.h),
              ...rows,
              Gap(16.h),
              Wrap(
                spacing: 16.w,
                runSpacing: 8.h,
                children: [
                  _trustItem(
                    context,
                    Icons.shield_outlined,
                    isArabic ? 'وصول محدد بالوحدة' : 'Module-scoped access',
                  ),
                  _trustItem(
                    context,
                    Icons.lock_outline_rounded,
                    isArabic ? 'تشفير 256-bit' : '256-bit encryption',
                  ),
                  _trustItem(
                    context,
                    Icons.bolt_rounded,
                    isArabic ? 'دخول موحّد' : 'Unified sign-in',
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _trustItem(BuildContext context, IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13.r, color: AppColor.darkTextColor(context)),
        Gap(5.w),
        Text(
          label,
          style: TextStyle(
            fontSize: 10.sp,
            fontWeight: FontWeight.w600,
            color: AppColor.darkTextColor(context),
          ),
        ),
      ],
    );
  }
}

class _ModuleCard extends StatefulWidget {
  final _ErpModule module;
  final bool isArabic;
  final bool selected;
  final bool enabled;
  final VoidCallback onTap;

  const _ModuleCard({
    required this.module,
    required this.isArabic,
    required this.selected,
    required this.enabled,
    required this.onTap,
  });

  @override
  State<_ModuleCard> createState() => _ModuleCardState();
}

class _ModuleCardState extends State<_ModuleCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final module = widget.module;
    final selected = widget.selected;
    final isArabic = widget.isArabic;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final borderColor = selected
        ? module.primary
        : _hovered
        ? module.primary.withValues(alpha: 0.45)
        : AppColor.borderColor(context);

    final background = selected
        ? Color.alphaBlend(
            module.primary.withValues(alpha: isDark ? 0.18 : 0.06),
            AppColor.cardColor(context),
          )
        : AppColor.cardColor(context);

    return Semantics(
      button: true,
      selected: selected,
      label: '${module.name(isArabic)} — ${module.subtitle(isArabic)}',
      child: MouseRegion(
        cursor: widget.enabled
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(color: borderColor, width: selected ? 2 : 1),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: module.primary.withValues(
                        alpha: isDark ? 0.24 : 0.14,
                      ),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: const Color(
                        0xFF0F172A,
                      ).withValues(alpha: isDark ? 0.18 : 0.03),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(18.r),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: widget.enabled ? widget.onTap : null,
              borderRadius: BorderRadius.circular(18.r),
              splashColor: module.primary.withValues(alpha: 0.08),
              highlightColor: module.primary.withValues(alpha: 0.04),
              child: Padding(
                padding: EdgeInsets.all(15.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          width: 40.r,
                          height: 40.r,
                          decoration: BoxDecoration(
                            gradient: selected
                                ? LinearGradient(
                                    colors: [module.primary, module.secondary],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  )
                                : null,
                            color: selected
                                ? null
                                : module.primary.withValues(
                                    alpha: isDark ? 0.18 : 0.1,
                                  ),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Icon(
                            module.icon,
                            size: 21.r,
                            color: selected ? Colors.white : module.primary,
                          ),
                        ),
                        const Spacer(),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          width: 20.r,
                          height: 20.r,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: selected
                                ? module.primary
                                : Colors.transparent,
                            border: Border.all(
                              color: selected
                                  ? module.primary
                                  : AppColor.borderColor(context),
                              width: 1.6,
                            ),
                          ),
                          child: selected
                              ? Icon(
                                  Icons.check_rounded,
                                  size: 13.r,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                      ],
                    ),
                    Gap(11.h),
                    Text(
                      module.name(isArabic),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13.5.sp,
                        fontWeight: FontWeight.w800,
                        color: AppColor.titleFormFiledColor(context),
                      ),
                    ),
                    Gap(4.h),
                    Text(
                      module.subtitle(isArabic),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                        height: 1.35,
                        color: AppColor.darkTextColor(context),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
//  HEADER / HERO / BACKGROUND
// ═══════════════════════════════════════════════════════════════════════════
class _TopBar extends StatelessWidget {
  final bool isArabic;
  final VoidCallback onToggleLanguage;

  const _TopBar({required this.isArabic, required this.onToggleLanguage});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (Navigator.of(context).canPop()) ...[
          InkWell(
            onTap: () => Navigator.of(context).maybePop(),
            borderRadius: BorderRadius.circular(20.r),
            child: Container(
              width: 36.r,
              height: 36.r,
              decoration: BoxDecoration(
                color: AppColor.cardColor(context),
                shape: BoxShape.circle,
                border: Border.all(color: AppColor.borderColor(context)),
              ),
              child: Icon(
                Icons.arrow_back_rounded,
                size: 17.r,
                color: AppColor.titleFormFiledColor(context),
              ),
            ),
          ),
          Gap(12.w),
        ],
        _BrandMark(isArabic: isArabic),
        const Spacer(),
        InkWell(
          onTap: onToggleLanguage,
          borderRadius: BorderRadius.circular(30.r),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: AppColor.cardColor(context),
              borderRadius: BorderRadius.circular(30.r),
              border: Border.all(color: AppColor.borderColor(context)),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0F172A).withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.language_rounded,
                  size: 14.r,
                  color: const Color(0xFF3B82F6),
                ),
                Gap(6.w),
                Text(
                  isArabic ? 'English' : 'العربية',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColor.titleFormFiledColor(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _BrandMark extends StatelessWidget {
  final bool isArabic;

  const _BrandMark({required this.isArabic});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 40.r,
          height: 40.r,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(11.r),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1E40AF).withValues(alpha: 0.26),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Icon(Icons.hub_rounded, color: Colors.white, size: 20.r),
        ),
        Gap(11.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'DELTA ASG',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.1,
                color: AppColor.titleFormFiledColor(context),
              ),
            ),
            Text(
              isArabic ? 'منصة ERP المؤسسية' : 'Enterprise ERP Suite',
              style: TextStyle(
                fontSize: 9.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF3B82F6),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _Hero extends StatelessWidget {
  final bool isArabic;

  const _Hero({required this.isArabic});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
          decoration: BoxDecoration(
            color: const Color(0xFFDBEAFE),
            borderRadius: BorderRadius.circular(6.r),
          ),
          child: Text(
            isArabic ? 'بوابة الوحدات' : 'MODULE PORTAL',
            style: TextStyle(
              fontSize: 9.sp,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.4,
              color: const Color(0xFF1E40AF),
            ),
          ),
        ),
        Gap(13.h),
        Text(
          isArabic
              ? 'اختر وحدتك،\nثم سجّل الدخول'
              : 'Choose your module,\nthen sign in',
          style: TextStyle(
            fontSize: 28.sp,
            fontWeight: FontWeight.w900,
            height: 1.12,
            letterSpacing: -0.7,
            color: AppColor.titleFormFiledColor(context),
          ),
        ),
        Gap(10.h),
        Text(
          isArabic
              ? 'منصة واحدة، خمس مساحات عمل. اختر الوحدة التي تعمل عليها وسجّل الدخول بالحساب المرتبط بها.'
              : 'One platform, five workspaces. Pick the module you work in and sign in with the account linked to it.',
          style: TextStyle(
            fontSize: 12.5.sp,
            height: 1.55,
            fontWeight: FontWeight.w500,
            color: AppColor.darkTextColor(context),
          ),
        ),
      ],
    );
  }
}

class _PortalBackground extends StatelessWidget {
  const _PortalBackground();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? const [Color(0xFF0B1220), Color(0xFF0F172A)]
                    : const [Color(0xFFF8FAFC), Color(0xFFEDF3FF)],
              ),
            ),
          ),
        ),
        Positioned(
          top: -150,
          right: -130,
          child: _glow(
            size: 440,
            color: const Color(0xFF3B82F6),
            opacity: isDark ? 0.22 : 0.15,
          ),
        ),
        Positioned(
          bottom: -180,
          left: -150,
          child: _glow(
            size: 470,
            color: const Color(0xFF10B981),
            opacity: isDark ? 0.15 : 0.1,
          ),
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(
              painter: _DotGridPainter(
                color: isDark ? Colors.white : const Color(0xFF0F172A),
                opacity: isDark ? 0.05 : 0.035,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _glow({
    required double size,
    required Color color,
    required double opacity,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color.withValues(alpha: opacity),
            color.withValues(alpha: 0),
          ],
        ),
      ),
    );
  }
}

class _DotGridPainter extends CustomPainter {
  final Color color;
  final double opacity;

  const _DotGridPainter({required this.color, required this.opacity});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color.withValues(alpha: opacity);
    const spacing = 26.0;
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DotGridPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.opacity != opacity;
  }
}

// ═══════════════════════════════════════════════════════════════════════════
//  MODULE DEFINITIONS
// ═══════════════════════════════════════════════════════════════════════════
class _ErpModule {
  final String id;
  final String nameEn;
  final String nameAr;
  final String subtitleEn;
  final String subtitleAr;
  final IconData icon;
  final Color primary;
  final Color secondary;

  const _ErpModule({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.subtitleEn,
    required this.subtitleAr,
    required this.icon,
    required this.primary,
    required this.secondary,
  });

  String name(bool isArabic) => isArabic ? nameAr : nameEn;

  String subtitle(bool isArabic) => isArabic ? subtitleAr : subtitleEn;
}

const List<_ErpModule> _erpModules = [
  _ErpModule(
    id: 'accounting',
    nameEn: 'Accounting',
    nameAr: 'المحاسبة',
    subtitleEn: 'Ledger, journals & financial reports',
    subtitleAr: 'دفتر الأستاذ والقيود والتقارير المالية',
    icon: Icons.account_balance_rounded,
    primary: Color(0xFF047857),
    secondary: Color(0xFF059669),
  ),
  _ErpModule(
    id: 'payroll',
    nameEn: 'Payroll',
    nameAr: 'الرواتب',
    subtitleEn: 'Payroll runs, payslips & benefits',
    subtitleAr: 'مسيّرات الرواتب وقسائم الدفع والمزايا',
    icon: Icons.payments_rounded,
    primary: Color(0xFF6D28D9),
    secondary: Color(0xFF7C3AED),
  ),
  _ErpModule(
    id: 'sales',
    nameEn: 'Sales',
    nameAr: 'المبيعات',
    subtitleEn: 'Quotations, orders & customer invoices',
    subtitleAr: 'عروض الأسعار والطلبات وفواتير العملاء',
    icon: Icons.point_of_sale_rounded,
    primary: Color(0xFF1D4ED8),
    secondary: Color(0xFF2563EB),
  ),
  _ErpModule(
    id: 'purchasing',
    nameEn: 'Purchasing',
    nameAr: 'المشتريات',
    subtitleEn: 'Vendors, purchase orders & bills',
    subtitleAr: 'الموردون وأوامر الشراء وفواتير الموردين',
    icon: Icons.shopping_cart_checkout_rounded,
    primary: Color(0xFFC2410C),
    secondary: Color(0xFFEA580C),
  ),
  _ErpModule(
    id: 'inventory',
    nameEn: 'Inventory',
    nameAr: 'المخزون',
    subtitleEn: 'Stock levels, transfers & warehouses',
    subtitleAr: 'مستويات المخزون والتحويلات والمستودعات',
    icon: Icons.inventory_2_rounded,
    primary: Color(0xFF0F766E),
    secondary: Color(0xFF0D9488),
  ),
];
