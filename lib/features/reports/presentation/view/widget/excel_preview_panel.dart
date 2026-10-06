import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';

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
        color: AppColor.cardColor(context),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColor.borderColor(context)),
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
                      color: AppColor.titleFormFiledColor(context),
                      fontWeight: FontWeight.bold,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
                if (onClose != null)
                  IconButton(
                    icon: Icon(
                      Icons.close_rounded,
                      color: AppColor.darkTextColor(context),
                      size: 18,
                    ),
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
                    AppColor.cardSurfaceColor(context),
                  ),
                  columns: rows.first
                      .map(
                        (h) => DataColumn(
                          label: Text(
                            h,
                            style: TextStyle(
                              color: AppColor.titleFormFiledColor(context),
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
                                      color: AppColor.darkTextColor(context),
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