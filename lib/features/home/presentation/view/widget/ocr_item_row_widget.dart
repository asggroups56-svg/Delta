import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';

/// صف واحد من بيانات الصنف.
class OcrItemRow {
  final String itemCode;
  final String description;
  final String quantity;
  final String price;
  final String total;
  final String vat;
  final String net;
  final String discount;

  OcrItemRow({
    required this.itemCode,
    required this.description,
    required this.quantity,
    required this.price,
    required this.total,
    required this.vat,
    required this.net,
    required this.discount,
  });
}

class OcrItemsTable extends StatelessWidget {
  final List<OcrItemRow> items;

  const OcrItemsTable({super.key, required this.items});

  // ── أعمدة الجدول ─────────────────────────────────────────────────────────
  static const double _colIndex = 34;
  static const double _colCode = 70;
  static const double _colQty = 55;
  static const double _colPrice = 75;
  static const double _colTotal = 85;
  static const double _colVat = 70;
  static const double _colDiscount = 70;
  static const double _colNet = 85;
  static const double _colDescription = 180; // الحد الأدنى

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return _buildEmpty();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0A0F1E),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: AppColor.emeraldTeal.withValues(alpha: 0.25),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            Divider(
              height: 1,
              color: AppColor.emeraldTeal.withValues(alpha: 0.2),
            ),

            // ── الجدول القابل للتمرير أفقيًا ────────────────────────────
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildColumnHeaders(),
                  Divider(
                    height: 1,
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                  ...List.generate(
                    items.length,
                    (i) => _buildRow(i, items[i]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── رأس القسم (أيقونة + عنوان + عدد) ─────────────────────────────────────
  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.all(14.r),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(9.r),
            decoration: BoxDecoration(
              color: AppColor.emeraldTeal.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              Icons.inventory_2_rounded,
              color: AppColor.emeraldTeal,
              size: 19.r,
            ),
          ),
          Gap(10.w),
          Expanded(
            child: Text(
              'أصناف الفاتورة',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Tajawal',
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 5.h),
            decoration: BoxDecoration(
              color: AppColor.emeraldTeal.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              '${items.length} صنف',
              style: TextStyle(
                fontSize: 9.sp,
                fontWeight: FontWeight.bold,
                color: AppColor.emeraldTeal,
                fontFamily: 'Tajawal',
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── صف العناوين (Header) ─────────────────────────────────────────────────
  Widget _buildColumnHeaders() {
    return Container(
      color: Colors.white.withValues(alpha: 0.03),
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        children: [
          _headerCell('#', width: _colIndex, align: TextAlign.center),
          _headerCell('الكود', width: _colCode),
          _headerCell('الوصف', width: _colDescription, align: TextAlign.start),
          _headerCell('الكمية', width: _colQty),
          _headerCell('السعر', width: _colPrice),
          _headerCell('الإجمالي', width: _colTotal),
          _headerCell('الضريبة', width: _colVat),
          _headerCell('الخصم', width: _colDiscount),
          _headerCell('الصافي', width: _colNet),
        ],
      ),
    );
  }

  Widget _headerCell(
    String text, {
    required double width,
    TextAlign align = TextAlign.center,
  }) {
    return SizedBox(
      width: width.w,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w),
        child: Text(
          text,
          textAlign: align,
          style: TextStyle(
            fontSize: 10.sp,
            fontWeight: FontWeight.w800,
            color: AppColor.emeraldTeal,
            fontFamily: 'Tajawal',
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }

  // ── صف بيانات ────────────────────────────────────────────────────────────
  Widget _buildRow(int index, OcrItemRow item) {
    final isEven = index.isEven;

    return Container(
      color: isEven
          ? Colors.transparent
          : Colors.white.withValues(alpha: 0.02),
      padding: EdgeInsets.symmetric(vertical: 11.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _bodyCell(
            '${index + 1}',
            width: _colIndex,
            color: AppColor.emeraldTeal,
            weight: FontWeight.w800,
          ),
          _bodyCell(item.itemCode, width: _colCode, weight: FontWeight.bold),
          _bodyCell(
            item.description.isEmpty ? 'صنف بدون وصف' : item.description,
            width: _colDescription,
            align: TextAlign.start,
          ),
          _bodyCell(item.quantity, width: _colQty),
          _bodyCell(item.price, width: _colPrice),
          _bodyCell(
            item.total,
            width: _colTotal,
            color: AppColor.mintTeal,
            weight: FontWeight.bold,
          ),
          _bodyCell(item.vat, width: _colVat),
          _bodyCell(
            item.discount,
            width: _colDiscount,
            color: item.discount != '—'
                ? const Color(0xFFFF7675)
                : Colors.white.withValues(alpha: 0.35),
          ),
          _bodyCell(
            item.net,
            width: _colNet,
            color: AppColor.emeraldTeal,
            weight: FontWeight.bold,
          ),
        ],
      ),
    );
  }

  Widget _bodyCell(
    String text, {
    required double width,
    TextAlign align = TextAlign.center,
    Color? color,
    FontWeight? weight,
  }) {
    return SizedBox(
      width: width.w,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w),
        child: Text(
          text,
          textAlign: align,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 10.sp,
            fontWeight: weight ?? FontWeight.w500,
            color: color ?? Colors.white.withValues(alpha: 0.85),
            fontFamily: 'Tajawal',
            height: 1.35,
          ),
        ),
      ),
    );
  }

  // ── حالة عدم وجود أصناف ──────────────────────────────────────────────────
  Widget _buildEmpty() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline_rounded,
              color: Colors.orange, size: 20.r),
          Gap(8.w),
          Expanded(
            child: Text(
              'لم يتم التعرف على أصناف الفاتورة بشكل واضح.',
              style: TextStyle(
                fontSize: 11.sp,
                color: Colors.white.withValues(alpha: 0.7),
                fontFamily: 'Tajawal',
              ),
            ),
          ),
        ],
      ),
    );
  }
}