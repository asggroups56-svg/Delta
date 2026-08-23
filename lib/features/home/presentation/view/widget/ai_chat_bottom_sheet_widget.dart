import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:my_template/core/services/gemini_service.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_locale_key.dart';

class AiChatBottomSheetWidget extends StatefulWidget {
  const AiChatBottomSheetWidget({super.key});

  @override
  State<AiChatBottomSheetWidget> createState() => _AiChatBottomSheetWidgetState();
}

class _AiChatBottomSheetWidgetState extends State<AiChatBottomSheetWidget> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _isThinking = false;
  late final List<Map<String, String>> _messages;

  @override
  void initState() {
    super.initState();
    _messages = [];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_messages.isEmpty) {
      _messages.add({
        'role': 'ai',
        'text': AppLocaleKey.aiWelcomeMessage.tr(),
      });
    }
  }

  void _showApiKeyDialog() {
    final keyController = TextEditingController(text: GeminiService.apiKey);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColor.darkCardBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        title: Row(
          children: [
            Icon(Icons.key_rounded, color: AppColor.emeraldTeal, size: 22.r),
            Gap(8.w),
            Text(
              'Google AI Studio Key',
              style: AppTextStyle.bodyMedium(ctx).copyWith( color: AppColor.whiteColor(ctx), fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'أدخل مفتاح API الخاص بك من Google AI Studio لتفعيل نموذج Gemini المباشر:',
              style: AppTextStyle.bodySmall(ctx).copyWith(color: AppColor.whiteColor(ctx).withValues(alpha: 0.7)),
            ),
            Gap(12.h),
            TextField(
              controller: keyController,
              style: AppTextStyle.bodySmall(ctx).copyWith(color: AppColor.whiteColor(ctx)),
              decoration: InputDecoration(
                hintText: 'AIzaSy...',
                hintStyle: AppTextStyle.bodySmall(ctx).copyWith(color: AppColor.whiteColor(ctx).withValues(alpha: 0.3)),
                filled: true,
                fillColor: AppColor.darkSurface,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r), borderSide: BorderSide.none),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('إلغاء', style: AppTextStyle.bodySmall(ctx).copyWith(color: AppColor.whiteColor(ctx).withValues(alpha: 0.6))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColor.emeraldTeal),
            onPressed: () {
              GeminiService.apiKey = keyController.text.trim();
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('تم حفظ مفتاح Google AI Studio بنجاح!'),
                  backgroundColor: AppColor.emeraldTeal,
                ),
              );
            },
            child:  Text('حفظ', style: AppTextStyle.bodyMedium(ctx).copyWith(fontWeight: FontWeight.bold, color: AppColor.whiteColor(ctx))),
          ),
        ],
      ),
    );
  }

  void _sendMessage([String? customText]) async {
    final text = (customText ?? _controller.text).trim();
    if (text.isEmpty || _isThinking) return;

    if (customText == null) {
      _controller.clear();
    }

    setState(() {
      _messages.add({'role': 'user', 'text': text});
      _isThinking = true;
    });

    _scrollToBottom();

    final response = await GeminiService.generateResponse(
      prompt: text,
      history: _messages,
    );

    if (mounted) {
      setState(() {
        _isThinking = false;
        _messages.add({'role': 'ai', 'text': response});
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> suggestions = context.locale.languageCode == 'ar'
        ? [
            {'label': 'ما هي عاصمة اليمن؟', 'query': 'ما هي عاصمة اليمن؟'},
            {'label': 'ماهي عاصمة مصر؟', 'query': 'ماهي عاصمة مصر؟'},
            {'label': 'احسب ضريبة 2000 ريال', 'query': 'احسب ضريبة 2000 ريال'},
            {'label': 'ما هي عاصمة فلسطين؟', 'query': 'ما هي عاصمة فلسطين؟'},
          ]
        : [
            {'label': 'What is capital of Yemen?', 'query': 'What is capital of Yemen?'},
            {'label': 'What is capital of Egypt?', 'query': 'What is capital of Egypt?'},
            {'label': 'Calculate VAT for 2000 SAR', 'query': 'Calculate VAT for 2000 SAR'},
            {'label': 'What is capital of Palestine?', 'query': 'What is capital of Palestine?'},
          ];

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: AppColor.darkCardBackground,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(24.r), topRight: Radius.circular(24.r)),
        border: Border.all(color: AppColor.whiteColor(context).withValues(alpha: 0.08)),
      ),
      child: Column(
        children: [
          Center(
            child: Container(
              margin: EdgeInsets.only(top: 10.h, bottom: 4.h),
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(color: AppColor.whiteColor(context).withValues(alpha: 0.24), borderRadius: BorderRadius.circular(4.r)),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: const Color(0xFF171F2B),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(24.r), topRight: Radius.circular(24.r)),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [AppColor.purpleAccent, AppColor.emeraldTeal]),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(Icons.auto_awesome_rounded, color: AppColor.whiteColor(context), size: 18.r),
                ),
                Gap(10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppLocaleKey.aiAssistantTitle.tr(),
                          style: AppTextStyle.bodyMedium(context).copyWith(fontWeight: FontWeight.bold, color: AppColor.whiteColor(context))),
                      Text('Google AI Studio • Gemini',
                          style: AppTextStyle.bodySmall(context).copyWith(color: AppColor.emeraldTeal, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: _showApiKeyDialog,
                  icon: Icon(Icons.key_rounded, color: AppColor.emeraldTeal, size: 20.r),
                  tooltip: 'Google AI Studio Key',
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.keyboard_arrow_down_rounded, color: AppColor.whiteColor(context).withValues(alpha: 0.7), size: 24.r),
                ),
              ],
            ),
          ),
          Container(
            height: 38.h,
            padding: EdgeInsets.symmetric(vertical: 4.h),
            color: AppColor.darkBackground,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              itemCount: suggestions.length,
              itemBuilder: (context, idx) {
                final item = suggestions[idx];
                return GestureDetector(
                  onTap: () => _sendMessage(item['query']),
                  child: Container(
                    margin: EdgeInsets.only(right: 8.w),
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFF171F2B),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: AppColor.purpleAccent.withValues(alpha: 0.3)),
                    ),
                    child: Center(
                      child: Text(
                        item['label']!,
                        style: AppTextStyle.bodySmall(context).copyWith(color: AppColor.skyBlue),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(14.r),
              itemCount: _messages.length + (_isThinking ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isThinking) {
                  return _buildThinkingIndicator();
                }
                final msg = _messages[index];
                return _buildChatBubble(msg['text']!, msg['role'] == 'user');
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: const Color(0xFF171F2B),
              border: Border(top: BorderSide(color: AppColor.whiteColor(context).withValues(alpha: 0.06))),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 13.sp, color: AppColor.whiteColor(context)),
                    decoration: InputDecoration(
                      hintText: AppLocaleKey.aiInputHint.tr(),
                      hintStyle: TextStyle(fontSize: 12.sp, color: AppColor.whiteColor(context).withValues(alpha: 0.38)),
                      filled: true,
                      fillColor: AppColor.darkBackground,
                      contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.r), borderSide: BorderSide.none),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                Gap(8.w),
                GestureDetector(
                  onTap: () => _sendMessage(),
                  child: Container(
                    padding: EdgeInsets.all(12.r),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [AppColor.purpleAccent, AppColor.emeraldTeal]),
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    child: Icon(Icons.send_rounded, color: AppColor.whiteColor(context), size: 18.r),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThinkingIndicator() {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h, right: 0, left: 40.w),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: AppColor.darkSurface,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColor.emeraldTeal.withValues(alpha: 0.2)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            LoadingAnimationWidget.threeArchedCircle(color: AppColor.emeraldTeal, size: 18.r),
            Gap(10.w),
            Text(
              AppLocaleKey.aiThinking.tr(),
              style: TextStyle(fontSize: 11.sp, color: AppColor.whiteColor(context).withValues(alpha: 0.7)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatBubble(String text, bool isUser) {
    return Align(
      alignment: isUser ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h, left: isUser ? 0 : 36.w, right: isUser ? 36.w : 0),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        decoration: BoxDecoration(
          gradient: isUser ? LinearGradient(colors: [AppColor.purpleAccent, AppColor.oceanBlue]) : null,
          color: isUser ? null : AppColor.darkSurface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
            bottomLeft: isUser ? Radius.circular(4.r) : Radius.circular(16.r),
            bottomRight: isUser ? Radius.circular(16.r) : Radius.circular(4.r),
          ),
          border: isUser ? null : Border.all(color: AppColor.whiteColor(context).withValues(alpha: 0.05)),
        ),
        child: Text(
          text,
          textAlign: TextAlign.start,
          style: AppTextStyle.bodySmall(context).copyWith(color: AppColor.whiteColor(context).withValues(alpha: 0.95), height: 1.5),
        ),
      ),
    );
  }
}
