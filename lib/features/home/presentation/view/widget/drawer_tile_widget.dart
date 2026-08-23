import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';

class DrawerTileWidget extends StatelessWidget {
  const DrawerTileWidget( {super.key, required this.icons, required this.title, this.onTap, this.color});
final IconData icons;
  final String title;
  final VoidCallback? onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icons, color: color ?? Colors.white70, size: 20.r),
      title: Text(title, style: AppTextStyle.bodyMedium(context).copyWith(color: color ?? AppColor.whiteColor(context))),
      onTap: onTap ?? () {},
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
    );
  }
}