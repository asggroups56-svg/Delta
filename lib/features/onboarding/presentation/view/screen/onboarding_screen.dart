
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/routes/routes_name.dart';
import 'package:my_template/core/theme/app_colors.dart';
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

  List<OnboardingItemModel> _getItems() => [
        OnboardingItemModel(
          titleKey: AppLocaleKey.onboardingTitle1,
          subtitleKey: AppLocaleKey.onboardingSubtitle1,
          accentColor: const Color(0xFF0D9488), // Emerald Teal Accent
          type: OnboardingType.allInOne,
        ),
        OnboardingItemModel(
          titleKey: AppLocaleKey.onboardingTitle2,
          subtitleKey: AppLocaleKey.onboardingSubtitle2,
          accentColor: const Color(0xFF0284C7), // Ocean Blue Accent
          type: OnboardingType.analytics,
        ),
        OnboardingItemModel(
          titleKey: AppLocaleKey.onboardingTitle3,
          subtitleKey: AppLocaleKey.onboardingSubtitle3,
          accentColor: const Color(0xFF059669), // Emerald Green Accent
          type: OnboardingType.automation,
        ),
      ];

  void _onNext() {
    final items = _getItems();
    if (_currentIndex < items.length - 1) {
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

  Future<void> _toggleLanguage() async {
    if (context.locale.languageCode == 'ar') {
      await context.setLocale(const Locale('en'));
    } else {
      await context.setLocale(const Locale('ar'));
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = _getItems();
    final currentItem = items[_currentIndex];

    return Scaffold(
      backgroundColor: AppColor.scaffoldColor(context),
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar with Brand, Language Switcher, and Skip Button
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
                        AppLocaleKey.appName.tr(),
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                          color: AppColor.titleFormFiledColor(context),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      // Language Toggle Button
                      InkWell(
                        onTap: _toggleLanguage,
                        borderRadius: BorderRadius.circular(20.r),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.w, vertical: 6.h),
                          decoration: BoxDecoration(
                            color: currentItem.accentColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(
                              color: currentItem.accentColor.withValues(alpha: 0.25),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.language_rounded,
                                size: 16.r,
                                color: currentItem.accentColor,
                              ),
                              Gap(6.w),
                              Text(
                                AppLocaleKey.langSwitchLabel.tr(),
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                  color: currentItem.accentColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Gap(8.w),
                      if (_currentIndex < items.length - 1)
                        TextButton(
                          onPressed: _navigateToLogin,
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                horizontal: 14.w, vertical: 6.h),
                            backgroundColor:
                                currentItem.accentColor.withValues(alpha: 0.08),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                          ),
                          child: Text(
                            AppLocaleKey.skip.tr(),
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: currentItem.accentColor,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            // PageView Slider
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: items.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return PageSlideWidget(item: items[index]);
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
                      items.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: EdgeInsets.only(right: 6.w),
                        height: 8.h,
                        width: _currentIndex == index ? 28.w : 8.w,
                        decoration: BoxDecoration(
                          color: _currentIndex == index
                              ? currentItem.accentColor
                              : currentItem.accentColor.withValues(alpha: 0.2),
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
                              _currentIndex == items.length - 1 ? 28.w : 22.w,
                          vertical: 14.h,
                        ),
                        backgroundColor: currentItem.accentColor,
                        elevation: 4,
                        shadowColor: currentItem.accentColor.withValues(alpha: 0.4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _currentIndex == items.length - 1
                                ? AppLocaleKey.startNow.tr()
                                : AppLocaleKey.next.tr(),
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColor.whiteColor(context),
                            ),
                          ),
                          Gap(8.w),
                          Icon(
                            _currentIndex == items.length - 1
                                ? Icons.rocket_launch_rounded
                                : (context.locale.languageCode == 'ar'
                                    ? Icons.arrow_back_rounded
                                    : Icons.arrow_forward_rounded),
                            size: 18.r,
                            color: AppColor.whiteColor(context),
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
}

