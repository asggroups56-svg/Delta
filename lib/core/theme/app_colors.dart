import 'package:flutter/material.dart';

import 'app_theme.dart';

class AppColor {
  // ── Primary Brand: Royal Delta Navy & Sapphire ──────────────────────────
  static Color primaryColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xFF1E40AF), // Crisp Royal Navy Blue
      dark: const Color(0xFF3B82F6),  // Bright Royal Blue
      listen: listen,
    );
  }

  // ── Secondary Accent: Ocean Cyan ─────────────────────────────────────────
  static Color secondAppColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xFF0284C7), // Sapphire Blue
      dark: const Color(0xFF38BDF8),  // Sky Cyan
      listen: listen,
    );
  }

  // ── Borders ──────────────────────────────────────────────────────────────
  static Color borderColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xFFE2E8F0), // Clean Crisp Slate Border
      dark: const Color(0xFF334155),
      listen: listen,
    );
  }

  // ── Scaffold Background: Clean Modern Light Slate ────────────────────────
  static Color scaffoldColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xFFF1F5F9), // Modern Crisp Slate Background
      dark: const Color(0xFF0F172A),  // Deep Obsidian Navy
      listen: listen,
    );
  }

  // ── Card & Container Background ──────────────────────────────────────────
  static Color cardColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xFFFFFFFF), // Pure White Card
      dark: const Color(0xFF1E293B),  // Elevated Navy Card
      listen: listen,
    );
  }

  // ── Form Field Fill ──────────────────────────────────────────────────────
  static Color textFormFillColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xFFFFFFFF), // Pure White
      dark: const Color(0xFF1E293B),
      listen: listen,
    );
  }

  // ── Hint Text ────────────────────────────────────────────────────────────
  static Color hintColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xFF94A3B8), // Slate 400
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

  static Color deepColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xFF0F172A),
      dark: const Color(0xFF0A0F1D),
      listen: listen,
    );
  }

  static Color deepIndigoColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xFF1E40AF),
      dark: const Color(0xFF2563EB),
      listen: listen,
    );
  }

  static Color accentPurpleColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xFF2563EB),
      dark: const Color(0xFF60A5FA),
      listen: listen,
    );
  }

  static Color accentIndigoColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xFF0284C7),
      dark: const Color(0xFF38BDF8),
      listen: listen,
    );
  }

  // ── Dark/Muted Text (Secondary text, subtitles, descriptions) ────────────
  static Color darkTextColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xFF64748B), // Slate 500 (Clean, clear muted text)
      dark: const Color(0xFF94A3B8),
      listen: listen,
    );
  }

  static Color greyColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xFF64748B),
      dark: const Color(0xFF94A3B8),
      listen: listen,
    );
  }

  // ── Primary Headings & Field Titles (High Contrast Dark Slate) ───────────
  static Color titleFormFiledColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xFF0F172A), // Crisp Dark Slate 900 (High contrast)
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

  // ── Form Field Borders ───────────────────────────────────────────────────
  static Color textFormBorderColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xFFCBD5E1), // Slate 300 (Visible, clean border)
      dark: const Color(0xFF334155),
      listen: listen,
    );
  }

  // ── Text input typed text color ──────────────────────────────────────────
  static Color textFormColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xFF0F172A), // Crisp Dark Slate 900
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

  // ── Static Palette Constants ──────────────────────────────────────────────
  static const Color royalNavy          = Color(0xFF1E40AF); // Primary Brand Navy
  static const Color deltaBlue          = Color(0xFF2563EB); // Vibrant Delta Blue
  static const Color oceanBlue          = Color(0xFF0284C7); // Sapphire
  static const Color skyBlue            = Color(0xFF0EA5E9); // Sky Accent
  static const Color lightBg            = Color(0xFFF1F5F9); // Light Slate Background
  static const Color lightCard          = Color(0xFFFFFFFF); // Clean White Card
  static const Color darkBackground     = Color(0xFF0F172A); // Midnight Navy (Dark mode)
  static const Color darkCardBackground = Color(0xFF1E293B); // Slate Card (Dark mode)
  static const Color textMain           = Color(0xFF0F172A); // Main Heading Dark Text
  static const Color textMuted          = Color(0xFF64748B); // Subtitle Slate Text
  static const Color emeraldTeal        = Color(0xFF10B981); // Emerald Success
  static const Color mintTeal           = Color(0xFF059669); // Deep Mint
  static const Color warningOrange      = Color(0xFFD97706); // Amber Alert
  static const Color roseDanger         = Color(0xFFDC2626); // Crimson Red
  
  // ── Restored Aliases for Backward Compatibility ────────────────────────────
  static const Color royalIndigo    = royalNavy;
  static const Color cyanLight      = skyBlue;
  static const Color purpleAccent   = deltaBlue;
  static const Color electricCyan   = oceanBlue;
  static const Color indigoLight    = Color(0xFF3B82F6);
  static const Color darkSurface    = darkCardBackground;
}
