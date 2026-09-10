import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_locale_key.dart';
import 'package:my_template/features/home/presentation/view/widget/ai_chat_bottom_sheet_widget.dart';
import 'package:my_template/features/knowledge/presentation/view/widget/knowledge_article_item_widget.dart';

class KnowledgeScreen extends StatefulWidget {
  const KnowledgeScreen({super.key});

  @override
  State<KnowledgeScreen> createState() => _KnowledgeScreenState();
}

class _KnowledgeScreenState extends State<KnowledgeScreen> {
  int _selectedCategoryIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  Future<void> _toggleLanguage() async {
    if (context.locale.languageCode == 'ar') {
      await context.setLocale(const Locale('en'));
    } else {
      await context.setLocale(const Locale('ar'));
    }
    if (mounted) setState(() {});
  }

  void _openAiChat() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const AiChatBottomSheetWidget(),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categories = [
      {'label': AppLocaleKey.kbTabAll.tr(), 'icon': Icons.apps_rounded},
      {'label': AppLocaleKey.kbTabHR.tr(), 'icon': Icons.people_alt_outlined},
      {'label': AppLocaleKey.kbTabIT.tr(), 'icon': Icons.security_rounded},
      {'label': AppLocaleKey.kbTabFinance.tr(), 'icon': Icons.account_balance_outlined},
      {'label': AppLocaleKey.kbTabOperations.tr(), 'icon': Icons.engineering_outlined},
      {'label': AppLocaleKey.kbTabLegal.tr(), 'icon': Icons.gavel_rounded},
    ];

    final articles = [
      {
        'title': AppLocaleKey.articleErpTitle.tr(),
        'desc': AppLocaleKey.articleErpDesc.tr(),
        'icon': Icons.dashboard_customize_outlined,
        'color': AppColor.mintTeal,
        'readTime': 15,
        'updatedAgo': 1,
        'category': 0,
        'views': 1240,
        'badge': AppLocaleKey.kbPopular.tr(),
      },
      {
        'title': AppLocaleKey.articleHrTitle.tr(),
        'desc': AppLocaleKey.articleHrDesc.tr(),
        'icon': Icons.groups_outlined,
        'color': AppColor.warningOrange,
        'readTime': 5,
        'updatedAgo': 2,
        'category': 1,
        'views': 890,
        'badge': null,
      },
      {
        'title': AppLocaleKey.articleHrOnboardTitle.tr(),
        'desc': AppLocaleKey.articleHrOnboardDesc.tr(),
        'icon': Icons.person_add_alt_1_outlined,
        'color': const Color(0xFFFDCB6E),
        'readTime': 7,
        'updatedAgo': 3,
        'category': 1,
        'views': 670,
        'badge': AppLocaleKey.kbNew.tr(),
      },
      {
        'title': AppLocaleKey.articleItTitle.tr(),
        'desc': AppLocaleKey.articleItDesc.tr(),
        'icon': Icons.shield_outlined,
        'color': AppColor.oceanBlue,
        'readTime': 8,
        'updatedAgo': 5,
        'category': 2,
        'views': 1100,
        'badge': null,
      },
      {
        'title': AppLocaleKey.articleFinanceTitle.tr(),
        'desc': AppLocaleKey.articleFinanceDesc.tr(),
        'icon': Icons.receipt_long_rounded,
        'color': AppColor.purpleAccent,
        'readTime': 4,
        'updatedAgo': 1,
        'category': 3,
        'views': 540,
        'badge': AppLocaleKey.kbRecentlyUpdated.tr(),
      },
      {
        'title': AppLocaleKey.articleComplianceTitle.tr(),
        'desc': AppLocaleKey.articleComplianceDesc.tr(),
        'icon': Icons.verified_outlined,
        'color': AppColor.emeraldTeal,
        'readTime': 10,
        'updatedAgo': 7,
        'category': 3,
        'views': 920,
        'badge': null,
      },
      {
        'title': AppLocaleKey.articleOpsTitle.tr(),
        'desc': AppLocaleKey.articleOpsDesc.tr(),
        'icon': Icons.local_fire_department_outlined,
        'color': const Color(0xFFFF7675),
        'readTime': 6,
        'updatedAgo': 14,
        'category': 4,
        'views': 380,
        'badge': null,
      },
      {
        'title': AppLocaleKey.articleLegalTitle.tr(),
        'desc': AppLocaleKey.articleLegalDesc.tr(),
        'icon': Icons.gavel_rounded,
        'color': AppColor.skyBlue,
        'readTime': 9,
        'updatedAgo': 10,
        'category': 5,
        'views': 710,
        'badge': null,
      },
    ];

