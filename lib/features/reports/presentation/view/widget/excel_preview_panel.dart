import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ExcelPreviewPanel extends StatelessWidget {
  final List<List<String>> rows;
  final String title;
  final VoidCallback? onClose;

  const ExcelPreviewPanel({
    super.key,
    required this.rows,
    required this.title,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        children: [
          // ── رأس المعاينة ─────────────────────────────────────────────
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
                Icon(
                  Icons.table_chart_rounded,
                  color: const Color(0xFF10B981),
                  size: 18.r,
                ),
                Gap(8.w),
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
                if (onClose != null)
                  IconButton(
                    icon: const Icon(Icons.close_rounded,
                        color: Colors.white, size: 18),
                    onPressed: onClose,
                  ),
              ],
            ),
          ),

          // ── جسم المعاينة ─────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(12.r),
                child: DataTable(
                  headingRowColor: WidgetStateProperty.all(
                    Colors.white.withValues(alpha: 0.05),
                  ),
                  columns: rows.first
                      .map(
                        (h) => DataColumn(
                          label: Text(
                            h,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 11.sp,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                  rows: rows
                      .skip(1)
                      .map(
                        (r) => DataRow(
                          cells: r
                              .map(
                                (c) => DataCell(
                                  Text(
                                    c,
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 10.5.sp,
                                    ),
                                  ),
                                ),
                              )
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
    );
  }
}