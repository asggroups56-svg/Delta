import 'package:flutter/material.dart';

import 'app_theme.dart';

class AppColor {
  // Primary App Color: Royal Indigo
  static Color primaryColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xFF4F46E5),
      dark: const Color(0xFF6366F1),
      listen: listen,
    );
  }

  // Secondary App Color: Electric Cyan / Sky
  static Color secondAppColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xFF06B6D4),
      dark: const Color(0xFF0EA5E9),
      listen: listen,
    );
  }

  static Color borderColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xFFE2E8F0),
      dark: const Color(0xFF334155),
      listen: listen,
    );
  }

  static Color scaffoldColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xFFF8FAFC),
      dark: const Color(0xFF090D16),
      listen: listen,
    );
  }

  static Color textFormFillColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xFFF1F5F9),
      dark: const Color(0xFF111827),
      listen: listen,
    );
  }

  static Color hintColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xFF94A3B8),
      dark: const Color(0xFF64748B),
      listen: listen,
    );
  }

  static Color backColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: Colors.black,
      dark: Colors.black,
      listen: listen,
    );
  }

  // Dark Background Base: Deep Midnight Obsidian
  static Color deepColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xFF0B1120),
      dark: const Color(0xFF090D16),
      listen: listen,
    );
  }

  // Primary Gradient Indigo
  static Color deepIndigoColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xFF4F46E5),
      dark: const Color(0xFF4F46E5),
      listen: listen,
    );
  }

  // Accent Color 1: Royal Indigo / Violet
  static Color accentPurpleColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xFF6366F1),
      dark: const Color(0xFF6366F1),
      listen: listen,
    );
  }

  // Accent Color 2: Electric Cyan
  static Color accentIndigoColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xFF06B6D4),
      dark: const Color(0xFF06B6D4),
      listen: listen,
    );
  }

  static Color darkTextColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xFF64748B),
      dark: const Color(0xFF94A3B8),
      listen: listen,
    );
  }

  static Color greyColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xFF94A3B8),
      dark: const Color(0xFF64748B),
      listen: listen,
    );
  }

  static Color titleFormFiledColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xFF0F172A),
      dark: const Color(0xFFF8FAFC),
      listen: listen,
    );
  }

  static Color whiteColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xFFFFFFFF),
      dark: const Color(0xFFFFFFFF),
      listen: listen,
    );
  }

  static Color textFormBorderColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xFFE2E8F0),
      dark: const Color(0xFF1E293B),
      listen: listen,
    );
  }

  static Color textFormColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xFF0F172A),
      dark: const Color(0xFFF8FAFC),
      listen: listen,
    );
  }

  static Color appBarTextColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xFF0F172A),
      dark: const Color(0xFFF8FAFC),
      listen: listen,
    );
  }

  static Color appBarColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xFFFFFFFF),
      dark: const Color(0xFF0F172A),
      listen: listen,
    );
  }

  static Color buttonTextColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xFFFFFFFF),
      dark: const Color(0xFFFFFFFF),
      listen: listen,
    );
  }

  // ── Static Constant Colors (Modern Enterprise Dark) ────────────────────────
  static const Color darkBackground     = Color(0xFF090D16); // Midnight Obsidian
  static const Color darkCardBackground = Color(0xFF111827); // Deep Slate Card
  static const Color darkSurface        = Color(0xFF1E293B); // Elevated Slate
  static const Color royalIndigo        = Color(0xFF4F46E5); // Primary Royal Indigo
  static const Color indigoLight        = Color(0xFF6366F1); // Vivid Indigo
  static const Color electricCyan       = Color(0xFF06B6D4); // Electric Cyan Accent
  static const Color cyanLight          = Color(0xFF38BDF8); // Sky Cyan
  static const Color emeraldTeal        = Color(0xFF10B981); // Emerald (Success/Profit)
  static const Color mintTeal           = Color(0xFF34D399); // Mint
  static const Color oceanBlue          = Color(0xFF0284C7); // Sapphire
  static const Color skyBlue            = Color(0xFF38BDF8); // Soft Sky
  static const Color purpleAccent       = Color(0xFF7C3AED); // Royal Violet
  static const Color warningOrange      = Color(0xFFF59E0B); // Enterprise Amber
  static const Color roseDanger         = Color(0xFFF43F5E); // Crisp Rose
  static const Color slateMuted         = Color(0xFF94A3B8); // Muted Text
  static const Color slateSubtle        = Color(0xFF64748B); // Border/Subtle
}
