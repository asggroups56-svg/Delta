
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_template/core/custom_widgets/custom_toast/custom_toast.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/utils/common_methods.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdfx/pdfx.dart';

class _OcrVisualLine {
  final String text;
  final Rect box;

  _OcrVisualLine({
    required this.text,
    required this.box,
  });
}

class OcrItem {
  final String itemCode;
  String description;
  final String quantity;
  final String price;
  final String total;
  final String discount;
  final String vat;
  final String net;
  final String? name;

  OcrItem({
    required this.itemCode,
    required this.description,
    required this.quantity,
    required this.price,
    required this.total,
    required this.discount,
    required this.vat,
    required this.net,
    this.name,
  });
}

class PurchaseOcrScreen extends StatefulWidget {
  const PurchaseOcrScreen({super.key});

  @override
  State<PurchaseOcrScreen> createState() => _PurchaseOcrScreenState();
}

class _PurchaseOcrScreenState extends State<PurchaseOcrScreen>
    with TickerProviderStateMixin {
  // ── State ──────────────────────────────────────────────────────────────────

  File? _pickedImage;
  File? _pickedFile;

  String? _pickedFileName;
  String? _pickedFileExt;
  int? _pickedFileSizeBytes;

  bool _isProcessing = false;
  bool _showResults = false;
  bool _showRaw = false;

  String _rawOcrText = '';

  List<OcrItem> _items = [];

  // ── Animations ─────────────────────────────────────────────────────────────

  late AnimationController _laserCtrl;
  late Animation<double> _laserAnim;

  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;

  late AnimationController _resultFadeCtrl;
  late Animation<double> _resultFade;

  // ── ML Kit ─────────────────────────────────────────────────────────────────

  final TextRecognizer _textRecognizer = TextRecognizer(
    script: TextRecognitionScript.latin,
  );

  final ImagePicker _imagePicker = ImagePicker();

  // ── Accounting ─────────────────────────────────────────────────────────────

  String _accountCode = '5010 - مشتريات ومصروفات تشغيلية';

  // ───────────────────────────────────────────────────────────────────────────
  // Init
  // ───────────────────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();

    _laserCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _laserAnim = Tween<double>(
      begin: 0.03,
      end: 0.97,
    ).animate(
      CurvedAnimation(
        parent: _laserCtrl,
        curve: Curves.easeInOut,
      ),
    );

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _pulseAnim = Tween<double>(
      begin: 0.85,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _pulseCtrl,
        curve: Curves.easeInOut,
      ),
    );

    _resultFadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _resultFade = CurvedAnimation(
      parent: _resultFadeCtrl,
      curve: Curves.easeOut,
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Dispose
  // ───────────────────────────────────────────────────────────────────────────

  @override
  void dispose() {
    _laserCtrl.dispose();
    _pulseCtrl.dispose();
    _resultFadeCtrl.dispose();
    _textRecognizer.close();

    super.dispose();
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Pick Image
  // ───────────────────────────────────────────────────────────────────────────

  Future<void> _pickImage(ImageSource source) async {
    HapticFeedback.mediumImpact();

    try {
      final XFile? file = await _imagePicker.pickImage(
        source: source,
        imageQuality: 90,
        maxWidth: 2000,
      );

      if (file == null) return;

      final imageFile = File(file.path);

      if (!mounted) return;

      setState(() {
        _pickedImage = imageFile;
        _pickedFile = null;
        _pickedFileName = null;
        _pickedFileExt = null;
        _pickedFileSizeBytes = null;

        _showResults = false;
        _isProcessing = true;

        _rawOcrText = '';
        _items = [];
        _showRaw = false;
      });

      _resultFadeCtrl.reset();

      await _runOcr(imageFile);
    } catch (e) {
      debugPrint('Pick image error: $e');

      if (!mounted) return;

      setState(() {
        _isProcessing = false;
      });

      CommonMethods.showToast(
        message: 'تعذر اختيار الصورة، حاول مرة أخرى.',
        type: ToastType.error,
      );
    }
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Pick File
  // ───────────────────────────────────────────────────────────────────────────

  Future<void> _pickFile() async {
    HapticFeedback.mediumImpact();

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          'pdf',
          'jpg',
          'jpeg',
          'png',
          'webp',
          'bmp',
        ],
        withData: false,
        withReadStream: false,
      );

      if (result == null || result.files.isEmpty) return;

      final pf = result.files.first;
      final path = pf.path;

      if (path == null || path.isEmpty) {
        CommonMethods.showToast(
          message: 'تعذر الوصول إلى الملف المختار.',
          type: ToastType.error,
        );
        return;
      }

      final ext = (pf.extension ?? '').toLowerCase();

      final isImage = [
        'jpg',
        'jpeg',
        'png',
        'webp',
        'bmp',
      ].contains(ext);

      File stableFile;

      try {
        final appDir = await getApplicationDocumentsDirectory();

        final newPath =
            '${appDir.path}/picked_${DateTime.now().millisecondsSinceEpoch}.$ext';

        stableFile = await File(path).copy(newPath);
      } catch (e) {
        debugPrint('فشل نسخ الملف: $e');

        CommonMethods.showToast(
          message: 'تعذّر الوصول للملف المختار، حاول مرة أخرى.',
          type: ToastType.error,
        );

        return;
      }

      if (!mounted) return;

      setState(() {
        _pickedFile = stableFile;
        _pickedFileName = pf.name;
        _pickedFileExt = ext;
        _pickedFileSizeBytes = pf.size;

        _showResults = false;
        _isProcessing = true;

        _rawOcrText = '';
        _items = [];
        _showRaw = false;

        _pickedImage = isImage ? stableFile : null;
      });

      _resultFadeCtrl.reset();

      if (isImage) {
        await _runOcr(stableFile);
      } else if (ext == 'pdf') {
        await _runPdfOcr(pf.name);
      } else {
        if (!mounted) return;

        setState(() {
          _isProcessing = false;
        });

        CommonMethods.showToast(
          message: 'نوع الملف غير مدعوم.',
          type: ToastType.warning,
        );
      }
    } catch (e) {
      debugPrint('Pick file error: $e');

      if (!mounted) return;

      setState(() {
        _isProcessing = false;
      });

      CommonMethods.showToast(
        message: 'حدث خطأ أثناء اختيار الملف.',
        type: ToastType.error,
      );
    }
  }

  // ───────────────────────────────────────────────────────────────────────────
  // PDF OCR
  // ───────────────────────────────────────────────────────────────────────────

  Future<void> _runPdfOcr(String fileName) async {
    if (_pickedFile == null) return;

    PdfDocument? doc;

    try {
      doc = await PdfDocument.openFile(_pickedFile!.path);

      final combinedText = StringBuffer();

      File? firstPageImageFile;

      for (int i = 1; i <= doc.pagesCount; i++) {
        if (!mounted) break;

        final page = await doc.getPage(i);

        try {
          final pageImage = await page.render(
            width: page.width * 2,
            height: page.height * 2,
            format: PdfPageImageFormat.png,
          );

          if (pageImage == null) {
            continue;
          }

          final tempDir = await getTemporaryDirectory();

          final imgFile = File(
            '${tempDir.path}/pdf_page_${i}_${DateTime.now().millisecondsSinceEpoch}.png',
          );

          await imgFile.writeAsBytes(
            pageImage.bytes,
            flush: true,
          );

          firstPageImageFile ??= imgFile;

          final inputImage = InputImage.fromFile(imgFile);

          final RecognizedText recognized =
              await _textRecognizer.processImage(inputImage);

          final pageText = _buildLayoutAwareOcrText(recognized);

          if (pageText.trim().isNotEmpty) {
            combinedText.writeln(pageText);
          }
        } finally {
          await page.close();
        }
      }

      await doc.close();
      doc = null;

      if (!mounted) return;

      final rawText = combinedText.toString().trim();

      final extractedItems = _parseInvoiceItems(rawText);

      setState(() {
        _items = extractedItems;

        _rawOcrText = rawText.isEmpty
            ? '⚠️ لم يتم العثور على نص قابل للقراءة داخل الملف.\n\nاسم الملف: $fileName'
            : rawText;

        if (firstPageImageFile != null) {
          _pickedImage = firstPageImageFile;
        }

        _isProcessing = false;
        _showResults = true;
      });

      _resultFadeCtrl.forward();

      if (rawText.isNotEmpty || extractedItems.isNotEmpty) {
        CommonMethods.showToast(
          message: 'تم استخراج بيانات الفاتورة بالكامل من الملف بنجاح!',
          type: ToastType.success,
        );
      } else {
        CommonMethods.showToast(
          message: 'تعذّر استخراج بيانات واضحة من الفاتورة.',
          type: ToastType.warning,
        );
      }
    } catch (e, st) {
      debugPrint('PDF OCR error: $e');
      debugPrint('$st');

      if (doc != null) {
        try {
          await doc.close();
        } catch (_) {}
      }

      if (!mounted) return;

      setState(() {
        _isProcessing = false;
        _showResults = false;
      });

      CommonMethods.showToast(
        message: 'حدث خطأ أثناء قراءة ملف PDF.',
        type: ToastType.error,
      );
    }
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Image OCR
  // ───────────────────────────────────────────────────────────────────────────

  Future<void> _runOcr(File imageFile) async {
    try {
      final inputImage = InputImage.fromFile(imageFile);

      final RecognizedText recognized =
          await _textRecognizer.processImage(inputImage);

      final raw = _buildLayoutAwareOcrText(recognized);

      final extractedItems = _parseInvoiceItems(raw);

      if (!mounted) return;

      setState(() {
        _rawOcrText = raw;
        _items = extractedItems;
      });

      await Future.delayed(
        const Duration(milliseconds: 400),
      );

      if (!mounted) return;

      setState(() {
        _isProcessing = false;
        _showResults = true;
      });

      _resultFadeCtrl.forward();

      if (raw.trim().isNotEmpty) {
        CommonMethods.showToast(
          message: 'تم استخراج كل بيانات الفاتورة من الصورة بنجاح!',
          type: ToastType.success,
        );
      } else {
        CommonMethods.showToast(
          message: 'لم يتم العثور على نص واضح في الصورة.',
          type: ToastType.warning,
        );
      }
    } catch (e, st) {
      debugPrint('OCR error: $e');
      debugPrint('$st');

      if (!mounted) return;

      setState(() {
        _isProcessing = false;
        _showResults = false;
      });

      CommonMethods.showToast(
        message: 'تعذّر قراءة الصورة، تأكد من وضوح الفاتورة.',
        type: ToastType.error,
      );
    }
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Build OCR Text According To Visual Layout
  // ───────────────────────────────────────────────────────────────────────────

  String _buildLayoutAwareOcrText(
    RecognizedText recognized,
  ) {
    final lines = <_OcrVisualLine>[];

    for (final block in recognized.blocks) {
      for (final line in block.lines) {
        final text = line.text.trim();

        if (text.isEmpty) continue;

        lines.add(
          _OcrVisualLine(
            text: text,
            box: line.boundingBox,
          ),
        );
      }
    }

    if (lines.isEmpty) {
      return recognized.text.trim();
    }

    lines.sort((a, b) {
      final dy = a.box.center.dy.compareTo(
        b.box.center.dy,
      );

      if (dy != 0) {
        return dy;
      }

      return a.box.left.compareTo(
        b.box.left,
      );
    });

    final rows = <List<_OcrVisualLine>>[];

    for (final line in lines) {
      int? bestRow;
      double bestDistance = double.infinity;

      for (int i = 0; i < rows.length; i++) {
        final row = rows[i];

        if (row.isEmpty) continue;

        final minTop = row
            .map((e) => e.box.top)
            .reduce((a, b) => a < b ? a : b);

        final maxBottom = row
            .map((e) => e.box.bottom)
            .reduce((a, b) => a > b ? a : b);

        final rowCenter = (minTop + maxBottom) / 2;
        final lineCenter = line.box.center.dy;

        final rowHeight = maxBottom - minTop;
        final lineHeight = line.box.height;

        final overlaps =
            line.box.bottom >= minTop && line.box.top <= maxBottom;

        final tolerance =
            (rowHeight > lineHeight ? rowHeight : lineHeight) * 0.55 + 4;

        final distance = (lineCenter - rowCenter).abs();

        if (overlaps || distance <= tolerance) {
          if (distance < bestDistance) {
            bestDistance = distance;
            bestRow = i;
          }
        }
      }

      if (bestRow == null) {
        rows.add([line]);
      } else {
        rows[bestRow].add(line);
      }
    }

    final buffer = StringBuffer();

    for (final row in rows) {
      row.sort(
        (a, b) => a.box.left.compareTo(b.box.left),
      );

      final rowText = row
          .map((e) => e.text)
          .join(' ')
          .replaceAll(RegExp(r'\s+'), ' ')
          .trim();

      if (rowText.isNotEmpty) {
        buffer.writeln(rowText);
      }
    }

    return buffer.toString().trim();
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Normalize Arabic / Persian Digits
  // ───────────────────────────────────────────────────────────────────────────

  String _normalizeInvoiceDigits(String value) {
    const arabic = '٠١٢٣٤٥٦٧٨٩';
    const persian = '۰۱۲۳۴۵۶۷۸۹';

    return value.split('').map((char) {
      final arabicIndex = arabic.indexOf(char);

      if (arabicIndex >= 0) {
        return arabicIndex.toString();
      }

      final persianIndex = persian.indexOf(char);

      if (persianIndex >= 0) {
        return persianIndex.toString();
      }

      return char;
    }).join();
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Numeric Helpers
  // ───────────────────────────────────────────────────────────────────────────

  bool _isNumericToken(String value) {
    final v = _normalizeInvoiceDigits(value)
        .replaceAll(',', '')
        .replaceAll('٫', '.')
        .replaceAll('٬', '')
        .trim();

    return RegExp(
      r'^-?\d+(?:\.\d+)?$',
    ).hasMatch(v);
  }

  String _cleanNumber(String value) {
    return _normalizeInvoiceDigits(value)
        .replaceAll('٫', '.')
        .replaceAll('٬', '')
        .replaceAll(',', '')
        .trim();
  }

  double _toDouble(String value) {
    final cleaned = _cleanNumber(value);

    return double.tryParse(cleaned) ?? 0;
  }

  String _formatNumber(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }

    return value.toStringAsFixed(2);
  }

  bool _isEmptyOcrValue(String value) {
    final v = value.trim();

    return v.isEmpty ||
        v == '—' ||
        v == '-' ||
        v == 'غير معروف' ||
        v == 'غير محدد';
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Item Code Detection
  // ───────────────────────────────────────────────────────────────────────────

  String? _extractItemCode(String token) {
    final original = token.trim();

    if (original.isEmpty) {
      return null;
    }

    // السعر / الإجمالي ليس كود صنف
    if (original.contains('.') ||
        original.contains(',') ||
        original.contains('٫') ||
        original.contains('٬')) {
      return null;
    }

    final normalized = _normalizeInvoiceDigits(original);

    final cleaned = normalized.replaceAll(
      RegExp(r'[^A-Za-z0-9]'),
      '',
    );

    final digits = cleaned.replaceAll(
      RegExp(r'[^0-9]'),
      '',
    );

    if (digits.length < 3 || digits.length > 8) {
      return null;
    }

    // كود رقمي فقط
    if (RegExp(r'^\d{3,8}$').hasMatch(cleaned)) {
      return digits;
    }

    // كود مثل ABC3495
    final letters = cleaned.replaceAll(
      RegExp(r'[0-9]'),
      '',
    );

    if (letters.isNotEmpty &&
        letters.length <= 6 &&
        RegExp(r'^[A-Za-z]+$').hasMatch(letters)) {
      return digits;
    }

    return null;
  }
  bool _isTotalsLine(String line) {
    final lower = line.toLowerCase();

    return lower.contains('total') ||
        lower.contains('subtotal') ||
        lower.contains('grand total') ||
        lower.contains('net before') ||
        lower.contains('vat %') ||
        lower.contains('tax amount') ||
        lower.contains('discount') ||
        lower.contains('الإجمالي') ||
        lower.contains('المجموع') ||
        lower.contains('المجموع الكلي') ||
        lower.contains('الصافي قبل') ||
        lower.contains('ضريبة قيمة') ||
        lower.contains('ضريبة القيمة') ||
        lower.contains('الضريبة') ||
        lower.contains('الخصم');
  }

  List<OcrItem> _parseInvoiceItems(String text) {
    final normalizedText = _normalizeInvoiceDigits(text);

    final lines = normalizedText
        .split(RegExp(r'\r?\n'))
        .map(
          (line) => line
              .replaceAll(RegExp(r'\s+'), ' ')
              .trim(),
        )
        .where((line) => line.isNotEmpty)
        .toList();

    if (lines.isEmpty) {
      return [];
    }

    int tableStart = 0;

    for (int i = 0; i < lines.length; i++) {
      final lower = lines[i].toLowerCase();

      final isTableHeader =
          lower.contains('item code') ||
          lower.contains('item code') ||
          (lower.contains('item') && lower.contains('qty')) ||
          (lower.contains('price') && lower.contains('qty')) ||
          lower.contains('رمز الصنف') ||
          (lower.contains('الصنف') && lower.contains('الكمية')) ||
          (lower.contains('السعر') && lower.contains('الكمية'));

      if (isTableHeader) {
        tableStart = i + 1;
        break;
      }
    }

    final rows = <String>[];
    String? currentRow;

    for (int lineIndex = tableStart;
        lineIndex < lines.length;
        lineIndex++) {
      final line = lines[lineIndex];

      if (_isTotalsLine(line)) {
        if (currentRow != null) {
          rows.add(currentRow);
          currentRow = null;
        }

        continue;
      }

      final tokens = line.split(RegExp(r'\s+'));

      final numericCount = tokens.where(_isNumericToken).length;
      String? code;
      for (int i = tokens.length - 1; i >= 0; i--) {
        final foundCode = _extractItemCode(tokens[i]);

        if (foundCode != null) {
          code = foundCode;
          break;
        }
      }

      final looksLikeItem = code != null && numericCount >= 4;

      if (looksLikeItem) {
        if (currentRow != null) {
          rows.add(currentRow);
        }

        currentRow = line;
      } else if (currentRow != null) {
        // استمرار لوصف الصنف.
        currentRow = '$currentRow $line';
      }
    }

    if (currentRow != null) {
      rows.add(currentRow);
    }

    final result = <OcrItem>[];

    for (final rowText in rows) {
      final tokens = rowText.split(RegExp(r'\s+'));

      int? codeIndex;
      String? itemCode;

      // نبحث عن آخر كود صالح.
      for (int i = tokens.length - 1; i >= 0; i--) {
        final code = _extractItemCode(tokens[i]);

        if (code != null) {
          codeIndex = i;
          itemCode = code;
          break;
        }
      }

      if (codeIndex == null || itemCode == null) {
        continue;
      }

      final numericValues = <String>[];

      for (int i = 0; i < tokens.length; i++) {
        if (i == codeIndex) {
          continue;
        }

        if (_isNumericToken(tokens[i])) {
          numericValues.add(
            _cleanNumber(tokens[i]),
          );
        }
      }

      if (numericValues.length < 4) {
        continue;
      }

      final hasDiscount = numericValues.length >= 6;

      final List<String> values;

      if (numericValues.length >= 6) {
        values = numericValues.sublist(
          numericValues.length - 6,
        );
      } else if (numericValues.length >= 5) {
        values = numericValues.sublist(
          numericValues.length - 5,
        );
      } else {
        values = numericValues.sublist(
          numericValues.length - 4,
        );
      }

      String net = '—';
      String vat = '—';
      String discount = '—';
      String total = '—';
      String price = '—';
      String quantity = '1';

      if (values.length >= 6) {
        // NET VAT DISCOUNT TOTAL PRICE QTY
        net = values[0];
        vat = values[1];
        discount = values[2];
        total = values[3];
        price = values[4];
        quantity = values[5];
      } else if (values.length == 5) {
        // NET VAT TOTAL PRICE QTY
        net = values[0];
        vat = values[1];
        total = values[2];
        price = values[3];
        quantity = values[4];
      } else {
        // OCR fallback
        net = values[0];
        vat = values[1];
        total = values[2];
        price = values[3];
        quantity = '1';
      }

  
      final descriptionParts = <String>[];

      int numericSeenFromEnd = 0;

      for (int i = tokens.length - 1; i >= 0; i--) {
        if (i == codeIndex) {
          continue;
        }
        if (_isNumericToken(tokens[i]) &&
            numericSeenFromEnd < values.length) {
          numericSeenFromEnd++;
          continue;
        }
        descriptionParts.add(tokens[i]);
      }
      final description = descriptionParts
          .reversed
          .join(' ')
          .replaceAll(RegExp(r'\s+'), ' ')
          .trim();

      final finalDescription = description.isEmpty
          ? 'صنف رقم $itemCode'
          : description;

      result.add(
        OcrItem(
          itemCode: itemCode,
          description: finalDescription,
          quantity: quantity,
          price: price,
          total: total,
          discount: hasDiscount ? discount : '—',
          vat: vat,
          net: net,
        ),
      );
    }

    // إزالة التكرار.
    final unique = <String, OcrItem>{};

    for (final item in result) {
      final key =
          '${item.itemCode}|'
          '${item.quantity}|'
          '${item.price}|'
          '${item.total}|'
          '${item.net}|'
          '${item.vat}|'
          '${item.discount}';

      if (!unique.containsKey(key)) {
        unique[key] = item;
      }
    }

    return unique.values.toList();
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Find From Lines Then Full Text
  // ───────────────────────────────────────────────────────────────────────────

  String _findInvoiceValue(
    String text,
    List<RegExp> patterns, {
    String fallback = '—',
  }) {
    final normalized = _normalizeInvoiceDigits(text);

    final lines = normalized
        .split(RegExp(r'\r?\n'))
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();

    // البحث داخل كل سطر.
    for (final pattern in patterns) {
      for (final line in lines) {
        final match = pattern.firstMatch(line);

        if (match != null) {
          if (match.groupCount >= 1) {
            final value = match.group(1)?.trim();

            if (value != null && value.isNotEmpty) {
              return value;
            }
          }

          final full = match.group(0)?.trim();

          if (full != null && full.isNotEmpty) {
            return full;
          }
        }
      }
    }

    // البحث في النص كامل.
    for (final pattern in patterns) {
      final match = pattern.firstMatch(normalized);

      if (match != null) {
        if (match.groupCount >= 1) {
          final value = match.group(1)?.trim();

          if (value != null && value.isNotEmpty) {
            return value;
          }
        }

        final full = match.group(0)?.trim();

        if (full != null && full.isNotEmpty) {
          return full;
        }
      }
    }

    return fallback;
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Confirm
  // ───────────────────────────────────────────────────────────────────────────

  void _confirmPost() {
    HapticFeedback.mediumImpact();

    CommonMethods.showToast(
      message: 'تم ترحيل الفاتورة إلى قيود اليومية بنجاح! ✅',
      type: ToastType.success,
    );

    Navigator.pop(context);
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Reset
  // ───────────────────────────────────────────────────────────────────────────

  void _resetScanner() {
    setState(() {
      _pickedImage = null;
      _pickedFile = null;
      _pickedFileName = null;
      _pickedFileExt = null;
      _pickedFileSizeBytes = null;

      _showResults = false;
      _isProcessing = false;

      _items = [];
      _rawOcrText = '';

      _showRaw = false;
    });

    _resultFadeCtrl.reset();
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Build
  // ───────────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final hasResults = _showResults;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0F1E),
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(
          16.w,
          0,
          16.w,
          30.h,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(12.h),
            _buildHeaderBadge(),
            Gap(16.h),
            _buildScannerArea(),
            Gap(16.h),
            _buildPickerButtons(),
            Gap(20.h),

            if (_isProcessing)
              _buildProcessingCard(),

            if (hasResults)
  FadeTransition(
    opacity: _resultFade,
    child: Column(
      children: [
        _buildItemsSection(),
        Gap(20.h),
        _buildAccountingSection(),
        Gap(20.h),
        _buildConfirmButton(),
      ],
    ),
  )
            else if (!_isProcessing &&
                _pickedImage == null &&
                _pickedFile == null)
              _buildEmptyHint(),
          ],
        ),
      ),
    );
  }
Widget _buildItemsSection() {
  if (_items.isEmpty) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: Colors.orange,
            size: 20.r,
          ),
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

  return Directionality(
    textDirection: TextDirection.rtl,
    child: Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.r),
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
          Row(
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
                padding: EdgeInsets.symmetric(
                  horizontal: 9.w,
                  vertical: 5.h,
                ),
                decoration: BoxDecoration(
                  color: AppColor.emeraldTeal.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  '${_items.length} صنف',
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

          Gap(12.h),

          ...List.generate(
            _items.length,
            (index) => _buildDynamicItemCard(
              _items[index],
              index,
            ),
          ),
        ],
      ),
    ),
  );
}
  // ───────────────────────────────────────────────────────────────────────────
  // AppBar
  // ───────────────────────────────────────────────────────────────────────────

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF0F172A),
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Colors.white,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'مسح الفواتير بالذكاء الاصطناعي',
        style: TextStyle(
          fontSize: 15.sp,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          fontFamily: 'Tajawal',
        ),
      ),
      actions: [
        Container(
          margin: EdgeInsets.symmetric(
            horizontal: 12.w,
            vertical: 10.h,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 10.w,
            vertical: 2.h,
          ),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF10B981),
                Color(0xFF06B6D4),
              ],
            ),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.document_scanner_rounded,
                color: Colors.white,
                size: 11.r,
              ),
              Gap(4.w),
              Text(
                'OCR AI',
                style: TextStyle(
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  fontFamily: 'Tajawal',
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Header
  // ───────────────────────────────────────────────────────────────────────────

  Widget _buildHeaderBadge() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF4F46E5).withValues(alpha: 0.18),
            const Color(0xFF06B6D4).withValues(alpha: 0.10),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: const Color(0xFF4F46E5).withValues(alpha: 0.3),
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF4F46E5),
                  Color(0xFF06B6D4),
                ],
              ),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.auto_awesome_rounded,
              color: Colors.white,
              size: 20.r,
            ),
          ),
          Gap(12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'استخراج بيانات الفاتورة تلقائياً',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Tajawal',
                  ),
                ),
                Gap(2.h),
                Text(
                  'التقط صورة أو اختر من المعرض أو ارفع ملف PDF',
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: Colors.white.withValues(alpha: 0.55),
                    fontFamily: 'Tajawal',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Scanner
  // ───────────────────────────────────────────────────────────────────────────

  Widget _buildScannerArea() {
    return Container(
      height: 230.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: _showResults
              ? AppColor.emeraldTeal.withValues(alpha: 0.7)
              : const Color(0xFF4F46E5).withValues(alpha: 0.4),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: (_showResults
                    ? AppColor.emeraldTeal
                    : const Color(0xFF4F46E5))
                .withValues(alpha: 0.15),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (_pickedImage != null)
              Positioned.fill(
                child: Image.file(
                  _pickedImage!,
                  fit: BoxFit.cover,
                  color: _isProcessing
                      ? Colors.black.withValues(alpha: 0.45)
                      : _showResults
                          ? Colors.black.withValues(alpha: 0.30)
                          : null,
                  colorBlendMode: BlendMode.darken,
                ),
              )
            else if (_pickedFile != null && _pickedImage == null)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF1A0A2E),
                        const Color(0xFF2D1B69).withValues(alpha: 0.8),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: EdgeInsets.all(16.r),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEF4444)
                                .withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(
                              color: const Color(0xFFEF4444)
                                  .withValues(alpha: 0.4),
                            ),
                          ),
                          child: Icon(
                            Icons.picture_as_pdf_rounded,
                            color: const Color(0xFFEF4444),
                            size: 42.r,
                          ),
                        ),
                        Gap(10.h),
                        Text(
                          _pickedFileName ?? 'ملف PDF',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                        Gap(4.h),
                        Text(
                          '${((_pickedFileSizeBytes ?? 0) / 1024).toStringAsFixed(1)} KB  •  PDF',
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.white.withValues(alpha: 0.5),
                            fontFamily: 'Tajawal',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF0F172A),
                        Color(0xFF1E293B),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ScaleTransition(
                          scale: _pulseAnim,
                          child: Icon(
                            Icons.document_scanner_outlined,
                            color: const Color(0xFF4F46E5)
                                .withValues(alpha: 0.7),
                            size: 52.r,
                          ),
                        ),
                        Gap(10.h),
                        Text(
                          'اختر صورة أو ارفع ملف للبدء',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.white.withValues(alpha: 0.7),
                            fontFamily: 'Tajawal',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // Corners
            Positioned(
              top: 14.r,
              left: 14.r,
              child: _corner(
                isTop: true,
                isLeft: true,
              ),
            ),

            Positioned(
              top: 14.r,
              right: 14.r,
              child: _corner(
                isTop: true,
                isLeft: false,
              ),
            ),

            Positioned(
              bottom: 14.r,
              left: 14.r,
              child: _corner(
                isTop: false,
                isLeft: true,
              ),
            ),

            Positioned(
              bottom: 14.r,
              right: 14.r,
              child: _corner(
                isTop: false,
                isLeft: false,
              ),
            ),

            // Laser
            if (!_showResults)
              AnimatedBuilder(
                animation: _laserAnim,
                builder: (ctx, child) {
                  return Positioned(
                    top: _laserAnim.value * 218.h,
                    left: 18.w,
                    right: 18.w,
                    child: Container(
                      height: 2.h,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Colors.transparent,
                            Color(0xFF06B6D4),
                            Color(0xFF4F46E5),
                            Color(0xFF06B6D4),
                            Colors.transparent,
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF06B6D4)
                                .withValues(alpha: 0.9),
                            blurRadius: 12,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

            // Success
            if (_showResults)
              Positioned(
                bottom: 12.h,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColor.emeraldTeal.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check_circle_rounded,
                          color: Colors.white,
                          size: 14.r,
                        ),
                        Gap(6.w),
                        Text(
                          'تم استخراج كل بيانات الفاتورة',
                          style: TextStyle(
                            fontSize: 10.5.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'Tajawal',
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
    );
  }

  Widget _corner({
    required bool isTop,
    required bool isLeft,
  }) {
    return Container(
      width: 20.r,
      height: 20.r,
      decoration: BoxDecoration(
        border: Border(
          top: isTop
              ? const BorderSide(
                  color: Color(0xFF06B6D4),
                  width: 2.5,
                )
              : BorderSide.none,
          bottom: !isTop
              ? const BorderSide(
                  color: Color(0xFF06B6D4),
                  width: 2.5,
                )
              : BorderSide.none,
          left: isLeft
              ? const BorderSide(
                  color: Color(0xFF06B6D4),
                  width: 2.5,
                )
              : BorderSide.none,
          right: !isLeft
              ? const BorderSide(
                  color: Color(0xFF06B6D4),
                  width: 2.5,
                )
              : BorderSide.none,
        ),
      ),
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Picker Buttons
  // ───────────────────────────────────────────────────────────────────────────

  Widget _buildPickerButtons() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _pickerBtn(
                label: 'كاميرا',
                icon: Icons.camera_alt_rounded,
                color: const Color(0xFF4F46E5),
                onTap: () => _pickImage(
                  ImageSource.camera,
                ),
              ),
            ),
            Gap(10.w),
            Expanded(
              child: _pickerBtn(
                label: 'معرض الصور',
                icon: Icons.photo_library_rounded,
                color: const Color(0xFF0EA5E9),
                onTap: () => _pickImage(
                  ImageSource.gallery,
                ),
              ),
            ),
            Gap(10.w),
            Expanded(
              child: _pickerBtn(
                label: 'إعادة المسح',
                icon: Icons.refresh_rounded,
                color: const Color(0xFF10B981),
                onTap: _resetScanner,
              ),
            ),
          ],
        ),
        Gap(10.h),
        _buildFileUploadRow(),
      ],
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // File Upload
  // ───────────────────────────────────────────────────────────────────────────

  Widget _buildFileUploadRow() {
    final hasPicked = _pickedFile != null;

    return InkWell(
      onTap: _pickFile,
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 13.h,
        ),
        decoration: BoxDecoration(
          color: hasPicked
              ? const Color(0xFF8B5CF6).withValues(alpha: 0.14)
              : const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: hasPicked
                ? const Color(0xFF8B5CF6).withValues(alpha: 0.55)
                : Colors.white.withValues(alpha: 0.12),
            width: hasPicked ? 1.4 : 1.0,
          ),
        ),
        child: hasPicked
            ? _buildFilePreviewRow()
            : _buildFileUploadPlaceholder(),
      ),
    );
  }

  Widget _buildFileUploadPlaceholder() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: const Color(0xFF8B5CF6).withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(
            Icons.upload_file_rounded,
            color: const Color(0xFF8B5CF6),
            size: 20.r,
          ),
        ),
        Gap(12.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'رفع ملف (PDF / صورة)',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Tajawal',
              ),
            ),
            Text(
              'يدعم: PDF • JPG • PNG • WEBP',
              style: TextStyle(
                fontSize: 9.5.sp,
                color: Colors.white.withValues(alpha: 0.45),
                fontFamily: 'Tajawal',
              ),
            ),
          ],
        ),
        const Spacer(),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 10.w,
            vertical: 4.h,
          ),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF8B5CF6),
                Color(0xFF4F46E5),
              ],
            ),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Text(
            'اختيار',
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'Tajawal',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilePreviewRow() {
    final ext = (_pickedFileExt ?? '').toUpperCase();

    final sizeKb =
        ((_pickedFileSizeBytes ?? 0) / 1024).toStringAsFixed(1);

    final isPdf = ext == 'PDF';

    return Row(
      children: [
        Container(
          width: 44.r,
          height: 44.r,
          decoration: BoxDecoration(
            color: isPdf
                ? const Color(0xFFEF4444).withValues(alpha: 0.15)
                : const Color(0xFF0EA5E9).withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isPdf
                    ? Icons.picture_as_pdf_rounded
                    : Icons.image_rounded,
                color: isPdf
                    ? const Color(0xFFEF4444)
                    : const Color(0xFF0EA5E9),
                size: 20.r,
              ),
              Text(
                ext,
                style: TextStyle(
                  fontSize: 7.sp,
                  fontWeight: FontWeight.bold,
                  color: isPdf
                      ? const Color(0xFFEF4444)
                      : const Color(0xFF0EA5E9),
                  fontFamily: 'Tajawal',
                ),
              ),
            ],
          ),
        ),
        Gap(12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _pickedFileName ?? 'ملف مرفق',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Tajawal',
                ),
              ),
              Gap(2.h),
              Text(
                '$sizeKb KB  •  $ext',
                style: TextStyle(
                  fontSize: 9.5.sp,
                  color: Colors.white.withValues(alpha: 0.5),
                  fontFamily: 'Tajawal',
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: _pickFile,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 10.w,
              vertical: 4.h,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF8B5CF6).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: const Color(0xFF8B5CF6).withValues(alpha: 0.4),
              ),
            ),
            child: Text(
              'تغيير',
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF8B5CF6),
                fontFamily: 'Tajawal',
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _pickerBtn({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 11.h,
        ),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: color.withValues(alpha: 0.35),
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 22.r,
            ),
            Gap(4.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Tajawal',
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Processing
  // ───────────────────────────────────────────────────────────────────────────

  Widget _buildProcessingCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: const Color(0xFF4F46E5).withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            width: 40.r,
            height: 40.r,
            child: const CircularProgressIndicator(
              color: Color(0xFF06B6D4),
              strokeWidth: 3,
            ),
          ),
          Gap(14.h),
          Text(
            'جاري تحليل الفاتورة بالذكاء الاصطناعي...',
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'Tajawal',
            ),
          ),
          Gap(6.h),
          Text(
            'قراءة النص • حفظ كل البيانات • تحليل الأصناف',
            style: TextStyle(
              fontSize: 10.sp,
              color: Colors.white.withValues(alpha: 0.5),
              fontFamily: 'Tajawal',
            ),
          ),
          Gap(16.h),
          _processingStep(
            'قراءة الصورة وتحسين الجودة',
            true,
          ),
          _processingStep(
            'استخراج النصوص بتقنية OCR',
            true,
          ),
          _processingStep(
            'تحليل الأصناف مع الاحتفاظ بكل بيانات الفاتورة',
            false,
          ),
        ],
      ),
    );
  }

  Widget _processingStep(
    String label,
    bool done,
  ) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: 6.h,
      ),
      child: Row(
        children: [
          Icon(
            done
                ? Icons.check_circle_rounded
                : Icons.radio_button_unchecked,
            color: done
                ? AppColor.emeraldTeal
                : Colors.white.withValues(alpha: 0.3),
            size: 16.r,
          ),
          Gap(8.w),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 11.sp,
                color: done
                    ? Colors.white.withValues(alpha: 0.8)
                    : Colors.white.withValues(alpha: 0.4),
                fontFamily: 'Tajawal',
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // ALL INVOICE DATA
  // ───────────────────────────────────────────────────────────────────────────

  
 

  // ───────────────────────────────────────────────────────────────────────────
  // Dynamic Item Card
  // ───────────────────────────────────────────────────────────────────────────

  Widget _buildDynamicItemCard(
    OcrItem item,
    int index,
  ) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(
        bottom: 8.h,
      ),
      padding: EdgeInsets.all(11.r),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColor.emeraldTeal.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 30.r,
                height: 30.r,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColor.emeraldTeal.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColor.emeraldTeal,
                    fontFamily: 'Tajawal',
                  ),
                ),
              ),
              Gap(8.w),
              Expanded(
                child: Text(
                  item.description.isEmpty
                      ? 'صنف بدون وصف'
                      : item.description,
                  style: TextStyle(
                    fontSize: 11.5.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Tajawal',
                    height: 1.4,
                  ),
                ),
              ),
              Gap(6.w),
              Text(
                item.itemCode,
                style: TextStyle(
                  fontSize: 9.5.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColor.emeraldTeal,
                  fontFamily: 'Tajawal',
                ),
              ),
            ],
          ),
          Gap(9.h),
          Wrap(
            spacing: 6.w,
            runSpacing: 6.h,
            children: [
              _dynamicValueChip(
                'الكمية',
                item.quantity,
              ),
              _dynamicValueChip(
                'السعر',
                item.price,
              ),
              _dynamicValueChip(
                'الإجمالي',
                item.total,
              ),
              _dynamicValueChip(
                'الضريبة',
                item.vat,
              ),
              _dynamicValueChip(
                'الصافي',
                item.net,
              ),
              if (item.discount != '—')
                _dynamicValueChip(
                  'الخصم',
                  item.discount,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _dynamicValueChip(
    String label,
    String value,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8.w,
        vertical: 6.h,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.035),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.06),
        ),
      ),
      child: Text(
        '$label: $value',
        style: TextStyle(
          fontSize: 9.sp,
          color: Colors.white.withValues(alpha: 0.75),
          fontFamily: 'Tajawal',
        ),
      ),
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Accounting
  // ───────────────────────────────────────────────────────────────────────────

  Widget _buildAccountingSection() {
    const accounts = [
      '5010 - مشتريات ومصروفات تشغيلية',
      '5020 - مصروفات عمومية وإدارية',
      '1030 - مخزون البضائع والمستودعات',
      '1020 - أصول ثابتة ومعدات تقنية',
      '5030 - مصروفات التسويق والمبيعات',
    ];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: const Color(0xFF111827),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.08),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF59E0B)
                        .withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(9.r),
                  ),
                  child: Icon(
                    Icons.account_balance_rounded,
                    color: const Color(0xFFF59E0B),
                    size: 18.r,
                  ),
                ),
                Gap(8.w),
                Text(
                  'التوجيه المحاسبي',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Tajawal',
                  ),
                ),
              ],
            ),
            Gap(12.h),
            DropdownButtonFormField<String>(
              initialValue: _accountCode,
              isExpanded: true,
              dropdownColor: const Color(0xFF1E293B),
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Tajawal',
              ),
              decoration: InputDecoration(
                labelText: 'حساب المصروف',
                labelStyle: TextStyle(
                  fontSize: 11.sp,
                  color: Colors.white.withValues(alpha: 0.5),
                  fontFamily: 'Tajawal',
                ),
                prefixIcon: Icon(
                  Icons.folder_rounded,
                  color: const Color(0xFFF59E0B),
                  size: 18.r,
                ),
                filled: true,
                fillColor: const Color(0xFF1E293B),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 12.h,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: const BorderSide(
                    color: Color(0xFFF59E0B),
                    width: 1.2,
                  ),
                ),
              ),
              items: accounts.map(
                (acc) {
                  return DropdownMenuItem<String>(
                    value: acc,
                    child: Text(
                      acc,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  );
                },
              ).toList(),
              onChanged: (val) {
                if (val == null) return;

                setState(() {
                  _accountCode = val;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Confirm Button
  // ───────────────────────────────────────────────────────────────────────────

  Widget _buildConfirmButton() {
    return SizedBox(
      width: double.infinity,
      height: 50.h,
      child: ElevatedButton.icon(
        onPressed: _confirmPost,
        icon: const Icon(
          Icons.rocket_launch_rounded,
        ),
        label: Text(
          'تأكيد وترحيل الفاتورة إلى الحسابات',
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.bold,
            fontFamily: 'Tajawal',
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.emeraldTeal,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          elevation: 6,
          shadowColor: AppColor.emeraldTeal.withValues(
            alpha: 0.5,
          ),
        ),
      ),
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Empty Hint
  // ───────────────────────────────────────────────────────────────────────────

  Widget _buildEmptyHint() {
    final tips = [
      'تأكد من إضاءة جيدة عند التقاط الفاتورة',
      'أمسك الكاميرا ثابتة مباشرة فوق الفاتورة',
      'يمكن رفع صور JPG أو PNG من المعرض',
      'يمكن رفع ملف PDF يحتوي على أكثر من صفحة',
      'راجع النص الخام إذا كانت بعض الحقول فارغة',
    ];

    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.07),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.tips_and_updates_rounded,
                color: const Color(0xFFF59E0B),
                size: 18.r,
              ),
              Gap(8.w),
              Expanded(
                child: Text(
                  'نصائح للحصول على أفضل نتيجة OCR',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Tajawal',
                  ),
                ),
              ),
            ],
          ),
          Gap(14.h),
          ...tips.map(
            (tip) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: 8.h,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.check_circle_outline_rounded,
                      color: AppColor.emeraldTeal,
                      size: 14.r,
                    ),
                    Gap(8.w),
                    Expanded(
                      child: Text(
                        tip,
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: Colors.white.withValues(alpha: 0.65),
                          fontFamily: 'Tajawal',
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Confidence
  // ───────────────────────────────────────────────────────────────────────────

  String _calcConfidence() {
    if (_rawOcrText.trim().isEmpty && _items.isEmpty) {
      return '0';
    }

    final lineCount = _rawOcrText
        .split(RegExp(r'\r?\n'))
        .where(
          (line) => line.trim().isNotEmpty,
        )
        .length;

    final score = (
      (lineCount > 0 ? 70 : 0) +
      (_items.length * 5)
    ).clamp(0, 100);

    return score.toString();
  }
}
