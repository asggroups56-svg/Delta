import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/custom_widgets/custom_toast/custom_toast.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/utils/common_methods.dart';
import 'package:pdfx/pdfx.dart' as pdfx;

import 'file_download_service.dart';
import 'fullscreen_pdf_viewer_screen.dart';

class PdfPreviewPanel extends StatefulWidget {
  final File file;
  final String title;
  final VoidCallback? onClose;

  const PdfPreviewPanel({
    super.key,
    required this.file,
    required this.title,
    this.onClose,
  });

  @override
  State<PdfPreviewPanel> createState() => _PdfPreviewPanelState();
}

class _PdfPreviewPanelState extends State<PdfPreviewPanel> {
  late pdfx.PdfController _controller;
  int _currentPage = 1;
  int _totalPages = 1;
  bool _isDownloading = false;
  String _fileSizeStr = '';

  @override
  void initState() {
    super.initState();
    _initController();
    _calcFileSize();
  }

  void _calcFileSize() {
    try {
      final bytes = widget.file.lengthSync();
      if (bytes < 1024) {
        _fileSizeStr = '$bytes B';
      } else if (bytes < 1024 * 1024) {
        _fileSizeStr = '${(bytes / 1024).toStringAsFixed(1)} KB';
      } else {
        _fileSizeStr = '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
      }
    } catch (_) {
      _fileSizeStr = '';
    }
  }

  void _initController() {
    _controller = pdfx.PdfController(
      document: pdfx.PdfDocument.openFile(widget.file.path),
    );
  }

  @override
  void didUpdateWidget(covariant PdfPreviewPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.file.path != widget.file.path) {
      _controller.dispose();
      _initController();
      _calcFileSize();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _downloadFile() async {
    if (_isDownloading) return;
    setState(() => _isDownloading = true);

    try {
      final fileName =
          '${widget.title.replaceAll(' ', '_')}_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final savedFile = await FileDownloadService.saveFileToDevice(
        sourceFile: widget.file,
        defaultFileName: fileName,
      );

      if (!mounted) return;
      setState(() => _isDownloading = false);

      if (savedFile != null) {
        CommonMethods.showToast(
          message: 'تم حفظ الملف بنجاح في مجلد التنزيلات:\n${savedFile.path.split('/').last}',
          type: ToastType.success,
        );
      } else {
        CommonMethods.showToast(
          message: 'تم حفظ الملف بنجاح',
          type: ToastType.success,
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isDownloading = false);
      CommonMethods.showToast(
        message: 'حدث خطأ أثناء تنزيل الملف',
        type: ToastType.error,
      );
    }
  }

  Future<void> _openExternal() async {
    try {
      final isOpened = await FileDownloadService.openFile(widget.file.path);
      if (!isOpened) {
        CommonMethods.showToast(
          message: 'تعذر فتح الملف بتطبيق خارجي',
          type: ToastType.error,
        );
      }
    } catch (e) {
      CommonMethods.showToast(
        message: 'حدث خطأ أثناء فتح الملف',
        type: ToastType.error,
      );
    }
  }

  void _openFullscreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FullscreenPdfViewerScreen(
          file: widget.file,
          title: widget.title,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: AppColor.emeraldTeal.withValues(alpha: 0.35),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColor.emeraldTeal.withValues(alpha: 0.12),
            blurRadius: 24,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── رأس المعاينة الاحترافي ─────────────────────────────────────
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(18.r)),
              border: Border(
                bottom: BorderSide(
                  color: Colors.white.withValues(alpha: 0.08),
                ),
              ),
            ),
            child: Row(
              children: [
                // أيقونة التقرير
                Container(
                  padding: EdgeInsets.all(7.r),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF7675).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(
                      color: const Color(0xFFFF7675).withValues(alpha: 0.4),
                    ),
                  ),
                  child: Icon(
                    Icons.picture_as_pdf_rounded,
                    color: const Color(0xFFFF7675),
                    size: 18.r,
                  ),
                ),
                Gap(10.w),

