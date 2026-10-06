import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/custom_widgets/custom_toast/custom_toast.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/utils/common_methods.dart';
import 'package:pdfx/pdfx.dart' as pdfx;

import 'file_download_service.dart';

class FullscreenPdfViewerScreen extends StatefulWidget {
  final File file;
  final String title;
  final String? reportName;
  final bool autoDownloaded;

  const FullscreenPdfViewerScreen({
    super.key,
    required this.file,
    required this.title,
    this.reportName,
    this.autoDownloaded = false,
  });

  @override
  State<FullscreenPdfViewerScreen> createState() =>
      _FullscreenPdfViewerScreenState();
}

class _FullscreenPdfViewerScreenState extends State<FullscreenPdfViewerScreen> {
  late final pdfx.PdfController _controller;
  final TransformationController _transformController =
      TransformationController();

  int _currentPage = 1;
  int _totalPages = 1;
  bool _isDownloading = false;
  double _currentScale = 1.0;
  String _fileSizeStr = '';

  @override
  void initState() {
    super.initState();
    _calcFileSize();
    _controller = pdfx.PdfController(
      document: pdfx.PdfDocument.openFile(widget.file.path),
    );
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

  @override
  void dispose() {
    _controller.dispose();
    _transformController.dispose();
    super.dispose();
  }

  // ── التكبير والتصغير ───────────────────────────────────────────────────────
  void _zoomIn() {
    setState(() {
      _currentScale = (_currentScale + 0.35).clamp(1.0, 4.5);
      _transformController.value =
          Matrix4.diagonal3Values(_currentScale, _currentScale, 1.0);
    });
  }

  void _zoomOut() {
    setState(() {
      _currentScale = (_currentScale - 0.35).clamp(1.0, 4.5);
      _transformController.value =
          Matrix4.diagonal3Values(_currentScale, _currentScale, 1.0);
    });
  }

  void _resetZoom() {
    setState(() {
      _currentScale = 1.0;
      _transformController.value = Matrix4.identity();
    });
  }

  // ── تنزيل الملف ───────────────────────────────────────────────────────────
  Future<void> _downloadFile() async {
    if (_isDownloading) return;
    setState(() => _isDownloading = true);

    try {
      final baseName = widget.reportName != null && widget.reportName!.isNotEmpty
          ? widget.reportName!
          : widget.title;
      final fileName =
          '${baseName.replaceAll(RegExp(r'\s+'), '_')}_${DateTime.now().millisecondsSinceEpoch}.pdf';

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
          message: 'تم حفظ الملف بنجاح في مجلد المستندات',
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

  // ── فتح بتطبيق خارجي ───────────────────────────────────────────────────────
  Future<void> _openExternal() async {
    try {
      final isOpened = await FileDownloadService.openFile(widget.file.path);
      if (!isOpened) {
        CommonMethods.showToast(
          message: 'تعذر فتح الملف في تطبيق خارجي',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SafeArea(
        child: Column(
          children: [
            // ── الشريط العلوي الفاخر (Luxury Top Navigation Bar) ─────────────
            _buildTopAppBar(),

            // ── شريط أدوات التحكم السريع (Zoom & Page Tools) ────────────────
            _buildQuickToolbar(),

            // ── منطقة عرض الـ PDF مع التكبير والتصغير التفاعلي ──────────────
            Expanded(
              child: Container(
                color: const Color(0xFF0F172A),
                child: InteractiveViewer(
                  transformationController: _transformController,
                  minScale: 1.0,
                  maxScale: 5.0,
                  panEnabled: true,
                  scaleEnabled: true,
                  onInteractionEnd: (_) {
                    final scale = _transformController.value.getMaxScaleOnAxis();
                    if (_currentScale != scale) {
                      setState(() {
                        _currentScale = scale;
                      });
                    }
                  },
                  child: Center(
                    child: Container(
                      margin: EdgeInsets.all(8.r),
                      decoration: BoxDecoration(
                        color: AppColor.whiteColor(context),
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.6),
                            blurRadius: 25,
                            spreadRadius: 2,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.r),
                        child: pdfx.PdfView(
                          controller: _controller,
                          scrollDirection: Axis.vertical,
                          onDocumentLoaded: (document) {
                            setState(() {
                              _totalPages = document.pagesCount;
                            });
                          },
                          onPageChanged: (page) {
                            setState(() {
                              _currentPage = page;
                            });
                          },
                          builders:
                              pdfx.PdfViewBuilders<pdfx.DefaultBuilderOptions>(
                            options: const pdfx.DefaultBuilderOptions(),
                            documentLoaderBuilder: (_) => const Center(
                              child: CircularProgressIndicator(
                                color: AppColor.emeraldTeal,
                              ),
                            ),
                            pageLoaderBuilder: (_) => const Center(
                              child: CircularProgressIndicator(
                                color: AppColor.oceanBlue,
                              ),
                            ),
                            errorBuilder: (_, error) => Center(
                              child: Padding(
                                padding: EdgeInsets.all(20.r),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.error_outline_rounded,
                                      color: Colors.redAccent,
                                      size: 40,
                                    ),
                                    Gap(10.h),
                                    Text(
                                      'خطأ في عرض المستند: $error',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.redAccent,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // ── شريط التنقل السفلي الفاخر (Floating Bottom Controller) ──────
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Top App Bar
  // ───────────────────────────────────────────────────────────────────────────
  Widget _buildTopAppBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        border: Border(
          bottom: BorderSide(
            color: AppColor.whiteColor(context).withValues(alpha: 0.1),
          ),
        ),
      ),
      child: Row(
        children: [
          // زر الرجوع
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Container(
              padding: EdgeInsets.all(7.r),
              decoration: BoxDecoration(
                color: AppColor.whiteColor(context).withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: AppColor.whiteColor(context).withValues(alpha: 0.15)),
              ),
              child:  Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColor.whiteColor(context),
                size: 16,
              ),
            ),
          ),
          Gap(4.w),

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
                    color: AppColor.whiteColor(context),
                    fontWeight: FontWeight.bold,
                    fontSize: 13.5.sp,
                  ),
                ),
                Gap(2.h),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
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
                          border: Border.all(
                            color: AppColor.emeraldTeal.withValues(alpha: 0.4),
                          ),
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
                              'ASG DELTA API LIVE',
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
                            color: AppColor.whiteColor(context).withValues(alpha: 0.5),
                            fontSize: 9.5.sp,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          Gap(6.w),

          // زر التنزيل السريع
          _actionHeaderButton(
            icon: Icons.download_rounded,
            color: AppColor.emeraldTeal,
            tooltip: 'تنزيل PDF',
            isLoading: _isDownloading,
            onTap: _downloadFile,
          ),
          Gap(6.w),

          // زر فتح بتطبيق خارجي
          _actionHeaderButton(
            icon: Icons.open_in_new_rounded,
            color: AppColor.oceanBlue,
            tooltip: 'فتح في تطبيق خارجي',
            onTap: _openExternal,
          ),
        ],
      ),
    );
  }

  Widget _actionHeaderButton({
    required IconData icon,
    required Color color,
    required String tooltip,
    required VoidCallback onTap,
    bool isLoading = false,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: isLoading ? null : onTap,
        borderRadius: BorderRadius.circular(10.r),
        child: Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: color.withValues(alpha: 0.35)),
          ),
          child: isLoading
              ? SizedBox(
                  width: 16.r,
                  height: 16.r,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: color,
                  ),
                )
              : Icon(icon, color: color, size: 18.r),
        ),
      ),
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Quick Tools Bar (Zoom controls & Page Tracker)
  // ───────────────────────────────────────────────────────────────────────────
  Widget _buildQuickToolbar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        border: Border(
          bottom: BorderSide(
            color: AppColor.whiteColor(context).withValues(alpha: 0.06),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // عداد الصفحات
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: AppColor.whiteColor(context).withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.menu_book_rounded,
                  size: 13.r,
                  color: AppColor.mintTeal,
                ),
                Gap(6.w),
                Text(
                  'صفحة $_currentPage من $_totalPages',
                  style: TextStyle(
                    color: AppColor.whiteColor(context),
                    fontWeight: FontWeight.bold,
                    fontSize: 11.sp,
                  ),
                ),
              ],
            ),
          ),

          // أدوات التكبير والتصغير
          Row(
            children: [
              _zoomButton(
                icon: Icons.zoom_out_rounded,
                tooltip: 'تصغير',
                onTap: _zoomOut,
              ),
              Gap(4.w),
              InkWell(
                onTap: _resetZoom,
                borderRadius: BorderRadius.circular(6.r),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppColor.whiteColor(context).withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    '${(_currentScale * 100).toInt()}%',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Gap(4.w),
              _zoomButton(
                icon: Icons.zoom_in_rounded,
                tooltip: 'تكبير',
                onTap: _zoomIn,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _zoomButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6.r),
        child: Container(
          padding: EdgeInsets.all(5.r),
          decoration: BoxDecoration(
            color: AppColor.whiteColor(context).withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(6.r),
          ),
          child: Icon(icon, color: AppColor.whiteColor(context), size: 15.r),
        ),
      ),
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Bottom Bar
  // ───────────────────────────────────────────────────────────────────────────
  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        border: Border(
          top: BorderSide(
            color: AppColor.whiteColor(context).withValues(alpha: 0.1),
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
                borderRadius: BorderRadius.circular(10.r),
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: _currentPage > 1
                        ? AppColor.whiteColor(context).withValues(alpha: 0.12)
                        : AppColor.whiteColor(context).withValues(alpha: 0.04),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.chevron_right_rounded,
                        color: _currentPage > 1 ? AppColor.whiteColor(context) : Colors.white24,
                        size: 16.r,
                      ),
                      Gap(2.w),
                      Text(
                        'السابقة',
                        style: TextStyle(
                          color:
                              _currentPage > 1 ? AppColor.whiteColor(context) : Colors.white24,
                          fontSize: 10.5.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Gap(8.w),
              InkWell(
                onTap: _currentPage < _totalPages
                    ? () => _controller.nextPage(
                          curve: Curves.easeInOut,
                          duration: const Duration(milliseconds: 250),
                        )
                    : null,
                borderRadius: BorderRadius.circular(10.r),
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: _currentPage < _totalPages
                        ? AppColor.whiteColor(context).withValues(alpha: 0.12)
                        : AppColor.whiteColor(context).withValues(alpha: 0.04),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'التالية',
                        style: TextStyle(
                          color: _currentPage < _totalPages
                              ? AppColor.whiteColor(context)
                              : Colors.white24,
                          fontSize: 10.5.sp,
                        ),
                      ),
                      Gap(2.w),
                      Icon(
                        Icons.chevron_left_rounded,
                        color: _currentPage < _totalPages
                            ? AppColor.whiteColor(context)
                            : Colors.white24,
                        size: 16.r,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // زر التنزيل الأساسي
          InkWell(
            onTap: _downloadFile,
            borderRadius: BorderRadius.circular(12.r),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
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
                children: [
                  if (_isDownloading)
                    SizedBox(
                      width: 14.r,
                      height: 14.r,
                      child:  CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColor.whiteColor(context),
                      ),
                    )
                  else
                    Icon(
                      Icons.download_rounded,
                      color: AppColor.whiteColor(context),
                      size: 16.r,
                    ),
                  Gap(6.w),
                  Text(
                    _isDownloading ? 'جاري الحفظ...' : 'تنزيل التقرير (PDF)',
                    style: TextStyle(
                      color: AppColor.whiteColor(context),
                      fontWeight: FontWeight.bold,
                      fontSize: 11.sp,
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
}
