import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/routes/routes_name.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_locale_key.dart';
import 'package:my_template/core/utils/navigator_methods.dart';
import 'package:my_template/features/onboarding/data/model/on_boarding_type.dart';
import 'package:my_template/features/onboarding/presentation/view/widget/page_slide_widget.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  static const List<OnboardingItemModel> _items = [
    OnboardingItemModel(
      titleKey: AppLocaleKey.onboardingTitle1,
      subtitleKey: AppLocaleKey.onboardingSubtitle1,
      accentColor: AppColor.oceanBlue,
      type: OnboardingType.allInOne,
    ),
    OnboardingItemModel(
      titleKey: AppLocaleKey.onboardingTitle2,
      subtitleKey: AppLocaleKey.onboardingSubtitle2,
      accentColor: AppColor.emeraldTeal,
      type: OnboardingType.analytics,
    ),
    OnboardingItemModel(
      titleKey: AppLocaleKey.onboardingTitle3,
      subtitleKey: AppLocaleKey.onboardingSubtitle3,
      accentColor: Color(0xFF7C3AED),
      type: OnboardingType.automation,
    ),
  ];

  bool get _isArabic => context.locale.languageCode == 'ar';

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
    NavigatorMethods.pushReplacementNamed(
      context,
      RoutesName.accountAccessScreen,
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentItem = _items[_currentIndex];

    return Scaffold(
      backgroundColor: AppColor.scaffoldColor(context),
      body: Stack(
        children: [
          // Soft brand glow that follows the current slide accent.
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 450),
                curve: Curves.easeOut,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: const Alignment(0, -0.9),
                    radius: 1.15,
                    colors: [
                      currentItem.accentColor.withValues(alpha: 0.16),
                      AppColor.scaffoldColor(context),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Short, wide screens (phone landscape) use a side-by-side
                // layout instead of stacking the artwork above the copy.
                final isCompact =
                    constraints.maxHeight < 560 &&
                    constraints.maxWidth > constraints.maxHeight;

                return Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: isCompact ? 900 : 520,
                    ),
                    child: Column(
                      children: [
                        _buildTopBar(),
                        Expanded(
                          child: PageView.builder(
                            controller: _pageController,
                            itemCount: _items.length,
                            onPageChanged: (index) {
                              setState(() => _currentIndex = index);
                            },
                            itemBuilder: (context, index) {
                              return PageSlideWidget(
                                item: _items[index],
                                isCompact: isCompact,
                              );
                            },
                          ),
                        ),
                        _buildBottomBar(currentItem, isCompact: isCompact),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    final isLastPage = _currentIndex == _items.length - 1;

    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 4.h),
      child: Row(
        children: [
          // Brand mark
          Container(
            width: 40.r,
            height: 40.r,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1E40AF).withValues(alpha: 0.28),
                  blurRadius: 14,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Icon(Icons.hub_rounded, color: Colors.white, size: 21.r),
          ),
          Gap(11.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppLocaleKey.appName.tr(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.bodyMedium(context).copyWith(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.9,
                    color: AppColor.titleFormFiledColor(context),
                  ),
                ),
                Gap(1.h),
                Text(
                  AppLocaleKey.appSubtitle.tr(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.bodySmall(context).copyWith(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                    color: AppColor.primaryColor(context),
                  ),
                ),
              ],
            ),
          ),
          Gap(8.w),
          // Skip is hidden on the last page, where the CTA is the only way out.
          AnimatedOpacity(
            duration: const Duration(milliseconds: 250),
            opacity: isLastPage ? 0 : 1,
            child: IgnorePointer(
              ignoring: isLastPage,
              child: TextButton(
                onPressed: _navigateToLogin,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 9.h,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: StadiumBorder(
                    side: BorderSide(color: AppColor.borderColor(context)),
                  ),
                ),
                child: Text(
                  AppLocaleKey.skip.tr(),
                  style: AppTextStyle.bodySmall(context).copyWith(
                    fontSize: 12.5.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColor.titleFormFiledColor(context),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(
    OnboardingItemModel currentItem, {
    required bool isCompact,
  }) {
    final isLastPage = _currentIndex == _items.length - 1;
    final accent = currentItem.accentColor;

    return Padding(
      padding: isCompact
          ? EdgeInsets.fromLTRB(24.w, 6.h, 24.w, 10.h)
          : EdgeInsets.fromLTRB(24.w, 10.h, 24.w, 18.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Page indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _items.length,
              (index) => _buildIndicator(index, accent),
            ),
          ),
          Gap(isCompact ? 10.h : 18.h),

          // Primary CTA
          Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isCompact ? 440 : double.infinity,
              ),
              child: SizedBox(
                width: double.infinity,
                height: isCompact ? 48.h : 56.h,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeOut,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        accent,
                        Color.lerp(accent, AppColor.royalNavy, 0.45) ?? accent,
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: [
                      BoxShadow(
                        color: accent.withValues(alpha: 0.35),
                        blurRadius: 20,
                        offset: const Offset(0, 9),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: _onNext,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      elevation: 0,
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 220),
                            child: Text(
                              isLastPage
                                  ? AppLocaleKey.startNow.tr()
                                  : AppLocaleKey.next.tr(),
                              key: ValueKey('cta_label_$isLastPage'),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.3,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Gap(10.w),
                        Container(
                          width: 26.r,
                          height: 26.r,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.18),
                            shape: BoxShape.circle,
                          ),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 220),
                            child: Icon(
                              isLastPage
                                  ? Icons.rocket_launch_rounded
                                  : (_isArabic
                                        ? Icons.arrow_back_rounded
                                        : Icons.arrow_forward_rounded),
                              key: ValueKey('cta_icon_$isLastPage'),
                              size: 15.r,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicator(int index, Color accent) {
    final isActive = _currentIndex == index;

    return Semantics(
      label: '${index + 1} / ${_items.length}',
      selected: isActive,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        height: 8.h,
        width: isActive ? 26.w : 8.w,
        decoration: BoxDecoration(
          color: isActive ? accent : accent.withValues(alpha: 0.22),
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: accent.withValues(alpha: 0.45),
                    blurRadius: 8,
                  ),
                ]
              : null,
        ),
      ),
    );
  }
}
