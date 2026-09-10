import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';

class AiCopilotScreen extends StatefulWidget {
  const AiCopilotScreen({super.key});

  @override
  State<AiCopilotScreen> createState() => _AiCopilotScreenState();
}

class _AiCopilotScreenState extends State<AiCopilotScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;

  final List<_ChatMessage> _messages = [
    _ChatMessage(
      isUser: false,
      text: 'مرحباً بك! أنا Delta AI Copilot، مساعدك الذكي لإدارة الأعمال وتخطيط الموارد (ERP).\n\nيمكنني مساعدتك في تحليل المبيعات، كشف الفواتير المعلقة، التنبؤ بالسيولة النقدية، أو إنشاء قيود محاسبية فورية. كيف يمكنني خدمتك اليوم؟',
      timestamp: 'الآن',
      suggestions: [
        '📊 حلل أداء المبيعات لشهر سبتمبر',
        '⚠️ هل توجد فواتير متأخرة السداد؟',
        '💰 توقع التدفق النقدي للأسبوعين القادمين',
        '📦 تقرير المنتجات الأكثر مبيعاً والأقل مخزوناً',
      ],
    ),
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage([String? customText]) {
    final text = customText ?? _messageController.text.trim();
    if (text.isEmpty) return;

    HapticFeedback.lightImpact();
    setState(() {
      _messages.add(
        _ChatMessage(
          isUser: true,
          text: text,
          timestamp: 'الآن',
        ),
      );
      _isTyping = true;
    });

    if (customText == null) {
      _messageController.clear();
    }

    _scrollToBottom();

    // Simulate AI smart response
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) {
        setState(() {
          _isTyping = false;
          _messages.add(_generateAiResponse(text));
        });
        _scrollToBottom();
      }
    });
  }

  _ChatMessage _generateAiResponse(String query) {
    if (query.contains('مبيعات') || query.contains('سبتمبر')) {
      return _ChatMessage(
        isUser: false,
        text: '📈 **ملخص أداء مبيعات شهر سبتمبر 2026:**\n\n• إجمالي المبيعات المحققة: **215,400 ر.س** (بنمو **+18.4%** مقارنة بالشهر السابق).\n• أعلى قطاع نمواً: **الخدمات السحابية واستشارات ERP**.\n• عدد الفواتير المصدرة: **42 فاتورة**.\n• نسبة التحصيل النقدي الفوري: **76%**.',
        timestamp: 'الآن',
        metricCards: [
          {'title': 'إجمالي المبيعات', 'value': '215.4K ر.س', 'trend': '+18.4%'},
          {'title': 'الفواتير المصدرة', 'value': '42', 'trend': '+6'},
        ],
      );
    } else if (query.contains('متأخرة') || query.contains('فواتير')) {
      return _ChatMessage(
        isUser: false,
        text: '⚠️ **تقرير الفواتير متأخرة السداد:**\n\nيوجد حالياً **3 فواتير** تجاوزت موعد الاستحقاق بإجمالي **38,500 ر.س**:\n\n1. شركة البناء الحديث (#INV-0782) - **18,000 ر.س** (متأخرة 12 يوماً)\n2. مؤسسة النخبة التجارية (#INV-0811) - **12,500 ر.س** (متأخرة 5 أيام)\n3. تكنو الخليج (#INV-0830) - **8,000 ر.س** (متأخرة 3 أيام)\n\nهل ترغب في إرسال إشعار تذكير آلي عبر الواتساب والبريد للعملاء؟',
        timestamp: 'الآن',
        suggestions: [
          '📲 إرسال تذكير فوري لجميع المتأخرين',
          '📄 تنزيل كشف أعمار الديون PDF',
        ],
      );
    } else if (query.contains('التدفق') || query.contains('السيولة')) {
      return _ChatMessage(
        isUser: false,
        text: '💰 **توقع التدفق النقدي الذكي (Cash Flow Forecast):**\n\n• التدفقات النقدية المتوقعة للداخل (Inflow): **142,000 ر.س**\n• الالتزامات والرواتب القادمة (Outflow): **86,500 ر.س**\n• صافي الفائض النقدي المتوقع: **+55,500 ر.س**\n\nمستوى الأمان المالي للشركة: **ممتاز (مغطى لمدة 4.2 أشهر)**.',
        timestamp: 'الآن',
      );
    } else {
      return _ChatMessage(
        isUser: false,
        text: 'تم تحليل طلبك بنجاح! وفقاً لقاعدة بيانات Delta ERP، جميع المؤشرات والعمليات التشغيلية تعمل بأعلى كفاءة ومطابقة لاشتراطات النظام المحاسبي المعتمد.',
        timestamp: 'الآن',
      );
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.darkBackground,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4F46E5), Color(0xFF06B6D4)],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColor.royalIndigo.withValues(alpha: 0.5),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 16.r),
            ),
            Gap(10.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Delta AI Copilot',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Tajawal',
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 6.r,
                      height: 6.r,
                      decoration: const BoxDecoration(
                        color: Color(0xFF10B981),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Gap(4.w),
                    Text(
                      'متصل بقاعدة بيانات ERP',
                      style: TextStyle(
                        fontSize: 9.5.sp,
                        color: AppColor.cyanLight,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Colors.white70),
            onPressed: () {
              setState(() {
                _messages.clear();
                _messages.add(
                  _ChatMessage(
                    isUser: false,
                    text: 'تمت إعادة تهيئة جلسة الذكاء الاصطناعي بنجاح.',
                    timestamp: 'الآن',
                  ),
                );
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // ── 1. Messages List ─────────────────────────────────────
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(16.r),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return _buildMessageBubble(msg);
              },
            ),
          ),

          // ── 2. Typing Indicator ──────────────────────────────────
          if (_isTyping)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 14.r,
                          height: 14.r,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColor.cyanLight,
                          ),
                        ),
                        Gap(8.w),
                        Text(
                          'المساعد الذكي يقوم بالتحليل...',
                          style: TextStyle(
                            fontSize: 10.5.sp,
                            color: Colors.white70,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          // ── 3. Bottom Input Bar ──────────────────────────────────
          _buildInputBar(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(_ChatMessage msg) {
    return Align(
      alignment: msg.isUser ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.only(bottom: 14.h),
        constraints: BoxConstraints(maxWidth: 0.85.sw),
        child: Column(
          crossAxisAlignment:
              msg.isUser ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: [
            Container(
              padding: EdgeInsets.all(14.r),
              decoration: BoxDecoration(
                gradient: msg.isUser
                    ? const LinearGradient(
                        colors: [Color(0xFF4F46E5), Color(0xFF06B6D4)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: msg.isUser ? null : const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: msg.isUser
                      ? Colors.transparent
                      : Colors.white.withValues(alpha: 0.08),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    msg.text,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.white,
                      height: 1.5,
                      fontFamily: 'Tajawal',
                    ),
                  ),

                  // Metric Cards if present
                  if (msg.metricCards != null) ...[
                    Gap(10.h),
                    Row(
                      children: msg.metricCards!.map((card) {
                        return Expanded(
                          child: Container(
                            margin: EdgeInsets.only(right: 6.w),
                            padding: EdgeInsets.all(8.r),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0F172A),
                              borderRadius: BorderRadius.circular(10.r),
                              border: Border.all(
                                color: AppColor.royalIndigo.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  card['title']!,
                                  style: TextStyle(
                                    fontSize: 9.sp,
                                    color: Colors.white54,
                                    fontFamily: 'Tajawal',
                                  ),
                                ),
                                Gap(2.h),
                                Text(
                                  card['value']!,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.bold,
                                    color: AppColor.cyanLight,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),

            // Suggestions Chips
            if (msg.suggestions != null && msg.suggestions!.isNotEmpty) ...[
              Gap(8.h),
              Wrap(
                spacing: 6.w,
                runSpacing: 6.h,
                children: msg.suggestions!.map((suggestion) {
                  return GestureDetector(
                    onTap: () => _sendMessage(suggestion),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFF111827),
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: AppColor.royalIndigo.withValues(alpha: 0.4),
                        ),
                      ),
                      child: Text(
                        suggestion,
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColor.cyanLight,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 20.h),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        border: Border(
          top: BorderSide(
            color: Colors.white.withValues(alpha: 0.08),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(Icons.attach_file_rounded, color: AppColor.cyanLight, size: 20.r),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('يمكنك إرفاق صور الفواتير أو ملفات Excel للتحليل'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
            ),
            Gap(8.w),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(24.r),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
                child: TextField(
                  controller: _messageController,
                  style: const TextStyle(color: Colors.white, fontFamily: 'Tajawal'),
                  decoration: const InputDecoration(
                    hintText: 'اسأل المساعد الذكي عن أي بيان في النظام...',
                    hintStyle: TextStyle(color: Colors.white38, fontSize: 12),
                    border: InputBorder.none,
                  ),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
            ),
            Gap(8.w),
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4F46E5), Color(0xFF06B6D4)],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColor.royalIndigo.withValues(alpha: 0.4),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                onPressed: () => _sendMessage(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatMessage {
  final bool isUser;
  final String text;
  final String timestamp;
  final List<String>? suggestions;
  final List<Map<String, String>>? metricCards;

  _ChatMessage({
    required this.isUser,
    required this.text,
    required this.timestamp,
    this.suggestions,
    this.metricCards,
  });
}
