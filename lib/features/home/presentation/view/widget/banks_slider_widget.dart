import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/features/home/data/models/banks_data_model.dart';

class BanksSliderWidget extends StatefulWidget {
  final List<BANKSDATAModel>? banks;

  const BanksSliderWidget({
    super.key,
    this.banks,
  });

  @override
  State<BanksSliderWidget> createState() => _BanksSliderWidgetState();
}

class _BanksSliderWidgetState extends State<BanksSliderWidget> {
  late ScrollController _scrollController;
  Timer? _timer;
  late List<BANKSDATAModel> _bankList;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _bankList = (widget.banks != null && widget.banks!.isNotEmpty)
        ? widget.banks!
        : BANKSDATAModel.sampleBanks;

    _startScrolling();
  }

  @override
  void didUpdateWidget(covariant BanksSliderWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.banks != oldWidget.banks && widget.banks != null && widget.banks!.isNotEmpty) {
      setState(() {
        _bankList = widget.banks!;
      });
    }
  }

  void _startScrolling() {
    _timer = Timer.periodic(const Duration(milliseconds: 60), (timer) {
      if (_scrollController.hasClients && _bankList.isNotEmpty) {
        final double maxScroll = _scrollController.position.maxScrollExtent;
        final double currentScroll = _scrollController.offset;

        if (currentScroll >= maxScroll) {
          _scrollController.jumpTo(0);
        } else {
          _scrollController.animateTo(
            currentScroll + 3,
            duration: const Duration(milliseconds: 60),
            curve: Curves.linear,
          );
        }
      }
    });
  }

  Color _getBankColor(int index) {
    const colors = [
      AppColor.emeraldTeal,
      AppColor.oceanBlue,
      AppColor.purpleAccent,
      AppColor.mintTeal,
      Color(0xFFE17055),
    ];
    return colors[index % colors.length];
  }

  String _getBankLogoText(BANKSDATAModel bank) {
    final name = bank.bankName ?? bank.bankNameEng ?? 'B';
    if (name.trim().isEmpty) return 'B';
    return name.trim().substring(0, 1).toUpperCase();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_bankList.isEmpty) {
      return const SizedBox.shrink();
    }

    final isArabic = context.locale.languageCode == 'ar';

    return Container(
      height: 48.h,
      decoration: BoxDecoration(
        color: AppColor.darkSurface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: AppColor.whiteColor(context).withValues(alpha: 0.05),
        ),
      ),
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final bank = _bankList[index % _bankList.length];
          final brandColor = _getBankColor(bank.bankCode ?? index);
          final displayName = isArabic
              ? (bank.bankName ?? bank.bankNameEng ?? '')
              : (bank.bankNameEng ?? bank.bankName ?? '');
          final logoText = _getBankLogoText(bank);

          return Container(
            margin: EdgeInsets.symmetric(horizontal: 10.w),
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 32.w,
                  height: 32.h,
                  decoration: BoxDecoration(
                    color: brandColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: brandColor.withValues(alpha: 0.35),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    logoText,
                    style: TextStyle(
                      color: AppColor.whiteColor(context),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                Gap(8.w),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName,
                      style: AppTextStyle.bodySmall(context).copyWith(
                        color: AppColor.whiteColor(context).withValues(alpha: 0.9),
                        fontWeight: FontWeight.bold,
                        fontSize: 12.sp,
                      ),
                    ),
                    if (bank.bankAccNo != null)
                      Text(
                        '#${bank.bankAccNo!.toInt()}',
                        style: TextStyle(
                          fontSize: 9.sp,
                          color: AppColor.emeraldTeal.withValues(alpha: 0.8),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
