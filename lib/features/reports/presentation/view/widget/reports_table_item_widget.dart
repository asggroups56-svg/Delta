import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/custom_widgets/custom_toast/custom_toast.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/utils/app_locale_key.dart';
import 'package:my_template/core/utils/common_methods.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:excel/excel.dart' hide Border;
import 'package:path_provider/path_provider.dart';
import 'package:pdfx/pdfx.dart' as pdfx;

class ReportsTableItemWidget extends StatelessWidget {
  final String title;
  final String description;
  final String amount;
  final String date;
  final String status;
  final IconData icon;
  final Color iconColor;

  const ReportsTableItemWidget({
    super.key,
    required this.title,
    required this.description,
    required this.amount,
    required this.date,
    required this.status,
    required this.icon,
    required this.iconColor,
  });

      Future<void> _onExportPdf(BuildContext context) async {
    try {
      final pdfDoc = pw.Document();
      pdfDoc.addPage(
        pw.Page(
          build: (pw.Context ctx) {
            return pw.Directionality(
              textDirection: pw.TextDirection.rtl,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(title,
                      style: pw.TextStyle(
                          fontSize: 20, fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 8),
                  pw.Text(description,
                      style: const pw.TextStyle(fontSize: 12)),
                  pw.Divider(),
                  pw.SizedBox(height: 12),
                  _pdfRow('التاريخ', date),
                  _pdfRow('المبلغ', amount),
                  _pdfRow('الحالة', status),
                ],
              ),
            );
          },
        ),
      );

      final dir = await getTemporaryDirectory();
      final file = File(
          '${dir.path}/report_${DateTime.now().millisecondsSinceEpoch}.pdf');
      await file.writeAsBytes(await pdfDoc.save());

      if (!context.mounted) return;
      CommonMethods.showToast(
        message: '${AppLocaleKey.downloadingPdf.tr()} ($title)',
        type: ToastType.success,
      );

      _showPdfPreviewDialog(context, file);
    } catch (e) {
      if (context.mounted) {
        CommonMethods.showToast(
          message: 'حدث خطأ أثناء إنشاء ملف PDF',
          type: ToastType.error,
        );
      }
    }
  }

  pw.Widget _pdfRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.Text(value),
        ],
      ),
    );
  }

  // ── PDF preview INSIDE the app (no external app opens) ────────────────────
  void _showPdfPreviewDialog(BuildContext context, File file) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (ctx) {
        final controller = pdfx.PdfController(
          document: pdfx.PdfDocument.openFile(file.path),
        );
        return Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 40.h),
          backgroundColor: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.r),
                    topRight: Radius.circular(16.r),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.picture_as_pdf_rounded,
                        color: const Color(0xFFFF7675), size: 18.r),
                    Gap(8.w),
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12.sp),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, color: Colors.white),
                      onPressed: () {
                        controller.dispose();
                        Navigator.pop(ctx);
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: pdfx.PdfView(controller: controller),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _onExportExcel(BuildContext context) async {
    try {
      final rows = <List<String>>[
        ['البند', 'التفاصيل', 'المبلغ', 'التاريخ', 'الحالة'],
        [title, description, amount, date, status],
      ];

      // لسه بنولّد ملف xlsx حقيقي (لو حبيت تشاركه لاحقًا بـ share_plus مثلاً)
      final excelDoc = Excel.createExcel();
      final sheet = excelDoc['Report'];
      for (final r in rows) {
        sheet.appendRow(r.map((e) => TextCellValue(e)).toList());
      }
      excelDoc.delete('Sheet1');

      final dir = await getTemporaryDirectory();
      final file = File(
          '${dir.path}/report_${DateTime.now().millisecondsSinceEpoch}.xlsx');
      final bytes = excelDoc.encode();
      if (bytes == null) throw Exception('فشل ترميز ملف الإكسل');
      await file.writeAsBytes(bytes);

      if (!context.mounted) return;
      CommonMethods.showToast(
        message: '${AppLocaleKey.exportingExcel.tr()} ($title)',
        type: ToastType.success,
      );

      _showExcelPreviewDialog(context, rows);
    } catch (e) {
      if (context.mounted) {
        CommonMethods.showToast(
          message: 'حدث خطأ أثناء إنشاء ملف Excel',
          type: ToastType.error,
        );
      }
    }
  }

  // ── Excel preview INSIDE the app as a table (no external app opens) ───────
  void _showExcelPreviewDialog(BuildContext context, List<List<String>> rows) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (ctx) => Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 60.h),
        backgroundColor: const Color(0xFF0F172A),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withValues(alpha: 0.15),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.r),
                  topRight: Radius.circular(16.r),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.table_chart_rounded,
                      color: const Color(0xFF10B981), size: 18.r),
                  Gap(8.w),
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.sp),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: Colors.white),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(12.r),
                  child: DataTable(
                    headingRowColor:
                        WidgetStateProperty.all(Colors.white.withValues(alpha: 0.05)),
                    columns: rows.first
                        .map((h) => DataColumn(
                              label: Text(h,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11.sp)),
                            ))
                        .toList(),
                    rows: rows
                        .skip(1)
                        .map(
                          (r) => DataRow(
                            cells: r
                                .map((c) => DataCell(Text(c,
                                    style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 10.5.sp))))
                                .toList(),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  
 

  @override
  Widget build(BuildContext context) {
    final bool isAudited = status == AppLocaleKey.statusAudited.tr();

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColor.darkCardBackground,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColor.whiteColor(context).withValues(alpha: 0.08),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42.r,
                height: 42.r,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: iconColor.withValues(alpha: 0.3),
                  ),
                ),
                child: Icon(icon, color: iconColor, size: 22.r),
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
                        fontWeight: FontWeight.bold,
                        color: AppColor.whiteColor(context),
                      ),
                    ),
                    Gap(2.h),
                    Text(
                      description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: AppColor.whiteColor(context)
                            .withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Gap(8.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: isAudited
                      ? AppColor.emeraldTeal.withValues(alpha: 0.15)
                      : const Color(0xFFF39C12).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: isAudited
                        ? AppColor.emeraldTeal.withValues(alpha: 0.3)
                        : const Color(0xFFF39C12).withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.bold,
                    color: isAudited
                        ? AppColor.emeraldTeal
                        : const Color(0xFFF39C12),
                  ),
                ),
              ),
            ],
          ),
          Gap(12.h),
          Divider(
            color: AppColor.whiteColor(context).withValues(alpha: 0.08),
            height: 1,
          ),
          Gap(10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 12.r,
                      color: AppColor.whiteColor(context).withValues(alpha: 0.5),
                    ),
                    Gap(4.w),
                    Flexible(
                      child: Text(
                        date,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 10.5.sp,
                          color:
                              AppColor.whiteColor(context).withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                    Gap(6.w),
                    Text(
                      amount,
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColor.mintTeal,
                      ),
                    ),
                    Gap(6.w),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // PDF Export button
                  InkWell(
                    onTap: () => _onExportPdf(context),
                    borderRadius: BorderRadius.circular(8.r),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 8.w, vertical: 5.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF7675).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color:
                              const Color(0xFFFF7675).withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.picture_as_pdf_rounded,
                            size: 13.r,
                            color: const Color(0xFFFF7675),
                          ),
                          Gap(3.w),
                          Text(
                            'PDF',
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFFF7675),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Gap(8.w),
                  // Excel Export button
                  InkWell(
                    onTap: () => _onExportExcel(context),
                    borderRadius: BorderRadius.circular(8.r),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 8.w, vertical: 5.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color:
                              const Color(0xFF10B981).withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.table_chart_outlined,
                            size: 13.r,
                            color: const Color(0xFF10B981),
                          ),
                          Gap(3.w),
                          Text(
                            'XLSX',
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF10B981),
                            ),
                          ),
                        ],
                      ),
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
}
