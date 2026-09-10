import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/custom_widgets/custom_toast/custom_toast.dart';
import 'package:my_template/core/utils/common_methods.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';

class CreateInvoiceScreen extends StatefulWidget {
  const CreateInvoiceScreen({super.key});

  @override
  State<CreateInvoiceScreen> createState() => _CreateInvoiceScreenState();
}

class _CreateInvoiceScreenState extends State<CreateInvoiceScreen> {
  final _formKey = GlobalKey<FormState>();

  String _invoiceType = 'tax'; // 'tax' = Tax Invoice, 'simplified' = Simplified
  String _customerName = 'شركة الأفق للاستشارات التقنية';
  String _customerVat = '310492817200003';
  String _paymentTerms = '30 Days';
  DateTime _issueDate = DateTime.now();
  DateTime _dueDate = DateTime.now().add(const Duration(days: 30));

  final List<_InvoiceLineItem> _items = [
    _InvoiceLineItem(
      description: 'استشارات تخطيط موارد المؤسسات (ERP)',
      quantity: 1,
      unitPrice: 12000.0,
      vatPercent: 15.0,
      discount: 0.0,
    ),
    _InvoiceLineItem(
      description: 'تركيب وتهيئة خوادم سحابية مخصصة',
      quantity: 2,
      unitPrice: 3500.0,
      vatPercent: 15.0,
      discount: 500.0,
    ),
  ];

  double get _subtotal {
    return _items.fold(0.0, (sum, item) => sum + (item.quantity * item.unitPrice - item.discount));
  }

  double get _totalVat {
    return _items.fold(0.0, (sum, item) {
      final taxable = (item.quantity * item.unitPrice) - item.discount;
      return sum + (taxable * (item.vatPercent / 100.0));
    });
  }

  double get _totalDiscount {
    return _items.fold(0.0, (sum, item) => sum + item.discount);
  }

  double get _grandTotal => _subtotal + _totalVat;

  void _addNewLineItem() {
    setState(() {
      _items.add(
        _InvoiceLineItem(
          description: 'بند جديد',
          quantity: 1,
          unitPrice: 1000.0,
          vatPercent: 15.0,
          discount: 0.0,
        ),
      );
    });
  }

  void _removeLineItem(int index) {
    if (_items.length <= 1) {
      CommonMethods.showToast(
        message: 'يجب أن تحتوي الفاتورة على بند واحد على الأقل',
        type: ToastType.warning,
      );
      return;
    }
    setState(() {
      _items.removeAt(index);
    });
  }

