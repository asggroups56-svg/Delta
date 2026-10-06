import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class FileDownloadService {
  FileDownloadService._();

  /// يحفظ ملفًا في مسار التنزيلات / المستندات للجهاز ويعيد الملف المحفوظ
  static Future<File?> saveFileToDevice({
    required File sourceFile,
    required String defaultFileName,
  }) async {
    try {
      Directory? targetDir;

      if (!kIsWeb) {
        if (Platform.isAndroid) {
          // جلب مجلد التنزيلات العام على أندرويد
          final androidDownloads = Directory('/storage/emulated/0/Download');
          if (await androidDownloads.exists()) {
            targetDir = androidDownloads;
          } else {
            targetDir = await getExternalStorageDirectory();
          }
        } else if (Platform.isIOS || Platform.isMacOS) {
          targetDir = await getApplicationDocumentsDirectory();
        } else if (Platform.isWindows || Platform.isLinux) {
          targetDir = await getDownloadsDirectory() ??
              await getApplicationDocumentsDirectory();
        }
      }

      targetDir ??= await getApplicationDocumentsDirectory();

      // تنظيف اسم الملف
      final cleanName = defaultFileName
          .replaceAll(RegExp(r'[\\/:*?"<>|]'), '_')
          .trim();
      final destinationPath = '${targetDir.path}/$cleanName';
      final savedFile = await sourceFile.copy(destinationPath);

      debugPrint('File successfully saved to: $destinationPath');
      return savedFile;
    } catch (e) {
      debugPrint('Error saving file: $e');
      return null;
    }
  }

  /// يفتح الملف في التطبيق المناسب في النظام (مثل Acrobat Reader أو النظام الافتراضي)
  static Future<bool> openFile(String filePath) async {
    final res = await OpenFile.open(filePath);
    return res.type == ResultType.done;
  }
}
