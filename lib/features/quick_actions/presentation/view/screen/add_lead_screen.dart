import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/custom_widgets/custom_toast/custom_toast.dart';
import 'package:my_template/core/utils/common_methods.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';

class AddLeadScreen extends StatefulWidget {
  const AddLeadScreen({super.key});

  @override
  State<AddLeadScreen> createState() => _AddLeadScreenState();
}

class _AddLeadScreenState extends State<AddLeadScreen> {
  final _formKey = GlobalKey<FormState>();

  String _entityType = 'corporate'; // corporate or individual
  String _leadSource = 'موقع إلكتروني';
  String _priority = 'Hot (عالية الأهمية)';
  String _stage = 'تأهيل العميل (Qualification)';
  String _assignedAgent = 'م. أحمد خالد (مدير مبيعات الشركات)';

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _expectedValueController = TextEditingController(text: '75,000');
  final TextEditingController _notesController = TextEditingController();

  DateTime _followUpDate = DateTime.now().add(const Duration(days: 2));

  @override
  void dispose() {
    _nameController.dispose();
    _companyController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _expectedValueController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _saveLead() {
    HapticFeedback.mediumImpact();
    CommonMethods.showToast(
      message: 'تم إضافة العميل المحتمل بنجاح وتعيينه للمتابعة!',
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
          'إضافة عميل محتمل جديد',
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
              color: AppColor.royalIndigo.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: AppColor.royalIndigo.withValues(alpha: 0.4)),
            ),
            alignment: Alignment.center,
            child: Text(
              '#LEAD-4921',
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
              // ── 1. Type Switcher ────────────────────────────────────
              _buildEntityTypeSelector(),
              Gap(16.h),

              // ── 2. Primary Information Card ─────────────────────────
              _buildPrimaryInfoCard(),
              Gap(16.h),

              // ── 3. Pipeline & Opportunity Value ─────────────────────
              _buildPipelineCard(),
              Gap(16.h),

              // ── 4. Follow-up & Next Action ──────────────────────────
              _buildFollowUpCard(),
              Gap(24.h),

              // ── 5. Submit Button ────────────────────────────────────
              _buildSubmitButton(),
              Gap(30.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEntityTypeSelector() {
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
              title: 'شركة / قطاع أعمال (B2B)',
              value: 'corporate',
              isSelected: _entityType == 'corporate',
              icon: Icons.domain_rounded,
            ),
          ),
          Expanded(
            child: _buildTypePill(
              title: 'فرد / عميل مباشر (B2C)',
              value: 'individual',
              isSelected: _entityType == 'individual',
              icon: Icons.person_outline_rounded,
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
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: () => setState(() => _entityType = value),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 9.h),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16.r,
              color: isSelected ? Colors.white : const Color(0xFF94A3B8),
            ),
            Gap(6.w),
            Text(
              title,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? Colors.white : const Color(0xFF94A3B8),
                fontFamily: 'Tajawal',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrimaryInfoCard() {
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
            'بيانات الاتصال والتواصل',
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'Tajawal',
            ),
          ),
          Gap(12.h),
          if (_entityType == 'corporate') ...[
            TextFormField(
              controller: _companyController,
              style: const TextStyle(color: Colors.white, fontFamily: 'Tajawal'),
              decoration: _inputDecoration(
                label: 'اسم الشركة / المؤسسة *',
                prefixIcon: Icons.apartment_rounded,
              ),
            ),
            Gap(10.h),
          ],
          TextFormField(
            controller: _nameController,
            style: const TextStyle(color: Colors.white, fontFamily: 'Tajawal'),
            decoration: _inputDecoration(
              label: 'اسم الشخص المسؤول / العميل *',
              prefixIcon: Icons.badge_outlined,
            ),
          ),
          Gap(10.h),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(color: Colors.white, fontFamily: 'Tajawal'),
                  decoration: _inputDecoration(
                    label: 'رقم الجوال *',
                    prefixIcon: Icons.phone_android_rounded,
                  ),
                ),
              ),
              Gap(10.w),
              Expanded(
                child: TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: Colors.white, fontFamily: 'Tajawal'),
                  decoration: _inputDecoration(
                    label: 'البريد الإلكتروني',
                    prefixIcon: Icons.alternate_email_rounded,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPipelineCard() {
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
            'تفاصيل الفرصة البيعية والمسار',
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
                child: DropdownButtonFormField<String>(
                  value: _leadSource,
                  isExpanded: true,
                  dropdownColor: const Color(0xFF1E293B),
                  style: const TextStyle(color: Colors.white, fontFamily: 'Tajawal'),
                  decoration: _inputDecoration(
                    label: 'مصدر العميل',
                    prefixIcon: Icons.campaign_rounded,
                  ),
                  items: [
                    'موقع إلكتروني',
                    'توصية / إحالة',
                    'لينكد إن (LinkedIn)',
                    'اتصال تسويقي',
                    'معرض / مؤتمر',
                  ]
                      .map((src) => DropdownMenuItem(
                            value: src,
                            child: Text(src, overflow: TextOverflow.ellipsis),
                          ))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _leadSource = val);
                  },
                ),
              ),
              Gap(10.w),
              Expanded(
                child: TextFormField(
                  controller: _expectedValueController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white, fontFamily: 'Tajawal'),
                  decoration: _inputDecoration(
                    label: 'القيمة المتوقعة (SAR)',
                    prefixIcon: Icons.monetization_on_outlined,
                  ),
                ),
              ),
            ],
          ),
          Gap(10.h),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _priority,
                  isExpanded: true,
                  dropdownColor: const Color(0xFF1E293B),
                  style: const TextStyle(color: Colors.white, fontFamily: 'Tajawal'),
                  decoration: _inputDecoration(
                    label: 'أولوية العميل',
                    prefixIcon: Icons.local_fire_department_rounded,
                  ),
                  items: [
                    'Hot (عالية الأهمية)',
                    'Warm (متوسطة)',
                    'Cold (منخفضة)',
                  ]
                      .map((p) => DropdownMenuItem(
                            value: p,
                            child: Text(p, overflow: TextOverflow.ellipsis),
                          ))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _priority = val);
                  },
                ),
              ),
              Gap(10.w),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _stage,
                  isExpanded: true,
                  dropdownColor: const Color(0xFF1E293B),
                  style: const TextStyle(color: Colors.white, fontFamily: 'Tajawal'),
                  decoration: _inputDecoration(
                    label: 'مرحلة البيع',
                    prefixIcon: Icons.timeline_rounded,
                  ),
                  items: [
                    'تأهيل العميل (Qualification)',
                    'عرض أولي (Demo)',
                    'إرسال عرض سعر (Quote)',
                    'مفاوضات (Negotiation)',
                  ]
                      .map((s) => DropdownMenuItem(
                            value: s,
                            child: Text(s, overflow: TextOverflow.ellipsis),
                          ))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _stage = val);
                  },
                ),
              ),
            ],
          ),
          Gap(10.h),
          DropdownButtonFormField<String>(
            value: _assignedAgent,
            isExpanded: true,
            dropdownColor: const Color(0xFF1E293B),
            style: const TextStyle(color: Colors.white, fontFamily: 'Tajawal'),
            decoration: _inputDecoration(
              label: 'المسؤول المعين للمتابعة',
              prefixIcon: Icons.support_agent_rounded,
            ),
            items: [
              'م. أحمد خالد (مدير مبيعات الشركات)',
              'سارة المنصور (استشاري حلول ERP)',
              'فهد السبيعي (أخصائي حسابات عملاء)',
            ]
                .map((a) => DropdownMenuItem(
                      value: a,
                      child: Text(a, overflow: TextOverflow.ellipsis),
                    ))
                .toList(),
            onChanged: (val) {
              if (val != null) setState(() => _assignedAgent = val);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFollowUpCard() {
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
            'المتابعة والملاحظات',
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'Tajawal',
            ),
          ),
          Gap(12.h),
          GestureDetector(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _followUpDate,
                firstDate: DateTime.now(),
                lastDate: DateTime(2030),
              );
              if (picked != null) setState(() => _followUpDate = picked);
            },
            child: Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
              ),
              child: Row(
                children: [
                  Icon(Icons.calendar_month_rounded, color: AppColor.cyanLight, size: 20.r),
                  Gap(10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'موعد المتابعة القادمة (Next Follow-up)',
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.white.withValues(alpha: 0.5),
                            fontFamily: 'Tajawal',
                          ),
                        ),
                        Gap(2.h),
                        Text(
                          '${_followUpDate.year}-${_followUpDate.month.toString().padLeft(2, '0')}-${_followUpDate.day.toString().padLeft(2, '0')}',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.edit_calendar_rounded, color: AppColor.cyanLight, size: 18.r),
                ],
              ),
            ),
          ),
          Gap(12.h),
          TextFormField(
            controller: _notesController,
            maxLines: 3,
            style: const TextStyle(color: Colors.white, fontFamily: 'Tajawal'),
            decoration: _inputDecoration(
              label: 'ملاحظات ومتطلبات العميل المبدئية...',
              prefixIcon: Icons.notes_rounded,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 48.h,
      child: ElevatedButton.icon(
        onPressed: _saveLead,
        icon: const Icon(Icons.person_add_alt_1_rounded),
        label: Text(
          'حفظ وتعيين العميل المحتمل',
          style: TextStyle(
            fontSize: 13.5.sp,
            fontWeight: FontWeight.bold,
            fontFamily: 'Tajawal',
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.royalIndigo,
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
        borderSide: BorderSide(color: AppColor.royalIndigo, width: 1.2),
      ),
    );
  }
}
