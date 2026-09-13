import 'dart:io';
import 'package:excel/excel.dart' hide Border;
import 'package:path_provider/path_provider.dart';

class ExcelExportService {
  ExcelExportService._();

  static Future<File> generate({
    required String title,
    required String description,
    required String amount,
    required String date,
    required String status,
  }) async {
    final rows = <List<String>>[
      ['البند', 'التفاصيل', 'المبلغ', 'التاريخ', 'الحالة'],
      [title, description, amount, date, status],
    ];

    final excelDoc = Excel.createExcel();
    final sheet = excelDoc['Report'];

    for (final r in rows) {
      sheet.appendRow(r.map((e) => TextCellValue(e)).toList());
    }

    // حذف الورقة الافتراضية إن وُجدت.
    if (excelDoc.sheets.containsKey('Sheet1')) {
      excelDoc.delete('Sheet1');
    }

    final dir = await getTemporaryDirectory();
    final file = File(
      '${dir.path}/report_${DateTime.now().millisecondsSinceEpoch}.xlsx',
    );

    final bytes = excelDoc.encode();
    if (bytes == null) throw Exception('فشل ترميز ملف الإكسل');
    await file.writeAsBytes(bytes);

    return file;
  }
}