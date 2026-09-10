import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_locale_key.dart';

class FolderListWidget extends StatefulWidget {
  const FolderListWidget({super.key, required this.folders});

  final List<Map<String, dynamic>> folders;

  @override
  State<FolderListWidget> createState() => _FolderListWidgetState();
}

class _FolderListWidgetState extends State<FolderListWidget> {
  final Set<String> _favoriteFolders = {};

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocaleKey.foldersTitle.tr(),
              style: AppTextStyle.bodyMedium(context).copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 13.sp,
                color: AppColor.whiteColor(context).withValues(alpha: 0.8),
              ),
            ),
            Text(
              '${widget.folders.length} Directories',
              style: TextStyle(
                fontSize: 10.5.sp,
                color: AppColor.whiteColor(context).withValues(alpha: 0.4),
              ),
            ),
          ],
        ),
        Gap(10.h),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.folders.length,
          itemBuilder: (context, index) {
            final folder = widget.folders[index];
            final name = folder['name'] as String;
            final isFav = _favoriteFolders.contains(name);
            final color = folder['color'] as Color;

            return FadeInRight(
              delay: Duration(milliseconds: 60 * index),
              duration: const Duration(milliseconds: 300),
              child: Container(
                margin: EdgeInsets.only(bottom: 10.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF141D2B),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: AppColor.whiteColor(context).withValues(alpha: 0.06),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 8.r,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Opening $name...'),
                        backgroundColor: color,
                        duration: const Duration(milliseconds: 800),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ));
                    },
                    borderRadius: BorderRadius.circular(16.r),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10.r),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  color.withValues(alpha: 0.25),
                                  color.withValues(alpha: 0.1),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: color.withValues(alpha: 0.3),
                                width: 1,
                              ),
                            ),
                            child: Icon(
                              folder['icon'] as IconData,
                              color: color,
                              size: 22.r,
                            ),
                          ),
                          Gap(12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: AppTextStyle.bodyMedium(context).copyWith(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13.5.sp,
                                    color: AppColor.whiteColor(context),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Gap(3.h),
                                Row(
                                  children: [
                                    Container(
                                      width: 5.r,
                                      height: 5.r,
                                      decoration: BoxDecoration(
                                        color: color,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    Gap(5.w),
                                    Text(
                                      folder['count'] as String,
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                        color: AppColor.whiteColor(context).withValues(alpha: 0.45),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              isFav ? Icons.star_rounded : Icons.star_outline_rounded,
                              color: isFav ? const Color(0xFFFDCB6E) : AppColor.whiteColor(context).withValues(alpha: 0.3),
                              size: 22.r,
                            ),
                            onPressed: () => setState(() {
                              if (isFav) {
                                _favoriteFolders.remove(name);
                              } else {
                                _favoriteFolders.add(name);
                              }
                            }),
                          ),
                          Icon(
                            Icons.chevron_right_rounded,
                            size: 18.r,
                            color: AppColor.whiteColor(context).withValues(alpha: 0.25),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}