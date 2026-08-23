import 'package:easy_localization/easy_localization.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';

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
        Text('foldersTitle'.tr(),
            style: AppTextStyle.bodyMedium(context).copyWith(color: AppColor.whiteColor(context).withValues(alpha: 0.7))),
        Gap(12.h),
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
              delay: Duration(milliseconds: 80 * index),
              child: Container(
                margin: EdgeInsets.only(bottom: 10.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF171F2B),
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(color: AppColor.whiteColor(context).withValues(alpha: 0.05)),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
                  leading: Container(
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(10.r)),
                    child: Icon(folder['icon'] as IconData, color: color, size: 22.r),
                  ),
                  title: Text(name, style: AppTextStyle.bodyMedium(context).copyWith(fontWeight: FontWeight.w600)),
                  subtitle: Text(folder['count'] as String, style: AppTextStyle.text12SDark(context).copyWith(fontSize: 11.sp, color: AppColor.whiteColor(context).withValues(alpha: 0.38))),
                  trailing: IconButton(
                    icon: Icon(
                      isFav ? Icons.star_rounded : Icons.star_border_rounded,
                      color: isFav ? const Color(0xFFFDCB6E) : AppColor.whiteColor(context).withValues(alpha: 0.30),
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
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}