import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Centralized decoration utilities to avoid repeating BoxDecoration patterns
class AppDecorations {
  /// Basic rounded container decoration
  static BoxDecoration roundedContainer({
    Color? backgroundColor,
    double radius = 12,
    Border? border,
    List<BoxShadow>? boxShadow,
  }) {
    return BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(radius),
      border: border,
      boxShadow: boxShadow,
    );
  }

  /// Rounded container with gradient
  static BoxDecoration roundedGradient({
    required Gradient gradient,
    double radius = 12,
    Border? border,
    List<BoxShadow>? boxShadow,
  }) {
    return BoxDecoration(
      gradient: gradient,
      borderRadius: BorderRadius.circular(radius),
      border: border,
      boxShadow: boxShadow,
    );
  }

  /// Card-style decoration (common in dashboard)
  static BoxDecoration cardDecoration({
    Color backgroundColor = AppColors.darkCardBackground,
    double radius = 16,
    List<BoxShadow>? boxShadow,
  }) {
    return BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(radius),
      boxShadow: boxShadow,
    );
  }

  /// Circular decoration for avatars/badges
  static BoxDecoration circularDecoration({
    Color? backgroundColor,
    Border? border,
  }) {
    return BoxDecoration(
      color: backgroundColor,
      shape: BoxShape.circle,
      border: border,
    );
  }

  /// Gradient circular decoration
  static BoxDecoration circularGradient({
    required Gradient gradient,
    Border? border,
  }) {
    return BoxDecoration(
      gradient: gradient,
      shape: BoxShape.circle,
      border: border,
    );
  }

  /// Header decoration with gradient
  static BoxDecoration headerDecoration({
    required Gradient gradient,
    double radius = 20,
    List<BoxShadow>? boxShadow,
    Border? border,
  }) {
    return BoxDecoration(
      gradient: gradient,
      borderRadius: BorderRadius.vertical(bottom: Radius.circular(radius)),
      boxShadow: boxShadow,
      border: border,
    );
  }

  /// Form field decoration
  static BoxDecoration formFieldDecoration({
    Color backgroundColor = const Color(0xFFF8FAFC),
    double radius = 8,
    Border? border,
  }) {
    return BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(radius),
      border: border,
    );
  }

  /// Input field border
  static OutlineInputBorder inputBorder({
    double radius = 8,
    Color borderColor = const Color(0xFFE2E8F0),
    double borderWidth = 1.0,
  }) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius),
      borderSide: BorderSide(color: borderColor, width: borderWidth),
    );
  }

  /// Glass morphism effect (frosted glass)
  static BoxDecoration glassmorphism({
    required Color backgroundColor,
    double radius = 20,
    double opacity = 0.1,
  }) {
    return BoxDecoration(
      color: backgroundColor.withValues(alpha: opacity),
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(
        color: Colors.white.withValues(alpha: 0.2),
        width: 1.5,
      ),
    );
  }

  /// Divider decoration with gradient
  static BoxDecoration gradientDivider({
    required Gradient gradient,
    double height = 1,
  }) {
    return BoxDecoration(
      gradient: gradient,
    );
  }

  /// Dashboard header with dark gradient
  static BoxDecoration dashboardHeaderDecoration() {
    return headerDecoration(
      gradient: AppGradients.dashboardHeader,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.35),
          blurRadius: 16.r,
          offset: const Offset(0, 6),
        ),
      ],
      border: Border(
        bottom: BorderSide(
          color: Colors.white.withValues(alpha: 0.08),
          width: 1.2,
        ),
      ),
    );
  }

  /// Bottom sheet decoration
  static BoxDecoration bottomSheetDecoration({
    Color backgroundColor = AppColors.darkCardBackground,
    double radius = 20,
  }) {
    return BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.vertical(top: Radius.circular(radius)),
    );
  }
}

// Constant app colors for Ocean Sapphire & Deep Slate dark theme
class AppColors {
  static const Color darkBackground = Color(0xFF0A0F1D);
  static const Color darkCardBackground = Color(0xFF131C2E);
  static const Color darkSurface = Color(0xFF1E293B);
}

/// Centralized gradient definitions to avoid repetition
class AppGradients {
  /// Dashboard header gradient (Modern Deep Navy)
  static const LinearGradient dashboardHeader = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF0F172A),
      Color(0xFF0A0F1D),
    ],
  );

  /// Primary gradient (Ocean Sapphire to Vibrant Sky)
  static const LinearGradient primary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF0284C7),
      Color(0xFF38BDF8),
    ],
  );

  /// Accent gradient (Deep Sapphire to Ice Cyan)
  static const LinearGradient accent = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF0369A1),
      Color(0xFF38BDF8),
    ],
  );

  /// Purple/Blue accent gradient
  static const LinearGradient purpleAccent = LinearGradient(
    colors: [
      Color(0xFF0284C7),
      Color(0xFF0EA5E9),
    ],
  );

  /// Emerald to Cyan gradient
  static const LinearGradient emeraldPurple = LinearGradient(
    colors: [
      Color(0xFF0EA5E9),
      Color(0xFF38BDF8),
    ],
  );

  /// Profile avatar gradient
  static const LinearGradient avatarGradient = LinearGradient(
    colors: [
      Color(0xFF0284C7),
      Color(0xFF38BDF8),
    ],
  );

  /// Light gradient
  static const LinearGradient light = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFFFFFFF),
      Color(0xFFF8FAFC),
    ],
  );
}
