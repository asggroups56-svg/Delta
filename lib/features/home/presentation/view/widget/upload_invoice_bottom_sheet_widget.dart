import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/routes/routes_name.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';

class UploadInvoiceBottomSheetWidget extends StatelessWidget {
  const UploadInvoiceBottomSheetWidget({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => const UploadInvoiceBottomSheetWidget(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 30.h),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Handle ─────────────────────────────────────────────────────
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.20),
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ),
          Gap(18.h),

          // ── Title ───────────────────────────────────────────────────────
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4F46E5), Color(0xFF06B6D4)],
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(Icons.document_scanner_rounded,
                    color: Colors.white, size: 20.r),
              ),
              Gap(12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'مسح فاتورة المشتريات',
                      style: AppTextStyle.text16SDark(context).copyWith(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'استخراج البيانات تلقائياً بتقنية OCR AI',
                      style: TextStyle(
                        fontSize: 10.5.sp,
                        color: Colors.white.withValues(alpha: 0.5),
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF10B981), Color(0xFF06B6D4)],
                  ),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  'OCR AI',
                  style: TextStyle(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    fontFamily: 'Tajawal',
                  ),
                ),
              ),
            ],
          ),
          Gap(20.h),

          // ── Feature highlights ──────────────────────────────────────────
          Container(
            padding: EdgeInsets.all(14.r),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(
                  color: const Color(0xFF4F46E5).withValues(alpha: 0.25)),
            ),
            child: Column(
              children: [
                _featureRow(
                  icon: Icons.table_chart_rounded,
                  color: const Color(0xFF06B6D4),
                  text: 'استخراج الحقول وعرضها في جدول قابل للتعديل',
                ),
                Gap(8.h),
                _featureRow(
                  icon: Icons.receipt_long_rounded,
                  color: const Color(0xFF10B981),
                  text: 'قراءة الرقم الضريبي والمبالغ وبيانات المورد',
                ),
                Gap(8.h),
                _featureRow(
                  icon: Icons.rocket_launch_rounded,
                  color: const Color(0xFF8B5CF6),
                  text: 'ترحيل مباشر إلى قيود اليومية بضغطة واحدة',
                ),
              ],
            ),
          ),
          Gap(20.h),

          // ── Main CTA button ─────────────────────────────────────────────
          SizedBox(
            width: double.infinity,
            height: 50.h,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, RoutesName.purchaseOcrScreen);
              },
              icon: const Icon(Icons.camera_alt_rounded),
              label: Text(
                'ابدأ مسح الفاتورة الآن',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Tajawal',
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.emeraldTeal,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),
                elevation: 6,
                shadowColor: AppColor.emeraldTeal.withValues(alpha: 0.4),
              ),
            ),
          ),
          Gap(10.h),

          // ── Secondary: gallery ──────────────────────────────────────────
          SizedBox(
            width: double.infinity,
            height: 44.h,
            child: OutlinedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, RoutesName.purchaseOcrScreen);
              },
              icon: Icon(Icons.photo_library_rounded,
                  size: 18.r, color: const Color(0xFF4F46E5)),
              label: Text(
                'اختيار صورة من المعرض',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF4F46E5),
                  fontFamily: 'Tajawal',
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                    color: const Color(0xFF4F46E5).withValues(alpha: 0.5)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _featureRow({
    required IconData icon,
    required Color color,
    required String text,
  }) {
    return Row(
      children: [
        Icon(icon, color: color, size: 16.r),
        Gap(10.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 11.sp,
              color: Colors.white.withValues(alpha: 0.7),
              fontFamily: 'Tajawal',
            ),
          ),
        ),
      ],
    );
  }
}
