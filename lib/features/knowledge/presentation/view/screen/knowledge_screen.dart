import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/utils/app_locale_key.dart';
import 'package:my_template/features/home/presentation/view/widget/ai_chat_bottom_sheet_widget.dart';
import 'package:my_template/features/home/presentation/view/widget/dashboard_top_header_widget.dart';
import 'package:my_template/features/knowledge/presentation/view/widget/knowledge_article_item_widget.dart';

class KnowledgeScreen extends StatefulWidget {
  const KnowledgeScreen({super.key});

  @override
  State<KnowledgeScreen> createState() => _KnowledgeScreenState();
}

class _KnowledgeScreenState extends State<KnowledgeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedCategoryIndex = 0;

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

  void _openAiChat() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const AiChatBottomSheetWidget(),
    );
  }

  Widget _buildCategoryChip(String title, int index) {
    final isSelected = _selectedCategoryIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategoryIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: EdgeInsets.only(right: 12.w),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColor.mintTeal : const Color(0xFF1B2431),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected ? AppColor.mintTeal : AppColor.whiteColor(context).withValues(alpha: 0.1),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? AppColor.darkBackground : AppColor.whiteColor(context),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 13.sp,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categories = [
      AppLocaleKey.kbTabAll.tr(),
      AppLocaleKey.kbTabHR.tr(),
      AppLocaleKey.kbTabIT.tr(),
      AppLocaleKey.kbTabFinance.tr(),
      AppLocaleKey.kbTabOperations.tr(),
    ];

    final articles = [
      {
        'title': AppLocaleKey.articleHrTitle.tr(),
        'desc': AppLocaleKey.articleHrDesc.tr(),
        'icon': Icons.groups_outlined,
        'color': AppColor.warningOrange,
        'readTime': 5,
        'updatedAgo': 2,
        'category': 1,
      },
      {
        'title': AppLocaleKey.articleItTitle.tr(),
        'desc': AppLocaleKey.articleItDesc.tr(),
        'icon': Icons.security_rounded,
        'color': AppColor.oceanBlue,
        'readTime': 8,
        'updatedAgo': 5,
        'category': 2,
      },
      {
        'title': AppLocaleKey.articleFinanceTitle.tr(),
        'desc': AppLocaleKey.articleFinanceDesc.tr(),
        'icon': Icons.receipt_long_rounded,
        'color': AppColor.purpleAccent,
        'readTime': 4,
        'updatedAgo': 1,
        'category': 3,
      },
      {
        'title': AppLocaleKey.articleOpsTitle.tr(),
        'desc': AppLocaleKey.articleOpsDesc.tr(),
        'icon': Icons.business_center_outlined,
        'color': AppColor.emeraldTeal,
        'readTime': 10,
        'updatedAgo': 14,
        'category': 4,
      },
    ];

    final filteredArticles = _selectedCategoryIndex == 0
        ? articles
        : articles.where((a) => a['category'] == _selectedCategoryIndex).toList();

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColor.darkBackground,
      body: SafeArea(
        child: Column(
          children: [
            DashboardTopHeaderWidget(
              title: AppLocaleKey.knowledgeBaseTitle.tr(),
              subtitle: AppLocaleKey.knowledgeBaseSubtitle.tr(),
              onToggleLanguage: _toggleLanguage,
              onOpenDrawer: () {  },
              showBackIcon: true,
            ),
            Gap(20.h),
            
            // Search Bar
            FadeInDown(
              duration: const Duration(milliseconds: 400),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Container(
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1B2431),
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: AppColor.whiteColor(context).withValues(alpha: 0.05)),
                  ),
                  child: Row(
                    children: [
                      Gap(16.w),
                      Icon(Icons.search_rounded, color: AppColor.whiteColor(context).withValues(alpha: 0.4), size: 20.sp),
                      Gap(12.w),
                      Expanded(
                        child: TextField(
                          style: TextStyle(color: AppColor.whiteColor(context), fontSize: 14.sp),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: AppLocaleKey.searchKnowledge.tr(),
                            hintStyle: TextStyle(
                              color: AppColor.whiteColor(context).withValues(alpha: 0.3),
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: _openAiChat,
                        icon: Icon(Icons.auto_awesome_rounded, color: AppColor.mintTeal, size: 20.sp),
                      ),
                      Gap(4.w),
                    ],
                  ),
                ),
              ),
            ),
            Gap(24.h),

            // Categories
            FadeInLeft(
              duration: const Duration(milliseconds: 500),
              child: SizedBox(
                height: 40.h,
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return _buildCategoryChip(categories[index], index);
                  },
                ),
              ),
            ),
            Gap(24.h),

            // Articles List
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                itemCount: filteredArticles.length,
                itemBuilder: (context, index) {
                  final article = filteredArticles[index];
                  return FadeInUp(
                    delay: Duration(milliseconds: 100 * index),
                    duration: const Duration(milliseconds: 500),
                    child: KnowledgeArticleItemWidget(
                      title: article['title'] as String,
                      description: article['desc'] as String,
                      icon: article['icon'] as IconData,
                      iconColor: article['color'] as Color,
                      readTimeMins: article['readTime'] as int,
                      updatedDaysAgo: article['updatedAgo'] as int,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