                // العنوان والتفاصيل
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.5.sp,
                        ),
                      ),
                      Gap(2.h),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6.w,
                                vertical: 1.5.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColor.emeraldTeal.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 5.r,
                                    height: 5.r,
                                    decoration: const BoxDecoration(
                                      color: AppColor.emeraldTeal,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  Gap(4.w),
                                  Text(
                                    'API LIVE',
                                    style: TextStyle(
                                      color: AppColor.mintTeal,
                                      fontSize: 8.5.sp,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (_fileSizeStr.isNotEmpty) ...[
                              Gap(6.w),
                              Text(
                                '•  $_fileSizeStr',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.5),
                                  fontSize: 9.5.sp,
                                ),
                              ),
                            ],
                            Gap(6.w),
                            Text(
                              '•  صفحة $_currentPage من $_totalPages',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.6),
                                fontSize: 9.5.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // أزرار العمليات العلوية
                _actionIconButton(
                  icon: Icons.fullscreen_rounded,
                  color: AppColor.oceanBlue,
                  tooltip: 'عرض بملء الشاشة',
                  onTap: _openFullscreen,
                ),
                Gap(4.w),
                _actionIconButton(
                  icon: Icons.open_in_new_rounded,
                  color: AppColor.skyBlue,
                  tooltip: 'فتح في تطبيق خارجي',
                  onTap: _openExternal,
                ),
                Gap(4.w),
                if (widget.onClose != null)
                  _actionIconButton(
                    icon: Icons.close_rounded,
                    color: Colors.white70,
                    tooltip: 'إغلاق المعاينة',
                    onTap: widget.onClose!,
                  ),
              ],
            ),
          ),

          // ── منطقة عرض الـ PDF ─────────────────────────────────────────
          Expanded(
            child: Container(
              color: const Color(0xFF1E293B).withValues(alpha: 0.5),
              child: ClipRRect(
                child: pdfx.PdfView(
                  controller: _controller,
                  scrollDirection: Axis.vertical,
                  onDocumentLoaded: (doc) {
                    setState(() {
                      _totalPages = doc.pagesCount;
                    });
                  },
                  onPageChanged: (page) {
                    setState(() {
                      _currentPage = page;
                    });
                  },
                  builders: pdfx.PdfViewBuilders<pdfx.DefaultBuilderOptions>(
                    options: const pdfx.DefaultBuilderOptions(),
                    documentLoaderBuilder: (_) => const Center(
                      child: CircularProgressIndicator(color: AppColor.emeraldTeal),
                    ),
                    pageLoaderBuilder: (_) => const Center(
                      child: CircularProgressIndicator(color: AppColor.oceanBlue),
                    ),
                    errorBuilder: (_, error) => Center(
                      child: Text(
                        'خطأ في المعاينة: $error',
                        style: const TextStyle(color: Colors.redAccent),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── شريط العمليات والتنقل السفلي ──────────────────────────────
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(18.r)),
              border: Border(
                top: BorderSide(
                  color: Colors.white.withValues(alpha: 0.08),
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // أزرار التنقل بين الصفحات
                Row(
                  children: [
                    InkWell(
                      onTap: _currentPage > 1
                          ? () => _controller.previousPage(
                                curve: Curves.easeInOut,
                                duration: const Duration(milliseconds: 250),
                              )
                          : null,
                      borderRadius: BorderRadius.circular(8.r),
                      child: Container(
                        padding: EdgeInsets.all(6.r),
                        decoration: BoxDecoration(
                          color: _currentPage > 1
                              ? Colors.white.withValues(alpha: 0.1)
                              : Colors.white.withValues(alpha: 0.03),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Icon(
                          Icons.chevron_right_rounded,
                          size: 16.r,
                          color: _currentPage > 1 ? Colors.white : Colors.white24,
                        ),
                      ),
                    ),
                    Gap(6.w),
                    Text(
                      '$_currentPage / $_totalPages',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Gap(6.w),
                    InkWell(
                      onTap: _currentPage < _totalPages
                          ? () => _controller.nextPage(
                                curve: Curves.easeInOut,
                                duration: const Duration(milliseconds: 250),
                              )
                          : null,
                      borderRadius: BorderRadius.circular(8.r),
                      child: Container(
                        padding: EdgeInsets.all(6.r),
                        decoration: BoxDecoration(
                          color: _currentPage < _totalPages
                              ? Colors.white.withValues(alpha: 0.1)
                              : Colors.white.withValues(alpha: 0.03),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Icon(
                          Icons.chevron_left_rounded,
                          size: 16.r,
                          color:
                              _currentPage < _totalPages ? Colors.white : Colors.white24,
                        ),
                      ),
                    ),
                  ],
                ),

                // زر التنزيل الأساسي المميز
                Flexible(
                  child: InkWell(
                    onTap: _downloadFile,
                    borderRadius: BorderRadius.circular(12.r),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF0D9488), Color(0xFF10B981)],
                        ),
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF10B981).withValues(alpha: 0.35),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (_isDownloading)
                            SizedBox(
                              width: 14.r,
                              height: 14.r,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          else
                            Icon(
                              Icons.download_rounded,
                              color: Colors.white,
                              size: 16.r,
                            ),
                          Gap(6.w),
                          Flexible(
                            child: Text(
                              _isDownloading ? 'جاري التنزيل...' : 'تنزيل التقرير (PDF)',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 10.5.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionIconButton({
    required IconData icon,
    required Color color,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.r),
        child: Container(
          padding: EdgeInsets.all(6.r),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: color.withValues(alpha: 0.25),
            ),
          ),
          child: Icon(icon, color: color, size: 16.r),
        ),
      ),
    );
  }
}