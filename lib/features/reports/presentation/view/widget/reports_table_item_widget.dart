import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';

class ReportsTableItemWidget extends StatelessWidget {
  final String title;
  final String searchQuery;
  final bool isSelected;
  final VoidCallback onSelect;
  final VoidCallback onExportPdf;
  final ValueChanged<String> onExportFormat;

  const ReportsTableItemWidget({
    super.key,
    required this.title,
    this.searchQuery = '',
    this.isSelected = false,
    required this.onSelect,
    required this.onExportPdf,
    required this.onExportFormat,
  });

  Future<void> _showExportFormats(BuildContext context) async {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final formats = <(String, IconData, String)>[
      ('pdf', Icons.picture_as_pdf_rounded, 'PDF'),
      ('excel', Icons.table_chart_rounded, isArabic ? 'إكسل' : 'Excel'),
      ('word', Icons.description_rounded, isArabic ? 'وورد' : 'Word'),
      (
        'excelformatted',
        Icons.grid_on_rounded,
        isArabic ? 'إكسل احترافي' : 'Excel PRO',
      ),
    ];
    final selectedFormat = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final (format, icon, label) in formats)
              ListTile(
                leading: Icon(icon),
                title: Text(label),
                onTap: () => Navigator.pop(context, format),
              ),
          ],
        ),
      ),
    );
    if (selectedFormat == null || !context.mounted) return;
    if (selectedFormat == 'pdf') {
      onExportPdf();
    } else {
      onExportFormat(selectedFormat);
    }
  }

  @override
  Widget build(BuildContext context) {
    final titleColor = AppColor.titleFormFiledColor(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          onSelect();
          onExportPdf();
        },
        onLongPress: () => _showExportFormats(context),
        child: SizedBox(
          height: 48.h,
          child: Padding(
            padding: EdgeInsetsDirectional.only(start: 18.w, end: 27.w),
          child: Row(
            children: [
              Expanded(
                child: _buildHighlightedTitle(
                  context,
                  title,
                  isSelected ? AppColor.primaryColor(context) : titleColor,
                ),
              ),
            ],
          ),
          ),
        ),
      ),
    );
  }

  Widget _buildHighlightedTitle(
    BuildContext context,
    String text,
    Color color,
  ) {
    final query = searchQuery.trim();
    final style = TextStyle(
      color: color,
      fontSize: 12.5.sp,
      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
    );
    if (query.isEmpty) {
      return Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: style,
      );
    }

    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();
    final matchIndex = lowerText.indexOf(lowerQuery);
    if (matchIndex < 0) {
      return Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: style,
      );
    }

    final matchEnd = matchIndex + lowerQuery.length;
    final accent = AppColor.primaryColor(context);
    return Text.rich(
      TextSpan(
        style: style,
        children: [
          TextSpan(text: text.substring(0, matchIndex)),
          TextSpan(
            text: text.substring(matchIndex, matchEnd),
            style: style.copyWith(
              color: accent,
              fontWeight: FontWeight.bold,
              backgroundColor: accent.withValues(alpha: 0.12),
            ),
          ),
          TextSpan(text: text.substring(matchEnd)),
        ],
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
