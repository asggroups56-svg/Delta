import 'dart:ui';

enum OnboardingType { allInOne, analytics, automation }

class OnboardingItemModel {
  final String titleKey;
  final String subtitleKey;
  final Color accentColor;
  final OnboardingType type;

  OnboardingItemModel({
    required this.titleKey,
    required this.subtitleKey,
    required this.accentColor,
    required this.type,
  });
}