    // Filter articles
    final filteredArticles = articles.where((a) {
      if (_selectedCategoryIndex != 0 && a['category'] != _selectedCategoryIndex) {
        return false;
      }
      if (_searchController.text.trim().isNotEmpty) {
        final query = _searchController.text.toLowerCase();
        final title = (a['title'] as String).toLowerCase();
        final desc = (a['desc'] as String).toLowerCase();
        return title.contains(query) || desc.contains(query);
      }
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: AppColor.darkBackground,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ── Top Bar ───────────────────────────────────────────────
            SliverToBoxAdapter(
              child: _buildTopBar(context),
            ),

            // ── Search Bar ────────────────────────────────────────────
            SliverToBoxAdapter(
              child: FadeInDown(
                duration: const Duration(milliseconds: 350),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 0),
                  child: Container(
                    height: 48.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFF151D2B),
                      borderRadius: BorderRadius.circular(14.r),
                      border: Border.all(
                        color: AppColor.whiteColor(context).withValues(alpha: 0.06),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Gap(14.w),
                        Icon(
                          Icons.search_rounded,
                          color: AppColor.whiteColor(context).withValues(alpha: 0.35),
                          size: 20.sp,
                        ),
                        Gap(10.w),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            onChanged: (_) => setState(() {}),
                            style: TextStyle(
                              color: AppColor.whiteColor(context),
                              fontSize: 13.sp,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: AppLocaleKey.searchKnowledge.tr(),
                              hintStyle: TextStyle(
                                color: AppColor.whiteColor(context).withValues(alpha: 0.25),
                                fontSize: 13.sp,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 32.h,
                          width: 1,
                          color: AppColor.whiteColor(context).withValues(alpha: 0.06),
                        ),
                        IconButton(
                          onPressed: _openAiChat,
                          icon: ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [AppColor.mintTeal, AppColor.oceanBlue],
                            ).createShader(bounds),
                            child: Icon(
                              Icons.auto_awesome_rounded,
                              color: Colors.white,
                              size: 18.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // ── Stats Bar ─────────────────────────────────────────────
            SliverToBoxAdapter(
              child: FadeInUp(
                delay: const Duration(milliseconds: 100),
                duration: const Duration(milliseconds: 400),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 0),
                  child: Row(
                    children: [
                      _buildStatItem(context, '48', AppLocaleKey.kbStatsArticles.tr(), AppColor.mintTeal),
                      _buildStatItem(context, '6', AppLocaleKey.kbStatsCategories.tr(), AppColor.oceanBlue),
                      _buildStatItem(context, '12', AppLocaleKey.kbStatsAuthors.tr(), AppColor.purpleAccent),
                      _buildStatItem(context, '24h', AppLocaleKey.kbStatsUpdated.tr(), AppColor.emeraldTeal),
                    ],
                  ),
                ),
              ),
            ),

            // ── Featured Article Hero ────────────────────────────────
            SliverToBoxAdapter(
              child: FadeInUp(
                delay: const Duration(milliseconds: 200),
                duration: const Duration(milliseconds: 500),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 0),
                  child: _buildFeaturedArticle(context),
                ),
              ),
            ),

            // ── Category Chips ────────────────────────────────────────
            SliverToBoxAdapter(
              child: FadeInLeft(
                delay: const Duration(milliseconds: 300),
                duration: const Duration(milliseconds: 400),
                child: SizedBox(
                  height: 80.h,
                  child: Padding(
                    padding: EdgeInsets.only(top: 20.h),
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        return _buildCategoryChip(
                          context,
                          categories[index]['label'] as String,
                          categories[index]['icon'] as IconData,
                          index,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),

            // ── Section Title ─────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 12.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${filteredArticles.length} ${AppLocaleKey.kbStatsArticles.tr()}',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColor.whiteColor(context).withValues(alpha: 0.5),
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.sort_rounded,
                          size: 16.sp,
                          color: AppColor.whiteColor(context).withValues(alpha: 0.4),
                        ),
                        Gap(4.w),
                        Text(
                          AppLocaleKey.kbRecentlyUpdated.tr(),
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: AppColor.mintTeal,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ── Articles List ─────────────────────────────────────────
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final article = filteredArticles[index];
                    return FadeInUp(
                      delay: Duration(milliseconds: 80 * index),
                      duration: const Duration(milliseconds: 400),
                      child: KnowledgeArticleItemWidget(
                        title: article['title'] as String,
                        description: article['desc'] as String,
                        icon: article['icon'] as IconData,
                        iconColor: article['color'] as Color,
                        readTimeMins: article['readTime'] as int,
                        updatedDaysAgo: article['updatedAgo'] as int,
                        views: article['views'] as int,
                        badge: article['badge'] as String?,
                      ),
                    );
                  },
                  childCount: filteredArticles.length,
                ),
              ),
            ),

            // Bottom padding
            SliverToBoxAdapter(child: Gap(100.h)),
          ],
        ),
      ),
    );
  }

  // ── Top Bar ──────────────────────────────────────────────────────────────
  Widget _buildTopBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF16202E), Color(0xFF111722)],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20.r)),
        border: Border(
          bottom: BorderSide(
            color: AppColor.whiteColor(context).withValues(alpha: 0.06),
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: const Color(0xFF1F2B3E),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColor.whiteColor(context).withValues(alpha: 0.08),
                ),
              ),
              child: Icon(
                context.locale.languageCode == 'ar'
                    ? Icons.arrow_forward_ios_rounded
                    : Icons.arrow_back_ios_new_rounded,
                color: AppColor.whiteColor(context),
                size: 14.r,
              ),
            ),
          ),
          Gap(12.w),
          // Title section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppLocaleKey.knowledgeBaseTitle.tr(),
                  style: AppTextStyle.bodyMedium(context).copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                    color: AppColor.whiteColor(context),
                    letterSpacing: -0.3,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 4.w,
                      height: 4.h,
                      decoration: const BoxDecoration(
                        color: AppColor.emeraldTeal,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Gap(4.w),
                    Expanded(
                      child: Text(
                        AppLocaleKey.knowledgeBaseSubtitle.tr(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyle.bodySmall(context).copyWith(
                          fontSize: 10.sp,
                          color: AppColor.whiteColor(context).withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Language toggle
          InkWell(
            onTap: _toggleLanguage,
            borderRadius: BorderRadius.circular(10.r),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: const Color(0xFF1F2B3E),
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(
                  color: AppColor.whiteColor(context).withValues(alpha: 0.08),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.language_rounded, color: AppColor.emeraldTeal, size: 13.r),
                  Gap(3.w),
                  Text(
                    AppLocaleKey.langSwitchShort.tr(),
                    style: AppTextStyle.bodySmall(context).copyWith(
                      color: AppColor.whiteColor(context),
                      fontWeight: FontWeight.bold,
                      fontSize: 10.sp,
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

  // ── Stats Bar ────────────────────────────────────────────────────────────
  Widget _buildStatItem(BuildContext context, String value, String label, Color color) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: color.withValues(alpha: 0.12)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w800,
                color: color,
                letterSpacing: -0.5,
              ),
            ),
            Gap(2.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 9.5.sp,
                color: AppColor.whiteColor(context).withValues(alpha: 0.45),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Featured Article Hero ────────────────────────────────────────────────
  Widget _buildFeaturedArticle(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF0D9488).withValues(alpha: 0.25),
            const Color(0xFF6C5CE7).withValues(alpha: 0.15),
            const Color(0xFF0284C7).withValues(alpha: 0.10),
          ],
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: AppColor.mintTeal.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0D9488).withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Featured tag
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColor.emeraldTeal, AppColor.mintTeal],
                  ),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star_rounded, size: 12.sp, color: AppColor.darkBackground),
                    Gap(4.w),
                    Text(
                      AppLocaleKey.kbFeaturedTag.tr(),
                      style: TextStyle(
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w800,
                        color: AppColor.darkBackground,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColor.whiteColor(context).withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.schedule_rounded, size: 11.sp, color: AppColor.mintTeal),
                    Gap(4.w),
                    Text(
                      AppLocaleKey.kbFeaturedReadTime.tr(),
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: AppColor.mintTeal,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Gap(14.h),
          // Title
          Text(
            AppLocaleKey.kbFeaturedTitle.tr(),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w800,
              color: AppColor.whiteColor(context),
              height: 1.3,
              letterSpacing: -0.3,
            ),
          ),
          Gap(8.h),
          // Description
          Text(
            AppLocaleKey.kbFeaturedDesc.tr(),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColor.whiteColor(context).withValues(alpha: 0.65),
              height: 1.5,
            ),
          ),
          Gap(14.h),
          // CTA button
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColor.emeraldTeal, AppColor.mintTeal],
                  ),
                  borderRadius: BorderRadius.circular(10.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.emeraldTeal.withValues(alpha: 0.35),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      AppLocaleKey.kbReadMore.tr(),
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColor.darkBackground,
                      ),
                    ),
                    Gap(6.w),
                    Icon(
                      context.locale.languageCode == 'ar'
                          ? Icons.arrow_back_rounded
                          : Icons.arrow_forward_rounded,
                      size: 14.sp,
                      color: AppColor.darkBackground,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  Icon(Icons.visibility_outlined, size: 14.sp, color: AppColor.whiteColor(context).withValues(alpha: 0.35)),
                  Gap(4.w),
                  Text(
                    '2.4K',
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: AppColor.whiteColor(context).withValues(alpha: 0.4),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Gap(12.w),
                  Icon(Icons.bookmark_border_rounded, size: 14.sp, color: AppColor.whiteColor(context).withValues(alpha: 0.35)),
                  Gap(4.w),
                  Text(
                    '186',
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: AppColor.whiteColor(context).withValues(alpha: 0.4),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Category Chip ────────────────────────────────────────────────────────
  Widget _buildCategoryChip(BuildContext context, String label, IconData icon, int index) {
    final isSelected = _selectedCategoryIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategoryIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        margin: EdgeInsets.only(right: 10.w),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(colors: [AppColor.emeraldTeal, AppColor.mintTeal])
              : null,
          color: isSelected ? null : const Color(0xFF151D2B),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : AppColor.whiteColor(context).withValues(alpha: 0.06),
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColor.emeraldTeal.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14.sp,
              color: isSelected
                  ? AppColor.darkBackground
                  : AppColor.whiteColor(context).withValues(alpha: 0.5),
            ),
            Gap(6.w),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? AppColor.darkBackground
                    : AppColor.whiteColor(context).withValues(alpha: 0.7),
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
