import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Centralized shadow definitions to avoid repetition
class AppShadows {
  /// Small shadow for subtle depth
  static List<BoxShadow> sm = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.1),
      blurRadius: 4.r,
      offset: const Offset(0, 2),
      spreadRadius: 0,
    ),
  ];

  /// Medium shadow for standard UI elements
  static List<BoxShadow> md = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.15),
      blurRadius: 8.r,
      offset: const Offset(0, 4),
      spreadRadius: 0,
    ),
  ];

  /// Large shadow for elevated components
  static List<BoxShadow> lg = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.2),
      blurRadius: 16.r,
      offset: const Offset(0, 8),
      spreadRadius: 0,
    ),
  ];

  /// Extra large shadow for prominent elements
  static List<BoxShadow> xl = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.25),
      blurRadius: 24.r,
      offset: const Offset(0, 12),
      spreadRadius: 0,
    ),
  ];

  /// Header shadow - darker and more pronounced
  static List<BoxShadow> header = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.35),
      blurRadius: 16.r,
      offset: const Offset(0, 6),
    ),
  ];

  /// Card shadow with offset
  static List<BoxShadow> card = [
    BoxShadow(
      color: const Color(0x3FD3D1D8),
      blurRadius: 22.5,
      offset: Offset(11.25.w, 11.25.h),
      spreadRadius: 0,
    ),
  ];

  /// Floating action button shadow
  static List<BoxShadow> fab = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.3),
      blurRadius: 12.r,
      offset: const Offset(0, 6),
      spreadRadius: 2,
    ),
  ];

  /// Bottom sheet shadow
  static List<BoxShadow> bottomSheet = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.2),
      blurRadius: 20.r,
      offset: const Offset(0, -4),
      spreadRadius: 0,
    ),
  ];

  /// Hover state shadow
  static List<BoxShadow> hover = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.2),
      blurRadius: 12.r,
      offset: const Offset(0, 6),
      spreadRadius: 0,
    ),
  ];

  /// Pressed state shadow (reduced depth)
  static List<BoxShadow> pressed = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.1),
      blurRadius: 4.r,
      offset: const Offset(0, 2),
      spreadRadius: 0,
    ),
  ];

  /// Double shadow effect
  static List<BoxShadow> doubleShadow = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.1),
      blurRadius: 2.r,
      offset: const Offset(0, 1),
    ),
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.1),
      blurRadius: 8.r,
      offset: const Offset(0, 4),
    ),
  ];

  /// Elevated surface shadow (for dialog, etc)
  static List<BoxShadow> elevated = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.15),
      blurRadius: 16.r,
      offset: const Offset(0, 4),
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.1),
      blurRadius: 8.r,
      offset: const Offset(0, 2),
      spreadRadius: 0,
    ),
  ];
}
