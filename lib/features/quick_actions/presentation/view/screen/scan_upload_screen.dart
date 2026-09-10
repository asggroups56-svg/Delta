import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/custom_widgets/custom_toast/custom_toast.dart';
import 'package:my_template/core/utils/common_methods.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';

class ScanUploadScreen extends StatefulWidget {
  const ScanUploadScreen({super.key});

  @override
  State<ScanUploadScreen> createState() => _ScanUploadScreenState();
}

class _ScanUploadScreenState extends State<ScanUploadScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _scanLaserCtrl;
  late Animation<double> _scanLaserAnim;

  bool _isScanned = false;
  bool _isProcessing = false;
  String _docCategory = 'فاتورة مشتريات (Purchase Bill)';

  // Extracted OCR Data state
  String _supplierName = 'شركة اليمامة للتوريدات العامة';
  String _vatNumber = '310294857200003';
  String _invoiceDate = '2026-09-08';
  String _totalAmount = '14,850.00';
  String _vatAmount = '1,936.96';
  String _destinationAccount = '5010 - مشتريات ومصروفات تشغيلية';

  @override
  void initState() {
    super.initState();
    _scanLaserCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _scanLaserAnim = Tween<double>(begin: 0.05, end: 0.95).animate(
      CurvedAnimation(parent: _scanLaserCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scanLaserCtrl.dispose();
    super.dispose();
  }

  void _triggerScan() {
    setState(() {
      _isProcessing = true;
    });
    HapticFeedback.mediumImpact();

    Future.delayed(const Duration(milliseconds: 1400), () {
      if (mounted) {
        setState(() {
          _isProcessing = false;
          _isScanned = true;
        });
        CommonMethods.showToast(
          message: 'تم التعرف على بيانات الفاتورة بنجاح بواسطة Delta OCR AI!',
          type: ToastType.success,
        );
      }
    });
  }

  void _confirmAndPost() {
    HapticFeedback.mediumImpact();
    CommonMethods.showToast(
      message: 'تم ترحيل الفاتورة إلى قيود اليومية بنجاح!',
      type: ToastType.success,
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.darkBackground,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        centerTitle: true,
        title: Text(
          'مسح ورفع المستندات الذكي',
          style: AppTextStyle.appBarStyle(context).copyWith(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: AppColor.emeraldTeal.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: AppColor.emeraldTeal.withValues(alpha: 0.4)),
            ),
            alignment: Alignment.center,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.auto_awesome_rounded, color: AppColor.emeraldTeal, size: 12.r),
                Gap(4.w),
                Text(
                  'OCR Active',
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColor.emeraldTeal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── 1. Document Category Pill ────────────────────────────
            _buildCategorySelector(),
            Gap(16.h),

            // ── 2. Scanner Viewfinder or Document Preview ─────────────
            _buildScannerViewfinder(),
            Gap(16.h),

            // ── 3. Quick Upload Options (Camera / Gallery / PDF) ──────
            _buildUploadOptionsRow(),
            Gap(20.h),

            // ── 4. OCR Auto-Extracted Data Form ───────────────────────
            if (_isScanned) ...[
              _buildExtractedDataCard(),
              Gap(24.h),
              _buildConfirmButton(),
            ] else ...[
              _buildInstructionCard(),
            ],
            Gap(30.h),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySelector() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _docCategory,
          isExpanded: true,
          dropdownColor: const Color(0xFF1E293B),
          icon: Icon(Icons.keyboard_arrow_down_rounded, color: AppColor.cyanLight),
          style: const TextStyle(color: Colors.white, fontFamily: 'Tajawal'),
          items: [
            'فاتورة مشتريات (Purchase Bill)',
            'إيصال مصروفات نقدية (Expense Receipt)',
            'عقد اتفاقية (Contract)',
            'كشف حساب بنكي (Bank Statement)',
          ]
              .map((c) => DropdownMenuItem(value: c, child: Text(c)))
              .toList(),
          onChanged: (val) {
            if (val != null) setState(() => _docCategory = val);
          },
        ),
      ),
    );
  }

  Widget _buildScannerViewfinder() {
    return Container(
      height: 240.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: _isScanned ? AppColor.emeraldTeal : AppColor.royalIndigo.withValues(alpha: 0.4),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Viewfinder background grid / preview
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF0F172A),
                      const Color(0xFF1E293B).withValues(alpha: 0.6),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Center(
                  child: _isScanned
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check_circle_rounded, color: AppColor.emeraldTeal, size: 54.r),
                            Gap(8.h),
                            Text(
                              'تم استخراج وقراءة المستند بنجاح',
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'Tajawal',
                              ),
                            ),
                            Text(
                              'فاتورة ضريبية #INV-9281 (دقة التعرف: 99.4%)',
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: AppColor.cyanLight,
                                fontFamily: 'Tajawal',
                              ),
                            ),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.document_scanner_outlined, color: AppColor.cyanLight, size: 48.r),
                            Gap(10.h),
                            Text(
                              'ضع الفاتورة أو المستند داخل الإطار',
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                fontFamily: 'Tajawal',
                              ),
                            ),
                            Gap(4.h),
                            Text(
                              'يتم التعرف التلقائي على الأرقام والمبالغ والضريبة',
                              style: TextStyle(
                                fontSize: 10.5.sp,
                                color: Colors.white.withValues(alpha: 0.5),
                                fontFamily: 'Tajawal',
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),

            // Corner Frame Guides
            Positioned(top: 16.r, left: 16.r, child: _buildCornerGuide(Alignment.topLeft)),
            Positioned(top: 16.r, right: 16.r, child: _buildCornerGuide(Alignment.topRight)),
            Positioned(bottom: 16.r, left: 16.r, child: _buildCornerGuide(Alignment.bottomLeft)),
            Positioned(bottom: 16.r, right: 16.r, child: _buildCornerGuide(Alignment.bottomRight)),

            // Scanning Laser Line (Animated when scanning)
            if (!_isScanned || _isProcessing)
              AnimatedBuilder(
                animation: _scanLaserAnim,
                builder: (context, child) {
                  return Positioned(
                    top: _scanLaserAnim.value * 230.h,
                    left: 20.w,
                    right: 20.w,
                    child: Container(
                      height: 2.5.h,
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
                            color: const Color(0xFF06B6D4).withValues(alpha: 0.8),
                            blurRadius: 12,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

            // Processing Loader Overlay
            if (_isProcessing)
              Container(
                color: Colors.black.withValues(alpha: 0.7),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(color: AppColor.cyanLight),
                      Gap(12.h),
                      Text(
                        'جاري تحليل واستخراج بيانات الفاتورة بالذكاء الاصطناعي...',
                        style: TextStyle(
                          fontSize: 11.5.sp,
                          color: Colors.white,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCornerGuide(Alignment alignment) {
    final isTop = alignment.y < 0;
    final isLeft = alignment.x < 0;

    return Container(
      width: 22.r,
      height: 22.r,
      decoration: BoxDecoration(
        border: Border(
          top: isTop ? BorderSide(color: AppColor.cyanLight, width: 2.5) : BorderSide.none,
          bottom: !isTop ? BorderSide(color: AppColor.cyanLight, width: 2.5) : BorderSide.none,
          left: isLeft ? BorderSide(color: AppColor.cyanLight, width: 2.5) : BorderSide.none,
          right: !isLeft ? BorderSide(color: AppColor.cyanLight, width: 2.5) : BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildUploadOptionsRow() {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            label: 'التقاط بالكاميرا',
            icon: Icons.camera_alt_rounded,
            color: AppColor.royalIndigo,
            onTap: _triggerScan,
          ),
        ),
        Gap(10.w),
        Expanded(
          child: _buildActionButton(
            label: 'اختيار صورة',
            icon: Icons.photo_library_rounded,
            color: const Color(0xFF0EA5E9),
            onTap: _triggerScan,
          ),
        ),
        Gap(10.w),
        Expanded(
          child: _buildActionButton(
            label: 'ملف PDF',
            icon: Icons.picture_as_pdf_rounded,
            color: const Color(0xFF8B5CF6),
            onTap: _triggerScan,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
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
                fontSize: 10.5.sp,
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

  Widget _buildInstructionCard() {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.tips_and_updates_rounded, color: AppColor.warningOrange, size: 20.r),
              Gap(8.w),
              Text(
                'مزايا الماسح الذكي في Delta ERP',
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
          _buildFeatureBullet('استخراج تلقائي لرمز الاستجابة السريعة (ZATCA QR Code)'),
          _buildFeatureBullet('التعرف على الرقم الضريبي للمورد ومطابقته بقاعدة البيانات'),
          _buildFeatureBullet('الربط الفوري مع شجرة الحسابات ومركز التكلفة'),
          _buildFeatureBullet('حفظ نسخة رقمية مؤرشفة مشفرة سحابياً'),
        ],
      ),
    );
  }

  Widget _buildFeatureBullet(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle_outline_rounded, color: AppColor.cyanLight, size: 14.r),
          Gap(8.w),
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
      ),
    );
  }

  Widget _buildExtractedDataCard() {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColor.emeraldTeal.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'البيانات المستخرجة آلياً (OCR Extraction)',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Tajawal',
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: AppColor.emeraldTeal.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  'جاهزة للترحيل',
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
          Gap(14.h),
          TextFormField(
            initialValue: _supplierName,
            onChanged: (val) => _supplierName = val,
            style: const TextStyle(color: Colors.white, fontFamily: 'Tajawal'),
            decoration: _inputDecoration(
              label: 'اسم المورد / الشركة',
              prefixIcon: Icons.store_rounded,
            ),
          ),
          Gap(10.h),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: _vatNumber,
                  onChanged: (val) => _vatNumber = val,
                  style: const TextStyle(color: Colors.white, fontFamily: 'Tajawal'),
                  decoration: _inputDecoration(
                    label: 'الرقم الضريبي للمورد',
                    prefixIcon: Icons.pin_rounded,
                  ),
                ),
              ),
              Gap(10.w),
              Expanded(
                child: TextFormField(
                  initialValue: _invoiceDate,
                  onChanged: (val) => _invoiceDate = val,
                  style: const TextStyle(color: Colors.white, fontFamily: 'Tajawal'),
                  decoration: _inputDecoration(
                    label: 'تاريخ الفاتورة',
                    prefixIcon: Icons.calendar_today_rounded,
                  ),
                ),
              ),
            ],
          ),
          Gap(10.h),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: _totalAmount,
                  onChanged: (val) => _totalAmount = val,
                  style: TextStyle(
                    color: AppColor.cyanLight,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Tajawal',
                  ),
                  decoration: _inputDecoration(
                    label: 'المبلغ الإجمالي (ر.س)',
                    prefixIcon: Icons.attach_money_rounded,
                  ),
                ),
              ),
              Gap(10.w),
              Expanded(
                child: TextFormField(
                  initialValue: _vatAmount,
                  onChanged: (val) => _vatAmount = val,
                  style: const TextStyle(color: Colors.white, fontFamily: 'Tajawal'),
                  decoration: _inputDecoration(
                    label: 'مبلغ الضريبة (15%)',
                    prefixIcon: Icons.receipt_rounded,
                  ),
                ),
              ),
            ],
          ),
          Gap(10.h),
          DropdownButtonFormField<String>(
            initialValue: _destinationAccount,
            dropdownColor: const Color(0xFF1E293B),
            style: const TextStyle(color: Colors.white, fontFamily: 'Tajawal'),
            decoration: _inputDecoration(
              label: 'حساب المصروف / التوجيه المحاسبي',
              prefixIcon: Icons.account_balance_rounded,
            ),
            items: [
              '5010 - مشتريات ومصروفات تشغيلية',
              '5020 - مصروفات عمومية وإدارية',
              '1030 - مخزون البضائع والمستودعات',
              '1020 - أصول ثابتة ومعدات تقنية',
            ]
                .map((acc) => DropdownMenuItem(value: acc, child: Text(acc)))
                .toList(),
            onChanged: (val) {
              if (val != null) setState(() => _destinationAccount = val);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmButton() {
    return SizedBox(
      width: double.infinity,
      height: 48.h,
      child: ElevatedButton.icon(
        onPressed: _confirmAndPost,
        icon: const Icon(Icons.check_circle_outline_rounded),
        label: Text(
          'تأكيد وترحيل الفاتورة إلى الحسابات',
          style: TextStyle(
            fontSize: 13.5.sp,
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
          elevation: 4,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({required String label, required IconData prefixIcon}) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        fontSize: 11.sp,
        color: Colors.white.withValues(alpha: 0.5),
        fontFamily: 'Tajawal',
      ),
      prefixIcon: Icon(prefixIcon, color: AppColor.cyanLight, size: 18.r),
      filled: true,
      fillColor: const Color(0xFF1E293B),
      contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: AppColor.emeraldTeal, width: 1.2),
      ),
    );
  }
}