  void _saveInvoice(bool isIssued) {
    HapticFeedback.mediumImpact();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF111827),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
          side: BorderSide(
            color: AppColor.royalIndigo.withValues(alpha: 0.3),
            width: 1.2,
          ),
        ),
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: (isIssued ? AppColor.emeraldTeal : AppColor.royalIndigo)
                    .withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isIssued ? Icons.check_circle_rounded : Icons.save_rounded,
                color: isIssued ? AppColor.emeraldTeal : AppColor.royalIndigo,
                size: 24.r,
              ),
            ),
            Gap(10.w),
            Text(
              isIssued ? 'تم إصدار الفاتورة بنجاح' : 'تم حفظ المسودة',
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Tajawal',
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'رقم الفاتورة: INV-2026-0842\nإجمالي المبلغ: ${_grandTotal.toStringAsFixed(2)} ر.س\nمطابقة لاشتراطات هيئة الزكاة والضريبة والجمارك (ZATCA Phase 2)',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.white.withValues(alpha: 0.75),
                height: 1.5,
                fontFamily: 'Tajawal',
              ),
            ),
            Gap(16.h),
            Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.qr_code_2_rounded, color: Colors.white, size: 36.r),
                  Gap(10.w),
                  Expanded(
                    child: Text(
                      'تم إنشاء رمز الاستجابة السريعة (QR Code) المشفر تلقائياً',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColor.cyanLight,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: Text(
              'حسناً',
              style: TextStyle(
                color: AppColor.cyanLight,
                fontWeight: FontWeight.bold,
                fontSize: 13.sp,
                fontFamily: 'Tajawal',
              ),
            ),
          ),
        ],
      ),
    );
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
          'إنشاء فاتورة جديدة',
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
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: AppColor.royalIndigo.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: AppColor.royalIndigo.withValues(alpha: 0.4)),
            ),
            alignment: Alignment.center,
            child: Text(
              'INV-2026-0842',
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.bold,
                color: AppColor.cyanLight,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.r),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── 1. Top Grand Total Card ─────────────────────────────
              _buildGrandTotalCard(),
              Gap(16.h),

              // ── 2. Invoice Type Selector ────────────────────────────
              _buildTypeSelector(),
              Gap(16.h),

              // ── 3. Customer Info Section ────────────────────────────
              _buildCustomerSection(),
              Gap(16.h),

              // ── 4. Invoice Dates & Terms ────────────────────────────
              _buildDatesAndTermsSection(),
              Gap(16.h),

              // ── 5. Line Items ───────────────────────────────────────
              _buildLineItemsSection(),
              Gap(16.h),

              // ── 6. Summary Breakdown ────────────────────────────────
              _buildSummaryBreakdown(),
              Gap(24.h),

              // ── 7. Action Buttons ───────────────────────────────────
              _buildFooterActions(),
              Gap(30.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGrandTotalCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF1E293B),
            Color(0xFF0F172A),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: AppColor.royalIndigo.withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'المبلغ الإجمالي المستحق',
                style: TextStyle(
                  fontSize: 11.5.sp,
                  color: Colors.white.withValues(alpha: 0.6),
                  fontFamily: 'Tajawal',
                ),
              ),
              Gap(4.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    _grandTotal.toStringAsFixed(2),
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 0.5,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  Gap(4.w),
                  Text(
                    'ر.س',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColor.cyanLight,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: AppColor.emeraldTeal.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                color: AppColor.emeraldTeal.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.verified_rounded, color: AppColor.emeraldTeal, size: 14.r),
                Gap(4.w),
                Text(
                  'متوافقة مع ZATCA',
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColor.emeraldTeal,
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

  Widget _buildTypeSelector() {
    return Container(
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildTypePill(
              title: 'فاتورة ضريبية (B2B)',
              value: 'tax',
              isSelected: _invoiceType == 'tax',
            ),
          ),
          Expanded(
            child: _buildTypePill(
              title: 'فاتورة مبسطة (B2C)',
              value: 'simplified',
              isSelected: _invoiceType == 'simplified',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypePill({
    required String title,
    required String value,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => setState(() => _invoiceType = value),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColor.royalIndigo : Colors.transparent,
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColor.royalIndigo.withValues(alpha: 0.4),
                    blurRadius: 10,
                  )
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? Colors.white : const Color(0xFF94A3B8),
            fontFamily: 'Tajawal',
          ),
        ),
      ),
    );
  }

  Widget _buildCustomerSection() {
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'بيانات العميل',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Tajawal',
                ),
              ),
              GestureDetector(
                onTap: () {
                  CommonMethods.showToast(
                    message: 'يمكنك اختيار العميل من القائمة أو إضافة عميل جديد',
                    type: ToastType.help,
                  );
                },
                child: Row(
                  children: [
                    Icon(Icons.person_search_rounded, color: AppColor.cyanLight, size: 16.r),
                    Gap(4.w),
                    Text(
                      'اختيار عميل',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColor.cyanLight,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Gap(12.h),
          TextFormField(
            initialValue: _customerName,
            onChanged: (val) => _customerName = val,
            style: const TextStyle(color: Colors.white, fontFamily: 'Tajawal'),
            decoration: _inputDecoration(
              label: 'اسم المنشأة / العميل',
              prefixIcon: Icons.business_rounded,
            ),
          ),
          Gap(10.h),
          TextFormField(
            initialValue: _customerVat,
            onChanged: (val) => _customerVat = val,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white, fontFamily: 'Tajawal'),
            decoration: _inputDecoration(
              label: 'الرقم الضريبي للعميل (15 رقماً)',
              prefixIcon: Icons.pin_rounded,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDatesAndTermsSection() {
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
          Text(
            'شروط وتواريخ الدفع',
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'Tajawal',
            ),
          ),
          Gap(12.h),
          Row(
            children: [
              Expanded(
                child: _buildDateTile(
                  title: 'تاريخ الإصدار',
                  date: '${_issueDate.year}-${_issueDate.month.toString().padLeft(2, '0')}-${_issueDate.day.toString().padLeft(2, '0')}',
                  icon: Icons.calendar_today_rounded,
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _issueDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                    );
                    if (picked != null) setState(() => _issueDate = picked);
                  },
                ),
              ),
              Gap(10.w),
              Expanded(
                child: _buildDateTile(
                  title: 'تاريخ الاستحقاق',
                  date: '${_dueDate.year}-${_dueDate.month.toString().padLeft(2, '0')}-${_dueDate.day.toString().padLeft(2, '0')}',
                  icon: Icons.event_available_rounded,
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _dueDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                    );
                    if (picked != null) setState(() => _dueDate = picked);
                  },
                ),
              ),
            ],
          ),
          Gap(10.h),
          DropdownButtonFormField<String>(
            initialValue: _paymentTerms,
            dropdownColor: const Color(0xFF1E293B),
            style: const TextStyle(color: Colors.white, fontFamily: 'Tajawal'),
            decoration: _inputDecoration(
              label: 'شروط السداد',
              prefixIcon: Icons.credit_card_rounded,
            ),
            items: ['Immediate (فوري)', '15 Days', '30 Days', '60 Days', '90 Days']
                .map((term) => DropdownMenuItem(
                      value: term,
                      child: Text(term),
                    ))
                .toList(),
            onChanged: (val) {
              if (val != null) setState(() => _paymentTerms = val);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDateTile({
    required String title,
    required String date,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColor.cyanLight, size: 16.r),
            Gap(8.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 9.sp,
                      color: Colors.white.withValues(alpha: 0.5),
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  Gap(2.h),
                  Text(
                    date,
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
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

  Widget _buildLineItemsSection() {
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'بنود الفاتورة (${_items.length})',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Tajawal',
                ),
              ),
              ElevatedButton.icon(
                onPressed: _addNewLineItem,
                icon: Icon(Icons.add_rounded, size: 16.r),
                label: Text(
                  'إضافة بند',
                  style: TextStyle(fontSize: 11.sp, fontFamily: 'Tajawal'),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.royalIndigo,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              ),
            ],
          ),
          Gap(12.h),
          ..._items.asMap().entries.map((entry) {
            final idx = entry.key;
            final item = entry.value;
            final lineTotal = (item.quantity * item.unitPrice) - item.discount;
            final lineVat = lineTotal * (item.vatPercent / 100.0);

            return Container(
              margin: EdgeInsets.only(bottom: 10.h),
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B).withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(6.r),
                        decoration: BoxDecoration(
                          color: AppColor.royalIndigo.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${idx + 1}',
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColor.cyanLight,
                          ),
                        ),
                      ),
                      Gap(8.w),
                      Expanded(
                        child: TextFormField(
                          initialValue: item.description,
                          onChanged: (val) => setState(() => item.description = val),
                          style: const TextStyle(color: Colors.white, fontFamily: 'Tajawal', fontSize: 12),
                          decoration: const InputDecoration(
                            isDense: true,
                            hintText: 'وصف البند / الخدمة',
                            hintStyle: TextStyle(color: Colors.white30),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => _removeLineItem(idx),
                        icon: const Icon(Icons.delete_outline_rounded, color: Color(0xFFF43F5E), size: 20),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  Gap(8.h),
                  Row(
                    children: [
                      Expanded(
                        child: _buildMiniInput(
                          label: 'الكمية',
                          value: '${item.quantity}',
                          onChanged: (val) {
                            final q = int.tryParse(val);
                            if (q != null && q > 0) setState(() => item.quantity = q);
                          },
                        ),
                      ),
                      Gap(6.w),
                      Expanded(
                        child: _buildMiniInput(
                          label: 'سعر الوحدة',
                          value: '${item.unitPrice}',
                          onChanged: (val) {
                            final p = double.tryParse(val);
                            if (p != null) setState(() => item.unitPrice = p);
                          },
                        ),
                      ),
                      Gap(6.w),
                      Expanded(
                        child: _buildMiniInput(
                          label: 'الخصم',
                          value: '${item.discount}',
                          onChanged: (val) {
                            final d = double.tryParse(val);
                            if (d != null) setState(() => item.discount = d);
                          },
                        ),
                      ),
                    ],
                  ),
                  Gap(8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'ضريبة (15%): ${lineVat.toStringAsFixed(2)} ر.س',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 9.5.sp,
                            color: AppColor.cyanLight,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                      ),
                      Gap(6.w),
                      Expanded(
                        child: Text(
                          'الإجمالي: ${(lineTotal + lineVat).toStringAsFixed(2)} ر.س',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildMiniInput({
    required String label,
    required String value,
    required ValueChanged<String> onChanged,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 8.5.sp,
              color: Colors.white.withValues(alpha: 0.5),
              fontFamily: 'Tajawal',
            ),
          ),
          TextFormField(
            initialValue: value,
            keyboardType: TextInputType.number,
            onChanged: onChanged,
            style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.bold, color: Colors.white),
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.zero,
              border: InputBorder.none,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryBreakdown() {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        children: [
          _buildSummaryRow(label: 'المجموع الفرعي الخاضع للضريبة', value: '${_subtotal.toStringAsFixed(2)} ر.س'),
          _buildSummaryRow(label: 'إجمالي الخصومات', value: '- ${_totalDiscount.toStringAsFixed(2)} ر.س', isDiscount: true),
          _buildSummaryRow(label: 'ضريبة القيمة المضافة (15%)', value: '${_totalVat.toStringAsFixed(2)} ر.س'),
          const Divider(color: Colors.white12, height: 20),
          _buildSummaryRow(
            label: 'المجموع الكلي النهائي',
            value: '${_grandTotal.toStringAsFixed(2)} ر.س',
            isGrandTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow({
    required String label,
    required String value,
    bool isDiscount = false,
    bool isGrandTotal = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isGrandTotal ? 13.sp : 11.sp,
              fontWeight: isGrandTotal ? FontWeight.bold : FontWeight.w500,
              color: isGrandTotal ? Colors.white : Colors.white.withValues(alpha: 0.7),
              fontFamily: 'Tajawal',
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isGrandTotal ? 14.sp : 11.5.sp,
              fontWeight: isGrandTotal ? FontWeight.w900 : FontWeight.bold,
              color: isGrandTotal
                  ? AppColor.cyanLight
                  : (isDiscount ? const Color(0xFFF43F5E) : Colors.white),
              fontFamily: 'Tajawal',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterActions() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _saveInvoice(false),
            icon: const Icon(Icons.save_outlined),
            label: Text(
              'حفظ كمسودة',
              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
              padding: EdgeInsets.symmetric(vertical: 12.h),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
            ),
          ),
        ),
        Gap(12.w),
        Expanded(
          flex: 2,
          child: ElevatedButton.icon(
            onPressed: () => _saveInvoice(true),
            icon: const Icon(Icons.send_rounded),
            label: Text(
              'إصدار واعتماد الفاتورة',
              style: TextStyle(fontSize: 12.5.sp, fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.royalIndigo,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 12.h),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
              elevation: 4,
            ),
          ),
        ),
      ],
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
        borderSide: BorderSide(color: AppColor.royalIndigo, width: 1.2),
      ),
    );
  }
}

class _InvoiceLineItem {
  String description;
  int quantity;
  double unitPrice;
  double vatPercent;
  double discount;

  _InvoiceLineItem({
    required this.description,
    required this.quantity,
    required this.unitPrice,
    required this.vatPercent,
    required this.discount,
  });
}
