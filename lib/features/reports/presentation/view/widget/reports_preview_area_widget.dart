import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/features/reports/presentation/view/widget/pdf_preview_panel.dart';

enum ReportPreviewKind { none, pdf }

class ReportsPreviewAreaWidget extends StatelessWidget {
  final ReportPreviewKind previewKind;
  final bool isGenerating;
  final File? pdfFile;
  final String previewTitle;
  final VoidCallback onClosePreview;

  const ReportsPreviewAreaWidget({
    super.key,
    required this.previewKind,
    required this.isGenerating,
    required this.pdfFile,
    required this.previewTitle,
    required this.onClosePreview,
  });

  @override
  Widget build(BuildContext context) {
    if (previewKind == ReportPreviewKind.none && !isGenerating) {
      return const SizedBox.shrink();
    }

    return AnimatedSize(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
        child: SizedBox(
          height: 500.h,
          child: _buildPreviewContent(context),
        ),
      ),
    );
  }

  Widget _buildPreviewContent(BuildContext context) {
    if (isGenerating) {
      return Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0F172A),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: AppColor.emeraldTeal.withValues(alpha: 0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColor.emeraldTeal.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: AppColor.emeraldTeal.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: SizedBox(
                  width: 32.r,
                  height: 32.r,
                  child: const CircularProgressIndicator(
                    strokeWidth: 3,
                    color: AppColor.emeraldTeal,
                  ),
                ),
              ),
              Gap(16.h),
              Text(
                'جاري جلب وإنشاء التقرير المالي...',
                style: AppTextStyle.bodyLarge(context).copyWith(
                  color: AppColor.titleFormFiledColor(context),
                  fontWeight: FontWeight.bold,
                  fontSize: 13.sp,
                ),
              ),
              Gap(6.h),
              Text(
                'Report API • $previewTitle',
                style: AppTextStyle.bodySmall(context).copyWith(
                  color: AppColor.mintTeal.withValues(alpha: 0.8),
                  fontSize: 11.sp,
                ),
              ),
            ],
          ),
        ),
      );
    }

    switch (previewKind) {
      case ReportPreviewKind.pdf:
        if (pdfFile == null) return const SizedBox.shrink();
        return PdfPreviewPanel(
          file: pdfFile!,
          title: previewTitle,
          onClose: onClosePreview,
        );

      case ReportPreviewKind.none:
        return const SizedBox.shrink();
    }
  }
}
