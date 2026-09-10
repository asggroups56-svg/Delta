import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/utils/app_locale_key.dart';
import 'package:my_template/features/home/presentation/view/widget/ai_chat_bottom_sheet_widget.dart';

class ProfileScreen extends StatefulWidget {
  final VoidCallback? onLogout;
  final VoidCallback? onToggleLanguage;

  const ProfileScreen({
    super.key,
    this.onLogout,
    this.onToggleLanguage,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notificationsEnabled = true;
  bool _biometricEnabled = false;
  bool _darkModeEnabled = true;

  void _openAiChat() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const AiChatBottomSheetWidget(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.darkBackground,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // ── Profile Hero Header ─────────────────────────────────
            _buildProfileHeader(context),

            Gap(20.h),

            // ── Stats Row ───────────────────────────────────────────
            FadeInUp(
              delay: const Duration(milliseconds: 100),
              duration: const Duration(milliseconds: 400),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: _buildStatsRow(context),
              ),
            ),

            Gap(24.h),

            // ── Account Settings ────────────────────────────────────
            FadeInUp(
              delay: const Duration(milliseconds: 150),
              duration: const Duration(milliseconds: 400),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: _buildSectionTitle(context, 'Account Settings', Icons.manage_accounts_outlined),
              ),
            ),
            Gap(10.h),
            FadeInUp(
              delay: const Duration(milliseconds: 180),
              duration: const Duration(milliseconds: 400),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: _buildSettingsCard(context, [
                  _buildProfileTile(
                    context,
                    icon: Icons.person_outline_rounded,
                    iconColor: AppColor.emeraldTeal,
                    title: 'Ahmed Al-Rashidi',
                    subtitle: 'System Administrator',
                    trailing: _buildChip(context, 'Admin', AppColor.emeraldTeal),
                  ),
                  _buildDivider(context),
                  _buildProfileTile(
                    context,
                    icon: Icons.business_outlined,
                    iconColor: AppColor.oceanBlue,
                    title: 'Delta Enterprise Co.',
                    subtitle: 'Organization · Saudi Arabia',
                    trailing: null,
                  ),
                  _buildDivider(context),
                  _buildProfileTile(
                    context,
                    icon: Icons.email_outlined,
                    iconColor: AppColor.purpleAccent,
                    title: 'admin@delta-erp.sa',
                    subtitle: 'Primary Email · Verified',
                    trailing: Icon(Icons.verified_rounded, color: AppColor.emeraldTeal, size: 16.r),
                  ),
                ]),
              ),
            ),

            Gap(20.h),

