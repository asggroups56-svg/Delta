import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Centralized padding constants to avoid repetition across the app
class AppPadding {
  // Single value paddings
  static final double xs = 4.w;
  static final double sm = 8.w;
  static final double md = 12.w;
  static final double lg = 16.w;
  static final double xl = 20.w;
  static final double xxl = 24.w;
  static final double xxxl = 32.w;

  // Symmetric paddings
  static EdgeInsets horizontalSm = EdgeInsets.symmetric(horizontal: 8.w);
  static EdgeInsets horizontalMd = EdgeInsets.symmetric(horizontal: 12.w);
  static EdgeInsets horizontalLg = EdgeInsets.symmetric(horizontal: 16.w);
  static EdgeInsets horizontalXl = EdgeInsets.symmetric(horizontal: 20.w);

  static EdgeInsets verticalSm = EdgeInsets.symmetric(vertical: 8.h);
  static EdgeInsets verticalMd = EdgeInsets.symmetric(vertical: 12.h);
  static EdgeInsets verticalLg = EdgeInsets.symmetric(vertical: 16.h);
  static EdgeInsets verticalXl = EdgeInsets.symmetric(vertical: 20.h);

  // All sides padding
  static EdgeInsets allSm = EdgeInsets.all(8.w);
  static EdgeInsets allMd = EdgeInsets.all(12.w);
  static EdgeInsets allLg = EdgeInsets.all(16.w);
  static EdgeInsets allXl = EdgeInsets.all(20.w);
  static EdgeInsets allXxl = EdgeInsets.all(24.w);

  // Combined paddings
  static EdgeInsets symmetricMd =
      EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h);
  static EdgeInsets symmetricLg =
      EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h);
  static EdgeInsets symmetricXl =
      EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h);

  // Top padding
  static EdgeInsets topSm = EdgeInsets.only(top: 8.h);
  static EdgeInsets topMd = EdgeInsets.only(top: 12.h);
  static EdgeInsets topLg = EdgeInsets.only(top: 16.h);
  static EdgeInsets topXl = EdgeInsets.only(top: 20.h);

  // Bottom padding
  static EdgeInsets bottomSm = EdgeInsets.only(bottom: 8.h);
  static EdgeInsets bottomMd = EdgeInsets.only(bottom: 12.h);
  static EdgeInsets bottomLg = EdgeInsets.only(bottom: 16.h);
  static EdgeInsets bottomXl = EdgeInsets.only(bottom: 20.h);

  // Left padding
  static EdgeInsets leftSm = EdgeInsets.only(left: 8.w);
  static EdgeInsets leftMd = EdgeInsets.only(left: 12.w);
  static EdgeInsets leftLg = EdgeInsets.only(left: 16.w);
  static EdgeInsets leftXl = EdgeInsets.only(left: 20.w);

  // Right padding
  static EdgeInsets rightSm = EdgeInsets.only(right: 8.w);
  static EdgeInsets rightMd = EdgeInsets.only(right: 12.w);
  static EdgeInsets rightLg = EdgeInsets.only(right: 16.w);
  static EdgeInsets rightXl = EdgeInsets.only(right: 20.w);

  // Common widget paddings
  static EdgeInsets screenPadding = EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h);
  static EdgeInsets cardPadding = EdgeInsets.all(16.w);
  static EdgeInsets bottomSheetPadding = EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h);
  static EdgeInsets buttonPadding = EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h);
  static EdgeInsets dialogPadding = EdgeInsets.all(20.w);
}

/// Centralized spacing gaps
class AppSpacing {
  static final double xs = 4.h;
  static final double sm = 8.h;
  static final double md = 12.h;
  static final double lg = 16.h;
  static final double xl = 20.h;
  static final double xxl = 24.h;
  static final double xxxl = 32.h;
}

/// Centralized border radius values
class AppRadius {
  static final double xs = 4.r;
  static final double sm = 8.r;
  static final double md = 12.r;
  static final double lg = 16.r;
  static final double xl = 20.r;
  static final double xxl = 24.r;
  static final double circle = 50.r;
}
