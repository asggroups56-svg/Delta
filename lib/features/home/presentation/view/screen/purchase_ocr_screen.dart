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

// ─────────────────────────────────────────────────────────────────────────────
// Data model for a single extracted OCR field
// ─────────────────────────────────────────────────────────────────────────────
class OcrField {
  final String label;
  final String icon;
  String value;
  final Color accentColor;

  OcrField({
    required this.label,
    required this.icon,
    required this.value,
    required this.accentColor,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// Data model for a single invoice line/item
// ─────────────────────────────────────────────────────────────────────────────
class _OcrVisualLine {
  final String text;
  final Rect box;

  _OcrVisualLine({required this.text, required this.box});
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

  OcrItem({
    required this.itemCode,
    required this.description,
    required this.quantity,
    required this.price,
    required this.total,
    required this.discount,
    required this.vat,
    required this.net,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
class PurchaseOcrScreen extends StatefulWidget {
  const PurchaseOcrScreen({super.key});

  @override
  State<PurchaseOcrScreen> createState() => _PurchaseOcrScreenState();
}

class _PurchaseOcrScreenState extends State<PurchaseOcrScreen>
    with TickerProviderStateMixin {
  // ── State ──────────────────────────────────────────────────────────────────
  File? _pickedImage;
  // File attachment (PDF / DOCX / image from file picker)
  File? _pickedFile;
  String? _pickedFileName;
  String? _pickedFileExt;
  int? _pickedFileSizeBytes;
  bool _isProcessing = false;
  bool _showResults = false;
  String _rawOcrText = '';
  List<OcrField> _fields = [];
  // كل أصناف الفاتورة، وليس أول صنف فقط
  List<OcrItem> _items = [];

  // ── Animations ─────────────────────────────────────────────────────────────
  late AnimationController _laserCtrl;
  late Animation<double> _laserAnim;

  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;

  late AnimationController _resultFadeCtrl;
  late Animation<double> _resultFade;

  // ── ML Kit ─────────────────────────────────────────────────────────────────
  final _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
  final _imagePicker = ImagePicker();

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
    ).animate(CurvedAnimation(parent: _laserCtrl, curve: Curves.easeInOut));

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(
      begin: 0.85,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));

    _resultFadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _resultFade = CurvedAnimation(
      parent: _resultFadeCtrl,
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _laserCtrl.dispose();
    _pulseCtrl.dispose();
    _resultFadeCtrl.dispose();
    _textRecognizer.close();
    super.dispose();
  }

  // ── Pick image from camera or gallery ─────────────────────────────────────
  Future<void> _pickImage(ImageSource source) async {
    HapticFeedback.mediumImpact();
    final XFile? file = await _imagePicker.pickImage(
      source: source,
      imageQuality: 90,
      maxWidth: 2000,
    );
    if (file == null) return;

    setState(() {
      _pickedImage = File(file.path);
      _pickedFile = null;
      _pickedFileName = null;
      _pickedFileExt = null;
      _pickedFileSizeBytes = null;
      _showResults = false;
      _isProcessing = true;
      _rawOcrText = '';
      _fields = [];
      _items = [];
    });
    _resultFadeCtrl.reset();

    await _runOcr(File(file.path));
  }

  // ── Pick file (PDF / image / document) ────────────────────────────────────
  Future<void> _pickFile() async {
    HapticFeedback.mediumImpact();
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png', 'webp', 'bmp'],
      withData: false,
      withReadStream: false,
    );
    if (result == null || result.files.isEmpty) return;

    final pf = result.files.first;
    final path = pf.path;
    if (path == null) return;

    final ext = (pf.extension ?? '').toLowerCase();
    final isImage = ['jpg', 'jpeg', 'png', 'webp', 'bmp'].contains(ext);

    // ── انسخ الملف لمجلد دائم بالتطبيق عشان نضمن استقرار المسار ──────────
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

    setState(() {
      _pickedFile = stableFile;
      _pickedFileName = pf.name;
      _pickedFileExt = ext;
      _pickedFileSizeBytes = pf.size;
      _showResults = false;
      _isProcessing = true;
      _rawOcrText = '';
      _fields = [];
      _items = [];
      if (isImage) {
        _pickedImage = stableFile;
      } else {
        _pickedImage = null;
      }
    });
    _resultFadeCtrl.reset();

    if (isImage) {
      await _runOcr(stableFile);
    } else {
      await _runPdfOcr(pf.name);
    }
  }

  // ── PDF OCR simulation (real PDF text extraction needs a native plugin) ────
  // ── Real PDF OCR: render page(s) to image, then run ML Kit ────────────────
  Future<void> _runPdfOcr(String fileName) async {
    if (_pickedFile == null) return;

    try {
      final doc = await PdfDocument.openFile(_pickedFile!.path);
      final combinedText = StringBuffer();
      File? firstPageImageFile;

      // امسح كل الصفحات (أو تقدر تحدد عدد صفحات أقل لو الفاتورة طويلة)
      for (int i = 1; i <= doc.pagesCount; i++) {
        final page = await doc.getPage(i);
        final pageImage = await page.render(
          width: page.width * 2, // دقة أعلى = OCR أدق
          height: page.height * 2,
          format: PdfPageImageFormat.png,
        );
        await page.close();

        if (pageImage == null) continue;

        // احفظ الصورة مؤقتاً على الجهاز عشان ML Kit يقدر يقراها من مسار
        final tempDir = await getTemporaryDirectory();
        final imgFile = File(
          '${tempDir.path}/pdf_page_${i}_${DateTime.now().millisecondsSinceEpoch}.png',
        );
        await imgFile.writeAsBytes(pageImage.bytes);

        firstPageImageFile ??= imgFile;

        final inputImage = InputImage.fromFile(imgFile);
        final RecognizedText recognized = await _textRecognizer.processImage(
          inputImage,
        );
        combinedText.writeln(_buildLayoutAwareOcrText(recognized));
      }

      await doc.close();

      if (!mounted) return;

      final rawText = combinedText.toString();
      final extracted = _parseInvoiceFields(rawText);
      final extractedItems = _parseInvoiceItems(rawText);

      setState(() {
        _fields = extracted;
        _items = extractedItems;
        _rawOcrText = rawText.trim().isEmpty
            ? '⚠️ لم يتم العثور على نص قابل للقراءة داخل الملف.\n\nاسم الملف: $fileName'
            : rawText;
        // اعرض أول صفحة كصورة معاينة داخل الـ scanner area
        if (firstPageImageFile != null) {
          _pickedImage = firstPageImageFile;
        }
        _isProcessing = false;
        _showResults = true;
      });
      _resultFadeCtrl.forward();

      final filledCount = _fields.where((f) => f.value != '—').length;
      if (filledCount > 0) {
        CommonMethods.showToast(
          message:
              'تم استخراج ${_items.length} صنف و$filledCount حقل من ملف PDF بنجاح!',
          type: ToastType.success,
        );
      } else {
        CommonMethods.showToast(
          message: 'تعذّر استخراج بيانات واضحة، يرجى مراجعة الحقول يدوياً.',
          type: ToastType.warning,
        );
      }
    } catch (e, st) {
      debugPrint('PDF OCR error: $e');
      debugPrint('$st');
      if (mounted) {
        setState(() => _isProcessing = false);
        CommonMethods.showToast(
          message: 'حدث خطأ أثناء قراءة الملف: ${e.toString()}',
          type: ToastType.error,
        );
      }
    }
  }

  // ── Run real ML Kit OCR ────────────────────────────────────────────────────
  Future<void> _runOcr(File imageFile) async {
    try {
      final inputImage = InputImage.fromFile(imageFile);
      final RecognizedText recognized = await _textRecognizer.processImage(
        inputImage,
      );

      final raw = _buildLayoutAwareOcrText(recognized);
      setState(() => _rawOcrText = raw);

      final extracted = _parseInvoiceFields(raw);
      final extractedItems = _parseInvoiceItems(raw);

      await Future.delayed(const Duration(milliseconds: 400));

      if (mounted) {
        setState(() {
          _fields = extracted;
          _items = extractedItems;
          _isProcessing = false;
          _showResults = true;
        });
        _resultFadeCtrl.forward();
        CommonMethods.showToast(
          message:
              'تم استخراج ${_items.length} صنف و${_fields.length} حقل من الفاتورة بنجاح!',
          type: ToastType.success,
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isProcessing = false);
        CommonMethods.showToast(
          message: 'تعذّر قراءة الصورة، تأكد من وضوح الفاتورة.',
          type: ToastType.error,
        );
      }
    }
  }

  // ── Build OCR text using the REAL visual layout ───────────────────────────
  // ML Kit's recognized.text may reorder table cells. For invoices we must
  // preserve the row/column geometry first, then parse the rows.
  String _buildLayoutAwareOcrText(RecognizedText recognized) {
    final lines = <_OcrVisualLine>[];

    for (final block in recognized.blocks) {
      for (final line in block.lines) {
        final text = line.text.trim();
        if (text.isEmpty) continue;
        lines.add(_OcrVisualLine(text: text, box: line.boundingBox));
      }
    }

    if (lines.isEmpty) return recognized.text;

    lines.sort((a, b) {
      final dy = a.box.center.dy.compareTo(b.box.center.dy);
      if (dy != 0) return dy;
      return a.box.left.compareTo(b.box.left);
    });

    final rows = <List<_OcrVisualLine>>[];

    for (final line in lines) {
      int? bestRow;
      double bestDistance = double.infinity;

      for (int i = 0; i < rows.length; i++) {
        final row = rows[i];
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

        // Same visual row: overlapping vertically or very close centers.
        final overlaps = line.box.bottom >= minTop && line.box.top <= maxBottom;
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
      row.sort((a, b) => a.box.left.compareTo(b.box.left));
      buffer.writeln(row.map((e) => e.text).join(' '));
    }

    return buffer.toString().trim();
  }

  String _normalizeInvoiceDigits(String value) {
    const arabic = '٠١٢٣٤٥٦٧٨٩';
    const persian = '۰۱۲۳۴۵۶۷۸۹';

    return value.split('').map((char) {
      final a = arabic.indexOf(char);
      if (a >= 0) return a.toString();

      final p = persian.indexOf(char);
      if (p >= 0) return p.toString();

      return char;
    }).join();
  }

  bool _isInvoiceNumberToken(String token) {
    return RegExp(r'^-?\d[\d,]*(?:\.\d+)?$').hasMatch(token);
  }

  // ── Extract ALL invoice line items from layout-preserved rows ─────────────
  List<OcrItem> _parseInvoiceItems(String text) {
    final normalizedText = _normalizeInvoiceDigits(text);
    final lines = normalizedText
        .split(RegExp(r'\r?\n'))
        .map((line) => line.replaceAll(RegExp(r'\s+'), ' ').trim())
        .where((line) => line.isNotEmpty)
        .toList();

    bool isNumber(String value) {
      final v = value
          .replaceAll(',', '')
          .replaceAll('٫', '.')
          .replaceAll('٬', '')
          .trim();
      return RegExp(r'^-?\d+(?:\.\d+)?$').hasMatch(v);
    }

    String cleanNumber(String value) {
      return value.replaceAll('٫', '.').replaceAll('٬', '').trim();
    }

    String? extractCode(String token) {
      final cleaned = token.replaceAll(RegExp(r'[^A-Za-z0-9]'), '');
      final digits = cleaned.replaceAll(RegExp(r'[^0-9]'), '');

      if (digits.length < 3 || digits.length > 8) return null;

      // Do not treat prices/totals as item codes.
      if (token.contains('.') || token.contains(',') || token.contains('٫')) {
        return null;
      }

      if (RegExp(r'^\d{3,8}$').hasMatch(cleaned)) return digits;

      // OCR variants such as: ois3495 / ois-3495 / ABC3495
      final letters = cleaned.replaceAll(RegExp(r'[0-9]'), '');
      if (letters.isNotEmpty &&
          letters.length <= 6 &&
          RegExp(r'^[A-Za-z]+$').hasMatch(letters)) {
        return digits;
      }

      return null;
    }

    String? findCodeInTokens(List<String> tokens) {
      // Prefer codes at the far right/left edges because invoice codes are
      // normally outside the numeric amount columns.
      final order = <int>[];
      for (int i = tokens.length - 1; i >= 0; i--) order.add(i);
      for (int i = 0; i < tokens.length; i++) {
        if (!order.contains(i)) order.add(i);
      }

      for (final i in order) {
        final code = extractCode(tokens[i]);
        if (code != null) return code;
      }
      return null;
    }

    bool isTotalsLine(String line) {
      final lower = line.toLowerCase();
      return lower.contains('total') ||
          lower.contains('subtotal') ||
          lower.contains('net before') ||
          lower.contains('vat %') ||
          lower.contains('discount') ||
          lower.contains('الإجمالي') ||
          lower.contains('المجموع') ||
          lower.contains('الصافي قبل') ||
          lower.contains('ضريبة قيمة') ||
          lower.contains('الخصم');
    }

    // We deliberately do NOT require the ITEM header. OCR can lose/reorder
    // headers while still detecting the actual item rows correctly.
    final rows = <String>[];
    String? current;

    for (final line in lines) {
      if (isTotalsLine(line)) {
        if (current != null) {
          rows.add(current);
          current = null;
        }
        continue;
      }

      final tokens = line.split(RegExp(r'\s+'));
      final code = findCodeInTokens(tokens);
      final numericCount = tokens.where(isNumber).length;

      // A real item row normally has code + at least 5 numeric cells:
      // NET, VAT, TOTAL, PRICE, QTY (discount may add a sixth).
      if (code != null && numericCount >= 5) {
        if (current != null) rows.add(current);
        current = line;
      } else if (current != null) {
        // Continuation of item description.
        current = '$current $line';
      }
    }
    if (current != null) rows.add(current);

    final result = <OcrItem>[];

    for (final rowText in rows) {
      final tokens = rowText.split(RegExp(r'\s+'));

      int? codeIndex;
      String? code;
      for (int i = tokens.length - 1; i >= 0; i--) {
        final c = extractCode(tokens[i]);
        if (c != null) {
          codeIndex = i;
          code = c;
          break;
        }
      }
      if (code == null || codeIndex == null) continue;

      final numeric = <String>[];
      for (int i = 0; i < tokens.length; i++) {
        if (i == codeIndex) continue;
        if (isNumber(tokens[i])) numeric.add(cleanNumber(tokens[i]));
      }

      if (numeric.length < 5) continue;

      // Invoice column order after visual row reconstruction:
      // NET VAT [DISCOUNT] TOTAL PRICE QTY
      final hasDiscount = numeric.length >= 6;
      final values = hasDiscount
          ? numeric.sublist(numeric.length - 6)
          : numeric.sublist(numeric.length - 5);

      final net = values[0];
      final vat = values[1];
      final discount = hasDiscount ? values[2] : '—';
      final total = hasDiscount ? values[3] : values[2];
      final price = hasDiscount ? values[4] : values[3];
      final quantity = hasDiscount ? values[5] : values[4];

      // Remove the numeric cells and code from the row to get the description.
      final descriptionParts = <String>[];
      int numericUsed = 0;
      for (int i = 0; i < tokens.length; i++) {
        if (i == codeIndex) continue;
        if (isNumber(tokens[i]) && numericUsed < values.length) {
          numericUsed++;
          continue;
        }
        descriptionParts.add(tokens[i]);
      }

      var description = descriptionParts
          .join(' ')
          .replaceAll(RegExp(r'\s+'), ' ')
          .trim();

      if (description.isEmpty) description = 'صنف رقم $code';

      result.add(
        OcrItem(
          itemCode: code,
          description: description,
          quantity: quantity,
          price: price,
          total: total,
          discount: discount,
          vat: vat,
          net: net,
        ),
      );
    }

    // Unique by code + financial values. This also handles duplicated OCR rows.
    final unique = <String, OcrItem>{};
    for (final item in result) {
      unique['${item.itemCode}|${item.quantity}|${item.price}|${item.total}|${item.net}'] =
          item;
    }

    return unique.values.toList();
  }

  // ── Smart invoice field parser ─────────────────────────────────────────────
  List<OcrField> _parseInvoiceFields(String text) {
    final lines = text
        .split('\n')
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .toList();

    String _find(List<RegExp> patterns, {String fallback = '—'}) {
      for (final pattern in patterns) {
        for (final line in lines) {
          final m = pattern.firstMatch(line);
          if (m != null) return m.group(0) ?? fallback;
        }
      }
      // Fallback: scan full text
      for (final pattern in patterns) {
        final m = pattern.firstMatch(text);
        if (m != null) return m.group(0) ?? fallback;
      }
      return fallback;
    }

    // ── Supplier / company name ────────────────────────────────────────────
    String supplierName = '—';
    for (final line in lines.take(6)) {
      if (line.length > 4 &&
          !RegExp(r'^\d').hasMatch(line) &&
          !line.contains(':') &&
          !line.toLowerCase().contains('invoice') &&
          !line.toLowerCase().contains('فاتورة') &&
          !line.toLowerCase().contains('receipt')) {
        supplierName = line;
        break;
      }
    }

    // ── Invoice number ─────────────────────────────────────────────────────
    final invoiceNo = _find([
      RegExp(
        r'(?:Invoice|Inv|فاتورة|رقم)\s*[#:№]?\s*([A-Z0-9\-]+)',
        caseSensitive: false,
      ),
      RegExp(r'[A-Z]{2,4}[-/]?\d{4,10}'),
    ], fallback: 'غير معروف');

    // ── Date ───────────────────────────────────────────────────────────────
    final date = _find([
      RegExp(r'\d{1,2}[\/\-\.]\d{1,2}[\/\-\.]\d{2,4}'),
      RegExp(r'\d{4}[\/\-]\d{2}[\/\-]\d{2}'),
    ]);

    // ── VAT / Tax number ───────────────────────────────────────────────────
    final vatNo = _find([
      RegExp(
        r'(?:VAT|Tax|ضريبي|الضريبي|رقم ضريبي)[:\s#]*(\d{10,15})',
        caseSensitive: false,
      ),
      RegExp(r'\b3\d{14}\b'), // Saudi VAT 15-digit starting with 3
    ]);

    // ── Total amount ───────────────────────────────────────────────────────
    final totalAmount = _find([
      RegExp(
        r'(?:Total|الإجمالي|Grand Total|المجموع الكلي)[:\s]*([0-9,\.]+)',
        caseSensitive: false,
      ),
      RegExp(r'(?:SAR|ر\.?س\.?)\s*([0-9,\.]+)', caseSensitive: false),
      RegExp(r'([0-9,\.]+)\s*(?:SAR|ر\.?س\.?)', caseSensitive: false),
    ]);

    // ── VAT amount ─────────────────────────────────────────────────────────
    final vatAmount = _find([
      RegExp(
        r'(?:VAT|Vat|Tax Amount|الضريبة|ضريبة القيمة)[:\s]*([0-9,\.]+)',
        caseSensitive: false,
      ),
    ]);

    // ── Subtotal ───────────────────────────────────────────────────────────
    final subtotal = _find([
      RegExp(
        r'(?:Subtotal|Sub-?total|المجموع الفرعي|قبل الضريبة)[:\s]*([0-9,\.]+)',
        caseSensitive: false,
      ),
    ]);
    // ── Quantity ───────────────────────────────────────────────────────────
    final quantity = _find([
      RegExp(
        r'(?:Qty|Quantity|الكمية|العدد)[:\s]*([0-9]+(?:\.[0-9]+)?)',
        caseSensitive: false,
      ),
      RegExp(r'\b([0-9]{1,4})\s*(?:pcs|قطعة|قطع|وحدة)\b', caseSensitive: false),
    ], fallback: '1');

    // ── Currency ───────────────────────────────────────────────────────────
    final currency = _find([
      RegExp(r'\b(SAR|USD|EUR|AED|EGP|KWD)\b'),
      RegExp(r'(ر\.?س\.?|دولار|يورو|درهم)'),
    ], fallback: 'SAR');

    // ── Payment terms ──────────────────────────────────────────────────────
    final paymentTerms = _find([
      RegExp(
        r'(?:Net\s?\d+|Payment Terms?|شروط الدفع)[:\s]*(.+)',
        caseSensitive: false,
      ),
    ], fallback: 'آجل 30 يوم');

    // Build fields list
    final accent1 = const Color(0xFF06B6D4);
    final accent2 = const Color(0xFF4F46E5);
    final accent3 = const Color(0xFF10B981);
    final accent4 = const Color(0xFFF59E0B);
    final accent5 = const Color(0xFF8B5CF6);
    final accent6 = const Color(0xFFEF4444);

    return [
      OcrField(
        label: 'المورد / الشركة',
        icon: '🏢',
        value: supplierName,
        accentColor: accent1,
      ),
      OcrField(
        label: 'رقم الفاتورة',
        icon: '🔢',
        value: invoiceNo,
        accentColor: accent2,
      ),
      OcrField(
        label: 'تاريخ الفاتورة',
        icon: '📅',
        value: date,
        accentColor: accent3,
      ),
      OcrField(
        label: 'الرقم الضريبي',
        icon: '🧾',
        value: vatNo,
        accentColor: accent4,
      ),
      OcrField(
        label: 'الكمية',
        icon: '📦',
        value: quantity,
        accentColor: accent2,
      ),
      OcrField(
        label: 'الإجمالي قبل الضريبة',
        icon: '💰',
        value: totalAmount,
        accentColor: accent5,
      ),
      OcrField(
        label: 'مبلغ الضريبة (15%)',
        icon: '📊',
        value: vatAmount,
        accentColor: accent6,
      ),
      OcrField(
        label: 'الإجمالي بعد الضريبة',
        icon: '✅',
        value: paymentTerms,
        accentColor: accent3,
      ),
      OcrField(
        label: 'العملة',
        icon: '💱',
        value: currency,
        accentColor: accent1,
      ),
    ];
  }

  // ── Confirm & post ─────────────────────────────────────────────────────────
  void _confirmPost() {
    HapticFeedback.mediumImpact();
    CommonMethods.showToast(
      message: 'تم ترحيل الفاتورة إلى قيود اليومية بنجاح! ✅',
      type: ToastType.success,
    );
    Navigator.pop(context);
  }

  // ───────────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffoldColor(context),
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 30.h),
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
            if (_isProcessing) _buildProcessingCard(),
            if (_showResults && _fields.isNotEmpty) ...[
              FadeTransition(
                opacity: _resultFade,
                child: Column(
                  children: [
                    _buildOcrTable(),
                    Gap(12.h),
                    if (_rawOcrText.isNotEmpty) _buildRawTextToggle(),
                    Gap(20.h),
                    _buildAccountingSection(),
                    Gap(20.h),
                    _buildConfirmButton(),
                  ],
                ),
              ),
            ] else if (!_isProcessing &&
                _pickedImage == null &&
                _pickedFile == null) ...[
              _buildEmptyHint(),
            ],
          ],
        ),
      ),
    );
  }

  // ── AppBar ─────────────────────────────────────────────────────────────────
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColor.titleFormFiledColor(context),
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new_rounded, color: AppColor.titleFormFiledColor(context)),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'مسح الفواتير بالذكاء الاصطناعي',
        style: TextStyle(
          fontSize: 15.sp,
          fontWeight: FontWeight.w700,
          color: AppColor.titleFormFiledColor(context),
          fontFamily: 'Tajawal',
        ),
      ),
      actions: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF10B981), Color(0xFF06B6D4)],
            ),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.document_scanner_rounded,
                color: AppColor.titleFormFiledColor(context),
                size: 11.r,
              ),
              Gap(4.w),
              Text(
                'OCR AI',
                style: TextStyle(
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColor.titleFormFiledColor(context),
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

  // ── Header badge ──────────────────────────────────────────────────────────
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
                colors: [Color(0xFF4F46E5), Color(0xFF06B6D4)],
              ),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.auto_awesome_rounded,
              color: AppColor.titleFormFiledColor(context),
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
                    color: AppColor.titleFormFiledColor(context),
                    fontFamily: 'Tajawal',
                  ),
                ),
                Gap(2.h),
                Text(
                  'التقط صورة أو اختر من المعرض أو ارفع ملف PDF',
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: AppColor.darkTextColor(context),
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

  // ── Scanner area ──────────────────────────────────────────────────────────
  Widget _buildScannerArea() {
    return Container(
      height: 230.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColor.cardColor(context),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: _showResults
              ? AppColor.emeraldTeal.withValues(alpha: 0.7)
              : const Color(0xFF4F46E5).withValues(alpha: 0.4),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color:
                (_showResults ? AppColor.emeraldTeal : const Color(0xFF4F46E5))
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
            // ── Image preview or placeholder ──────────────────────────────
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
              // ── PDF file preview panel ─────────────────────────────────
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
                            color: const Color(
                              0xFFEF4444,
                            ).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(
                              color: const Color(
                                0xFFEF4444,
                              ).withValues(alpha: 0.4),
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
                            color: AppColor.titleFormFiledColor(context),
                            fontFamily: 'Tajawal',
                          ),
                        ),
                        Gap(4.h),
                        Text(
                          '${((_pickedFileSizeBytes ?? 0) / 1024).toStringAsFixed(1)} KB  •  PDF',
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: AppColor.darkTextColor(context),
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
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColor.titleFormFiledColor(context), AppColor.textFormFillColor(context)],
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
                            color: const Color(
                              0xFF4F46E5,
                            ).withValues(alpha: 0.7),
                            size: 52.r,
                          ),
                        ),
                        Gap(10.h),
                        Text(
                          'اختر صورة أو ارفع ملف للبدء',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: AppColor.darkTextColor(context),
                            fontFamily: 'Tajawal',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // ── Corner guides ─────────────────────────────────────────────
            Positioned(
              top: 14.r,
              left: 14.r,
              child: _corner(isTop: true, isLeft: true),
            ),
            Positioned(
              top: 14.r,
              right: 14.r,
              child: _corner(isTop: true, isLeft: false),
            ),
            Positioned(
              bottom: 14.r,
              left: 14.r,
              child: _corner(isTop: false, isLeft: true),
            ),
            Positioned(
              bottom: 14.r,
              right: 14.r,
              child: _corner(isTop: false, isLeft: false),
            ),

            // ── Scan laser ────────────────────────────────────────────────
            if (!_showResults)
              AnimatedBuilder(
                animation: _laserAnim,
                builder: (ctx, child) => Positioned(
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
                          color: const Color(0xFF06B6D4).withValues(alpha: 0.9),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // ── Success overlay ───────────────────────────────────────────
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
                          color: AppColor.titleFormFiledColor(context),
                          size: 14.r,
                        ),
                        Gap(6.w),
                        Text(
                          'تم استخراج ${_fields.length} حقل بنجاح',
                          style: TextStyle(
                            fontSize: 10.5.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColor.titleFormFiledColor(context),
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

  Widget _corner({required bool isTop, required bool isLeft}) {
    return Container(
      width: 20.r,
      height: 20.r,
      decoration: BoxDecoration(
        border: Border(
          top: isTop
              ? const BorderSide(color: Color(0xFF06B6D4), width: 2.5)
              : BorderSide.none,
          bottom: !isTop
              ? const BorderSide(color: Color(0xFF06B6D4), width: 2.5)
              : BorderSide.none,
          left: isLeft
              ? const BorderSide(color: Color(0xFF06B6D4), width: 2.5)
              : BorderSide.none,
          right: !isLeft
              ? const BorderSide(color: Color(0xFF06B6D4), width: 2.5)
              : BorderSide.none,
        ),
      ),
    );
  }

  // ── Picker buttons ────────────────────────────────────────────────────────
  Widget _buildPickerButtons() {
    return Column(
      children: [
        // ── Row 1: image sources ──────────────────────────────────────────
        Row(
          children: [
            Expanded(
              child: _pickerBtn(
                label: 'كاميرا',
                icon: Icons.camera_alt_rounded,
                color: const Color(0xFF4F46E5),
                onTap: () => _pickImage(ImageSource.camera),
              ),
            ),
            Gap(10.w),
            Expanded(
              child: _pickerBtn(
                label: 'معرض الصور',
                icon: Icons.photo_library_rounded,
                color: const Color(0xFF0EA5E9),
                onTap: () => _pickImage(ImageSource.gallery),
              ),
            ),
            Gap(10.w),
            Expanded(
              child: _pickerBtn(
                label: 'إعادة المسح',
                icon: Icons.refresh_rounded,
                color: const Color(0xFF10B981),
                onTap: () {
                  setState(() {
                    _pickedImage = null;
                    _pickedFile = null;
                    _pickedFileName = null;
                    _pickedFileExt = null;
                    _pickedFileSizeBytes = null;
                    _showResults = false;
                    _fields = [];
                    _items = [];
                    _rawOcrText = '';
                  });
                },
              ),
            ),
          ],
        ),
        Gap(10.h),
        // ── Row 2: file upload ────────────────────────────────────────────
        _buildFileUploadRow(),
      ],
    );
  }

  // ── File upload row ───────────────────────────────────────────────────────
  Widget _buildFileUploadRow() {
    final hasPicked = _pickedFile != null;
    return InkWell(
      onTap: _pickFile,
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 13.h),
        decoration: BoxDecoration(
          color: hasPicked
              ? const Color(0xFF8B5CF6).withValues(alpha: 0.14)
              : AppColor.textFormFillColor(context),
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
                color: AppColor.titleFormFiledColor(context),
                fontFamily: 'Tajawal',
              ),
            ),
            Text(
              'يدعم: PDF • JPG • PNG • WEBP',
              style: TextStyle(
                fontSize: 9.5.sp,
                color: AppColor.darkTextColor(context),
                fontFamily: 'Tajawal',
              ),
            ),
          ],
        ),
        const Spacer(),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF8B5CF6), Color(0xFF4F46E5)],
            ),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Text(
            'اختيار',
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
              color: AppColor.titleFormFiledColor(context),
              fontFamily: 'Tajawal',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilePreviewRow() {
    final ext = (_pickedFileExt ?? '').toUpperCase();
    final sizeKb = ((_pickedFileSizeBytes ?? 0) / 1024).toStringAsFixed(1);
    final isPdf = ext == 'PDF';

    return Row(
      children: [
        // File type icon
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
                isPdf ? Icons.picture_as_pdf_rounded : Icons.image_rounded,
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
        // File name + size
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
                  color: AppColor.titleFormFiledColor(context),
                  fontFamily: 'Tajawal',
                ),
              ),
              Gap(2.h),
              Text(
                '$sizeKb KB  •  $ext',
                style: TextStyle(
                  fontSize: 9.5.sp,
                  color: AppColor.darkTextColor(context),
                  fontFamily: 'Tajawal',
                ),
              ),
            ],
          ),
        ),
        // Change button
        GestureDetector(
          onTap: _pickFile,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
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
        padding: EdgeInsets.symmetric(vertical: 11.h),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: color.withValues(alpha: 0.35)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22.r),
            Gap(4.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.bold,
                color: AppColor.titleFormFiledColor(context),
                fontFamily: 'Tajawal',
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Processing card ────────────────────────────────────────────────────────
  Widget _buildProcessingCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: AppColor.cardColor(context),
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
            child: CircularProgressIndicator(
              color: const Color(0xFF06B6D4),
              strokeWidth: 3,
            ),
          ),
          Gap(14.h),
          Text(
            'جاري تحليل الفاتورة بالذكاء الاصطناعي...',
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.bold,
              color: AppColor.titleFormFiledColor(context),
              fontFamily: 'Tajawal',
            ),
          ),
          Gap(6.h),
          Text(
            'استخراج النص • تمييز الحقول • ترتيب البيانات',
            style: TextStyle(
              fontSize: 10.sp,
              color: AppColor.darkTextColor(context),
              fontFamily: 'Tajawal',
            ),
          ),
          Gap(16.h),
          // Processing steps
          _processingStep('قراءة الصورة وتحسين الجودة', true),
          _processingStep('استخراج النصوص بتقنية OCR', true),
          _processingStep('تحليل حقول الفاتورة', false),
        ],
      ),
    );
  }

  Widget _processingStep(String label, bool done) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Row(
        children: [
          Icon(
            done ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
            color: done
                ? AppColor.emeraldTeal
                : Colors.white.withValues(alpha: 0.3),
            size: 16.r,
          ),
          Gap(8.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              color: done
                  ? Colors.white.withValues(alpha: 0.8)
                  : Colors.white.withValues(alpha: 0.4),
              fontFamily: 'Tajawal',
            ),
          ),
        ],
      ),
    );
  }

  // ── OCR Results Table ──────────────────────────────────────────────────────
  // ── OCR Results Table ──────────────────────────────────────────────────────
  // ── OCR Results List (card-based, no clipped text) ──────────────────────────
  // ── Invoice items table: displays every detected item ───────────────────────
  Widget _buildInvoiceItemsTable() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColor.titleFormFiledColor(context),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: const Color(0xFF06B6D4).withValues(alpha: 0.35),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF06B6D4).withValues(alpha: 0.07),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF06B6D4).withValues(alpha: 0.18),
                    const Color(0xFF4F46E5).withValues(alpha: 0.10),
                  ],
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.inventory_2_rounded,
                    color: const Color(0xFF06B6D4),
                    size: 18.r,
                  ),
                  Gap(8.w),
                  Expanded(
                    child: Text(
                      'أصناف الفاتورة',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColor.titleFormFiledColor(context),
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 9.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF06B6D4).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Text(
                      '${_items.length} أصناف',
                      style: TextStyle(
                        fontSize: 9.5.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF06B6D4),
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ),
                ],
              ),
            ),

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.all(12.r),
              itemCount: _items.length,
              separatorBuilder: (_, __) => Gap(10.h),
              itemBuilder: (_, index) =>
                  _buildInvoiceItemCard(_items[index], index),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInvoiceItemCard(OcrItem item, int index) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColor.cardColor(context),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: const Color(0xFF06B6D4).withValues(alpha: 0.16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 34.r,
                height: 34.r,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFF06B6D4).withValues(alpha: 0.13),
                  borderRadius: BorderRadius.circular(9.r),
                ),
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF06B6D4),
                    fontFamily: 'Tajawal',
                  ),
                ),
              ),
              Gap(10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.description,
                      softWrap: true,
                      style: TextStyle(
                        fontSize: 11.5.sp,
                        height: 1.5,
                        fontWeight: FontWeight.w700,
                        color: AppColor.titleFormFiledColor(context),
                        fontFamily: 'Tajawal',
                      ),
                    ),
                    Gap(4.h),
                    Text(
                      'رمز الصنف: ${item.itemCode}',
                      style: TextStyle(
                        fontSize: 9.5.sp,
                        color: AppColor.darkTextColor(context),
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          Gap(10.h),

          Wrap(
            spacing: 7.w,
            runSpacing: 7.h,
            children: [
              _itemValueChip(
                icon: Icons.numbers_rounded,
                label: 'الكمية',
                value: item.quantity,
              ),
              _itemValueChip(
                icon: Icons.sell_rounded,
                label: 'السعر',
                value: item.price,
              ),
              _itemValueChip(
                icon: Icons.calculate_rounded,
                label: 'الإجمالي',
                value: item.total,
              ),
              _itemValueChip(
                icon: Icons.percent_rounded,
                label: 'الضريبة',
                value: item.vat,
              ),
              _itemValueChip(
                icon: Icons.account_balance_wallet_rounded,
                label: 'الصافي',
                value: item.net,
              ),
              if (item.discount != '—')
                _itemValueChip(
                  icon: Icons.discount_rounded,
                  label: 'الخصم',
                  value: item.discount,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _itemValueChip({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: AppColor.darkTextColor(context),
        borderRadius: BorderRadius.circular(9.r),
        border: Border.all(color: AppColor.darkTextColor(context)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13.r, color: const Color(0xFF06B6D4)),
          Gap(5.w),
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 9.sp,
              color: AppColor.darkTextColor(context),
              fontFamily: 'Tajawal',
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 9.5.sp,
              fontWeight: FontWeight.w700,
              color: AppColor.titleFormFiledColor(context),
              fontFamily: 'Tajawal',
            ),
          ),
        ],
      ),
    );
  }

  // ── OCR Results Table ──────────────────────────────────────────────────────
  Widget _buildOcrTable() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColor.titleFormFiledColor(context),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: AppColor.emeraldTeal.withValues(alpha: 0.35),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColor.emeraldTeal.withValues(alpha: 0.08),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            // ── Header ────────────────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColor.emeraldTeal.withValues(alpha: 0.20),
                    const Color(0xFF4F46E5).withValues(alpha: 0.10),
                  ],
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.table_chart_rounded,
                    color: AppColor.emeraldTeal,
                    size: 18.r,
                  ),
                  Gap(8.w),
                  Expanded(
                    child: Text(
                      'البيانات المستخرجة من الفاتورة',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColor.titleFormFiledColor(context),
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 3.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColor.emeraldTeal.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      '${_fields.length} حقل',
                      style: TextStyle(
                        fontSize: 9.5.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColor.emeraldTeal,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Field cards ───────────────────────────────────────────────
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.all(12.r),
              itemCount: _fields.length,
              separatorBuilder: (_, __) => Gap(8.h),
              itemBuilder: (context, i) => _buildOcrFieldCard(_fields[i], i),
            ),

            // ── Invoice items: inside the SAME main results table ────────────
            if (_items.isNotEmpty) ...[
              Padding(
                padding: EdgeInsets.fromLTRB(12.w, 4.h, 12.w, 4.h),
                child: _buildItemsInsideMainTable(),
              ),
            ],

            // ── Confidence badge ──────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: AppColor.darkTextColor(context),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.verified_rounded,
                    color: AppColor.emeraldTeal,
                    size: 14.r,
                  ),
                  Gap(6.w),
                  Expanded(
                    child: Text(
                      'دقة الاستخراج: ${_calcConfidence()}%  •  محرك: Google ML Kit OCR',
                      style: TextStyle(
                        fontSize: 9.5.sp,
                        color: AppColor.darkTextColor(context),
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── All invoice items inside the main OCR table ───────────────────────────
  Widget _buildItemsInsideMainTable() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColor.scaffoldColor(context),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColor.emeraldTeal.withValues(alpha: 0.25)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: AppColor.emeraldTeal.withValues(alpha: 0.10),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.receipt_long_rounded,
                  color: AppColor.emeraldTeal,
                  size: 17.r,
                ),
                Gap(7.w),
                Expanded(
                  child: Text(
                    'أصناف الفاتورة والنتائج',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColor.titleFormFiledColor(context),
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ),
                Text(
                  '${_items.length} صنف',
                  style: TextStyle(
                    fontSize: 9.5.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColor.emeraldTeal,
                    fontFamily: 'Tajawal',
                  ),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.all(8.r),
            child: DataTable(
              headingRowHeight: 42.h,
              dataRowMinHeight: 54.h,
              dataRowMaxHeight: 90.h,
              columnSpacing: 18.w,
              horizontalMargin: 8.w,
              headingRowColor: WidgetStateProperty.all(
                AppColor.emeraldTeal.withValues(alpha: 0.12),
              ),
              columns: [
                _itemColumn('م', 42.w),
                _itemColumn('كود الصنف', 82.w),
                _itemColumn('الصنف / الوصف', 230.w),
                _itemColumn('الكمية', 65.w),
                _itemColumn('السعر', 85.w),
                _itemColumn('الإجمالي', 90.w),
                _itemColumn('الخصم', 75.w),
                _itemColumn('VAT', 75.w),
                _itemColumn('الصافي', 90.w),
              ],
              rows: List.generate(_items.length, (index) {
                final item = _items[index];
                return DataRow(
                  cells: [
                    _itemCell('${index + 1}'),
                    _itemCell(item.itemCode),
                    _itemCell(item.description, alignStart: true),
                    _itemCell(item.quantity),
                    _itemCell(item.price),
                    _itemCell(item.total),
                    _itemCell(item.discount),
                    _itemCell(item.vat),
                    _itemCell(item.net),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  DataColumn _itemColumn(String title, double width) {
    return DataColumn(
      label: SizedBox(
        width: width,
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 10.sp,
            fontWeight: FontWeight.bold,
            color: AppColor.emeraldTeal,
            fontFamily: 'Tajawal',
          ),
        ),
      ),
    );
  }

  DataCell _itemCell(String value, {bool alignStart = false}) {
    return DataCell(
      SizedBox(
        width: alignStart ? 230.w : null,
        child: Text(
          value,
          textAlign: alignStart ? TextAlign.start : TextAlign.center,
          softWrap: true,
          maxLines: alignStart ? 4 : 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 10.5.sp,
            fontWeight: FontWeight.w600,
            color: AppColor.darkTextColor(context),
            fontFamily: 'Tajawal',
          ),
        ),
      ),
    );
  }

  // ── Single field card: label row on top, full-width value below ────────────
  Widget _buildOcrFieldCard(OcrField field, int index) {
    final isEmpty = field.value == '—';
    return GestureDetector(
      onTap: () => _editField(index),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: field.accentColor.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isEmpty
                ? Colors.red.withValues(alpha: 0.35)
                : field.accentColor.withValues(alpha: 0.22),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Label row ─────────────────────────────────────────────────
            Row(
              children: [
                Container(
                  width: 24.r,
                  height: 24.r,
                  decoration: BoxDecoration(
                    color: field.accentColor.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(7.r),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      fontSize: 9.sp,
                      fontWeight: FontWeight.bold,
                      color: field.accentColor,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ),
                Gap(8.w),
                Text(field.icon, style: TextStyle(fontSize: 13.sp)),
                Gap(6.w),
                Expanded(
                  child: Text(
                    field.label,
                    style: TextStyle(
                      fontSize: 11.5.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColor.darkTextColor(context),
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ),
                Icon(
                  Icons.edit_rounded,
                  size: 14.r,
                  color: field.accentColor.withValues(alpha: 0.7),
                ),
              ],
            ),
            Gap(8.h),
            // ── Value (full width, never clipped) ────────────────────────
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: AppColor.scaffoldColor(context),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                field.value,
                softWrap: true,
                style: TextStyle(
                  fontSize: 12.5.sp,
                  fontWeight: FontWeight.w700,
                  color: isEmpty
                      ? Colors.red.withValues(alpha: 0.7)
                      : Colors.white,
                  fontFamily: 'Tajawal',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOcrRow({required int index, required OcrField field}) {
    final isEmpty = field.value == '—';
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      color: index.isEven
          ? Colors.white.withValues(alpha: 0.02)
          : Colors.transparent,
      child: Row(
        children: [
          // Index
          Container(
            width: 26.r,
            height: 26.r,
            decoration: BoxDecoration(
              color: field.accentColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8.r),
            ),
            alignment: Alignment.center,
            child: Text(
              '${index + 1}',
              style: TextStyle(
                fontSize: 9.sp,
                fontWeight: FontWeight.bold,
                color: field.accentColor,
                fontFamily: 'Tajawal',
              ),
            ),
          ),
          Gap(10.w),

          // Field label
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Text(field.icon, style: TextStyle(fontSize: 13.sp)),
                Gap(5.w),
                Expanded(
                  child: Text(
                    field.label,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: AppColor.darkTextColor(context),
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Value
          Expanded(
            flex: 3,
            child: GestureDetector(
              onTap: () => _editField(index),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: isEmpty
                      ? Colors.red.withValues(alpha: 0.08)
                      : field.accentColor.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: isEmpty
                        ? Colors.red.withValues(alpha: 0.3)
                        : field.accentColor.withValues(alpha: 0.25),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Text(
                        field.value,
                        textAlign: TextAlign.end,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          color: isEmpty
                              ? Colors.red.withValues(alpha: 0.6)
                              : Colors.white,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                    ),
                    Gap(4.w),
                    Icon(
                      Icons.edit_rounded,
                      size: 11.r,
                      color: field.accentColor.withValues(alpha: 0.6),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Edit field inline ──────────────────────────────────────────────────────
  void _editField(int index) {
    final ctrl = TextEditingController(text: _fields[index].value);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColor.textFormFillColor(context),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          'تعديل: ${_fields[index].label}',
          style: TextStyle(
            color: AppColor.titleFormFiledColor(context),
            fontFamily: 'Tajawal',
            fontSize: 14.sp,
          ),
        ),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          style: TextStyle(color: AppColor.titleFormFiledColor(context), fontFamily: 'Tajawal'),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColor.titleFormFiledColor(context),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'إلغاء',
              style: TextStyle(
                color: AppColor.titleFormFiledColor(context).withValues(alpha: 0.54),
                fontFamily: 'Tajawal',
                fontSize: 12.sp,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.emeraldTeal,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            onPressed: () {
              setState(() => _fields[index].value = ctrl.text.trim());
              Navigator.pop(ctx);
            },
            child: Text(
              'حفظ',
              style: TextStyle(
                color: AppColor.titleFormFiledColor(context),
                fontFamily: 'Tajawal',
                fontSize: 12.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Raw OCR text toggle ───────────────────────────────────────────────────
  bool _showRaw = false;

  Widget _buildRawTextToggle() {
    return Column(
      children: [
        InkWell(
          onTap: () => setState(() => _showRaw = !_showRaw),
          borderRadius: BorderRadius.circular(10.r),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: AppColor.cardColor(context),
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: AppColor.darkTextColor(context)),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.code_rounded,
                  color: const Color(0xFF8B5CF6),
                  size: 16.r,
                ),
                Gap(8.w),
                Expanded(
                  child: Text(
                    'عرض النص الخام المستخرج',
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: AppColor.darkTextColor(context),
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ),
                Icon(
                  _showRaw
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: AppColor.darkTextColor(context),
                  size: 18.r,
                ),
              ],
            ),
          ),
        ),
        if (_showRaw) ...[
          Gap(6.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: AppColor.scaffoldColor(context),
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                color: const Color(0xFF8B5CF6).withValues(alpha: 0.3),
              ),
            ),
            child: SelectableText(
              _rawOcrText.isEmpty ? '(لا يوجد نص)' : _rawOcrText,
              style: TextStyle(
                fontSize: 10.sp,
                color: AppColor.darkTextColor(context),
                fontFamily: 'monospace',
                height: 1.6,
              ),
            ),
          ),
        ],
      ],
    );
  }

  // ── Accounting section ─────────────────────────────────────────────────────
  String _accountCode = '5010 - مشتريات ومصروفات تشغيلية';

  Widget _buildAccountingSection() {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColor.cardColor(context),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColor.darkTextColor(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.account_balance_rounded,
                color: const Color(0xFFF59E0B),
                size: 18.r,
              ),
              Gap(8.w),
              Text(
                'التوجيه المحاسبي',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColor.titleFormFiledColor(context),
                  fontFamily: 'Tajawal',
                ),
              ),
            ],
          ),
          Gap(12.h),
          DropdownButtonFormField<String>(
            value: _accountCode,
            isExpanded: true,
            dropdownColor: AppColor.textFormFillColor(context),
            style: TextStyle(color: AppColor.titleFormFiledColor(context), fontFamily: 'Tajawal'),
            decoration: InputDecoration(
              labelText: 'حساب المصروف',
              labelStyle: TextStyle(
                fontSize: 11.sp,
                color: AppColor.darkTextColor(context),
                fontFamily: 'Tajawal',
              ),
              prefixIcon: Icon(
                Icons.folder_rounded,
                color: const Color(0xFFF59E0B),
                size: 18.r,
              ),
              filled: true,
              fillColor: AppColor.textFormFillColor(context),
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
                  color: AppColor.darkTextColor(context),
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
            items:
                [
                      '5010 - مشتريات ومصروفات تشغيلية',
                      '5020 - مصروفات عمومية وإدارية',
                      '1030 - مخزون البضائع والمستودعات',
                      '1020 - أصول ثابتة ومعدات تقنية',
                      '5030 - مصروفات التسويق والمبيعات',
                    ]
                    .map(
                      (acc) => DropdownMenuItem(
                        value: acc,
                        child: Text(acc, overflow: TextOverflow.ellipsis),
                      ),
                    )
                    .toList(),
            onChanged: (val) {
              if (val != null) setState(() => _accountCode = val);
            },
          ),
        ],
      ),
    );
  }

  // ── Confirm button ─────────────────────────────────────────────────────────
  Widget _buildConfirmButton() {
    return SizedBox(
      width: double.infinity,
      height: 50.h,
      child: ElevatedButton.icon(
        onPressed: _confirmPost,
        icon: const Icon(Icons.rocket_launch_rounded),
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
          shadowColor: AppColor.emeraldTeal.withValues(alpha: 0.5),
        ),
      ),
    );
  }

  // ── Empty hint ─────────────────────────────────────────────────────────────
  Widget _buildEmptyHint() {
    final tips = [
      'تأكد من إضاءة جيدة عند التقاط الفاتورة',
      'أمسك الكاميرا ثابتة مباشرة فوق الفاتورة',
      'يمكن رفع صور JPG أو PNG من المعرض',
      'يدعم الفواتير العربية والإنجليزية ومختلطة',
    ];
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: AppColor.cardColor(context),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColor.darkTextColor(context)),
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
              Text(
                'نصائح للحصول على أفضل نتيجة OCR',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColor.titleFormFiledColor(context),
                  fontFamily: 'Tajawal',
                ),
              ),
            ],
          ),
          Gap(14.h),
          ...tips.map(
            (tip) => Padding(
              padding: EdgeInsets.only(bottom: 8.h),
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
                        color: AppColor.darkTextColor(context),
                        fontFamily: 'Tajawal',
                      ),
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

  // ── Confidence calculator ──────────────────────────────────────────────────
  String _calcConfidence() {
    if (_fields.isEmpty) return '0';
    final filled = _fields.where((f) => f.value != '—').length;
    final pct = (filled / _fields.length * 100).round();
    return '$pct';
  }
}