            // ── Preferences ─────────────────────────────────────────
            FadeInUp(
              delay: const Duration(milliseconds: 220),
              duration: const Duration(milliseconds: 400),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: _buildSectionTitle(context, 'Preferences', Icons.tune_rounded),
              ),
            ),
            Gap(10.h),
            FadeInUp(
              delay: const Duration(milliseconds: 250),
              duration: const Duration(milliseconds: 400),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: _buildSettingsCard(context, [
                  _buildToggleTile(
                    context,
                    icon: Icons.notifications_outlined,
                    iconColor: AppColor.warningOrange,
                    title: 'Push Notifications',
                    subtitle: 'Alerts, reminders & updates',
                    value: _notificationsEnabled,
                    onChanged: (v) => setState(() => _notificationsEnabled = v),
                  ),
                  _buildDivider(context),
                  _buildToggleTile(
                    context,
                    icon: Icons.fingerprint_rounded,
                    iconColor: AppColor.mintTeal,
                    title: 'Biometric Login',
                    subtitle: 'Face ID / Fingerprint access',
                    value: _biometricEnabled,
                    onChanged: (v) => setState(() => _biometricEnabled = v),
                  ),
                  _buildDivider(context),
                  _buildToggleTile(
                    context,
                    icon: Icons.dark_mode_outlined,
                    iconColor: AppColor.purpleAccent,
                    title: 'Dark Mode',
                    subtitle: 'Always-on dark interface',
                    value: _darkModeEnabled,
                    onChanged: (v) => setState(() => _darkModeEnabled = v),
                  ),
                  _buildDivider(context),
                  _buildActionTile(
                    context,
                    icon: Icons.language_rounded,
                    iconColor: AppColor.skyBlue,
                    title: 'Language / اللغة',
                    subtitle: context.locale.languageCode == 'ar' ? 'العربية' : 'English',
                    onTap: widget.onToggleLanguage,
                  ),
                ]),
              ),
            ),

            Gap(20.h),

            // ── AI Assistant ────────────────────────────────────────
            FadeInUp(
              delay: const Duration(milliseconds: 300),
              duration: const Duration(milliseconds: 400),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: _buildAiAssistantBanner(context),
              ),
            ),

            Gap(20.h),

            // ── System ──────────────────────────────────────────────
            FadeInUp(
              delay: const Duration(milliseconds: 340),
              duration: const Duration(milliseconds: 400),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: _buildSectionTitle(context, 'System', Icons.settings_outlined),
              ),
            ),
            Gap(10.h),
            FadeInUp(
              delay: const Duration(milliseconds: 360),
              duration: const Duration(milliseconds: 400),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: _buildSettingsCard(context, [
                  _buildActionTile(
                    context,
                    icon: Icons.help_outline_rounded,
                    iconColor: AppColor.mintTeal,
                    title: 'Help & Support',
                    subtitle: 'Documentation, FAQs',
                    onTap: () {},
                  ),
                  _buildDivider(context),
                  _buildActionTile(
                    context,
                    icon: Icons.shield_outlined,
                    iconColor: AppColor.oceanBlue,
                    title: 'Privacy & Security',
                    subtitle: 'Data protection settings',
                    onTap: () {},
                  ),
                  _buildDivider(context),
                  _buildActionTile(
                    context,
                    icon: Icons.info_outline_rounded,
                    iconColor: const Color(0xFF636E72),
                    title: 'About Delta ERP',
                    subtitle: 'Version 1.0.0 · Build 2026',
                    onTap: () {},
                  ),
                ]),
              ),
            ),

            Gap(20.h),

            // ── Logout Button ───────────────────────────────────────
            FadeInUp(
              delay: const Duration(milliseconds: 400),
              duration: const Duration(milliseconds: 400),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: _buildLogoutButton(context),
              ),
            ),

            Gap(100.h),
          ],
        ),
      ),
    );
  }

  // ── Profile Header ─────────────────────────────────────────────────────────
  Widget _buildProfileHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20.w, 56.h, 20.w, 28.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF16202E), Color(0xFF0D121B)],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28.r)),
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withValues(alpha: 0.06),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // Avatar
          FadeInDown(
            duration: const Duration(milliseconds: 500),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: EdgeInsets.all(3.r),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF00B894), Color(0xFF0984E3)],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.emeraldTeal.withValues(alpha: 0.4),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 36.r,
                    backgroundColor: const Color(0xFF1B2431),
                    child: Text(
                      'A',
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 2.h,
                  right: 2.w,
                  child: Container(
                    width: 14.w,
                    height: 14.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFF00E676),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF16202E),
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Gap(14.h),
          FadeInUp(
            delay: const Duration(milliseconds: 100),
            duration: const Duration(milliseconds: 400),
            child: Text(
              'Ahmed Al-Rashidi',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                fontFamily: 'Tajawal',
                letterSpacing: -0.3,
              ),
            ),
          ),
          Gap(4.h),
          FadeInUp(
            delay: const Duration(milliseconds: 150),
            duration: const Duration(milliseconds: 400),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 6.w,
                  height: 6.h,
                  decoration: const BoxDecoration(
                    color: Color(0xFF00E676),
                    shape: BoxShape.circle,
                  ),
                ),
                Gap(5.w),
                Text(
                  'System Administrator · Delta Enterprise',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: Colors.white.withValues(alpha: 0.55),
                    fontFamily: 'Tajawal',
                  ),
                ),
              ],
            ),
          ),
          Gap(16.h),
          FadeInUp(
            delay: const Duration(milliseconds: 200),
            duration: const Duration(milliseconds: 400),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: AppColor.emeraldTeal.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: AppColor.emeraldTeal.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.workspace_premium_rounded, color: AppColor.emeraldTeal, size: 13.r),
                  Gap(5.w),
                  Text(
                    'Enterprise License · Active',
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: AppColor.emeraldTeal,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Stats Row ──────────────────────────────────────────────────────────────
  Widget _buildStatsRow(BuildContext context) {
    return Row(
      children: [
        _buildStatCard(context, '1,240', 'Actions', AppColor.emeraldTeal),
        Gap(10.w),
        _buildStatCard(context, '48', 'Reports', AppColor.oceanBlue),
        Gap(10.w),
        _buildStatCard(context, '99.8%', 'Uptime', AppColor.purpleAccent),
      ],
    );
  }

  Widget _buildStatCard(BuildContext context, String value, String label, Color color) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: color.withValues(alpha: 0.15)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w800,
                color: color,
                fontFamily: 'Tajawal',
                letterSpacing: -0.5,
              ),
            ),
            Gap(2.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 10.sp,
                color: Colors.white.withValues(alpha: 0.45),
                fontFamily: 'Tajawal',
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Section Title ──────────────────────────────────────────────────────────
  Widget _buildSectionTitle(BuildContext context, String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.white.withValues(alpha: 0.4), size: 16.r),
        Gap(6.w),
        Text(
          title,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w700,
            color: Colors.white.withValues(alpha: 0.55),
            fontFamily: 'Tajawal',
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  // ── Settings Card ──────────────────────────────────────────────────────────
  Widget _buildSettingsCard(BuildContext context, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF131B26),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.06),
        ),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Divider(
      height: 1,
      color: Colors.white.withValues(alpha: 0.05),
      indent: 54.w,
      endIndent: 0,
    );
  }

  Widget _buildProfileTile(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required Widget? trailing,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(icon, color: iconColor, size: 18.r),
          ),
          Gap(12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontFamily: 'Tajawal',
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 10.5.sp,
                    color: Colors.white.withValues(alpha: 0.45),
                    fontFamily: 'Tajawal',
                  ),
                ),
              ],
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }

  Widget _buildToggleTile(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(icon, color: iconColor, size: 18.r),
          ),
          Gap(12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontFamily: 'Tajawal',
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 10.5.sp,
                    color: Colors.white.withValues(alpha: 0.45),
                    fontFamily: 'Tajawal',
                  ),
                ),
              ],
            ),
          ),
          Transform.scale(
            scale: 0.8,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeThumbColor: iconColor,
              activeTrackColor: iconColor.withValues(alpha: 0.3),
              inactiveThumbColor: Colors.white.withValues(alpha: 0.3),
              inactiveTrackColor: Colors.white.withValues(alpha: 0.08),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(icon, color: iconColor, size: 18.r),
            ),
            Gap(12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 10.5.sp,
                      color: Colors.white.withValues(alpha: 0.45),
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: Colors.white.withValues(alpha: 0.2),
              size: 18.r,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(BuildContext context, String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 9.5.sp,
          fontWeight: FontWeight.w700,
          color: color,
          fontFamily: 'Tajawal',
        ),
      ),
    );
  }

  // ── AI Assistant Banner ─────────────────────────────────────────────────────
  Widget _buildAiAssistantBanner(BuildContext context) {
    return GestureDetector(
      onTap: _openAiChat,
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF6C5CE7).withValues(alpha: 0.2),
              const Color(0xFF00B894).withValues(alpha: 0.15),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: AppColor.purpleAccent.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6C5CE7), Color(0xFF00B894)],
                ),
                borderRadius: BorderRadius.circular(14.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.purpleAccent.withValues(alpha: 0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 22.r),
            ),
            Gap(14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'AI Executive Assistant',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  Text(
                    'Ask anything about your business data',
                    style: TextStyle(
                      fontSize: 10.5.sp,
                      color: Colors.white.withValues(alpha: 0.55),
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: AppColor.purpleAccent.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: AppColor.purpleAccent.withValues(alpha: 0.4)),
              ),
              child: Text(
                'Open',
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColor.purpleAccent,
                  fontFamily: 'Tajawal',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Logout Button ──────────────────────────────────────────────────────────
  Widget _buildLogoutButton(BuildContext context) {
    return GestureDetector(
      onTap: widget.onLogout,
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
            Icon(Icons.logout_rounded, color: const Color(0xFFFF7675), size: 18.r),
            Gap(8.w),
            Text(
              AppLocaleKey.logout.tr(),
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFFFF7675),
                fontFamily: 'Tajawal',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
