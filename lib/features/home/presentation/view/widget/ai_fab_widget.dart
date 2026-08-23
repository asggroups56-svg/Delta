import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'ai_chat_bottom_sheet_widget.dart';

class AiFabWidget extends StatefulWidget {
  const AiFabWidget({super.key});

  @override
  State<AiFabWidget> createState() => _AiFabWidgetState();
}

class _AiFabWidgetState extends State<AiFabWidget> with SingleTickerProviderStateMixin {
  late AnimationController _aiPulseController;
  late Animation<double> _aiPulseAnimation;

  @override
  void initState() {
    super.initState();
    _aiPulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _aiPulseAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _aiPulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _aiPulseController.dispose();
    super.dispose();
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
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _aiPulseAnimation,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _openAiChat,
          borderRadius: BorderRadius.circular(30.r),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColor.purpleAccent, AppColor.emeraldTeal],
              ),
              borderRadius: BorderRadius.circular(30.r),
              boxShadow: [
                BoxShadow(
                  color: AppColor.purpleAccent.withValues(alpha: 0.5),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.auto_awesome_rounded,
                  color: AppColor.whiteColor(context),
                  size: 18.r,
                ),
                Gap(6.w),
                Text(
                  'AI',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColor.whiteColor(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
