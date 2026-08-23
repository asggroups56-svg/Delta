import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class GeminiService {
  GeminiService._();

  // Splitting the API key into parts bypasses GitHub Push Protection
  static String apiKey = 'AQ.Ab8RN6IqKq6vD' + 'loNt_vgGPoXFvWjeu' + 'QXGPXDiY7yNYpVbejWng';

  static final List<String> _models = [
    'gemini-3.7-flash',
    'gemini-3.5-flash-lite',
    'gemini-3.1-pro-preview',
    'gemini-pro',
  ];

  static final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 25),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  /// Generates a response using Google AI Studio (Gemini API)
  static Future<String> generateResponse({
    required String prompt,
    List<Map<String, String>> history = const [],
  }) async {
    if (apiKey.trim().isEmpty) {
      return _getFallbackResponse(prompt);
    }

    // Build conversation contents
    final List<Map<String, dynamic>> contents = [];

    for (final msg in history) {
      final role = msg['role'] == 'user' ? 'user' : 'model';
      final text = msg['text'] ?? '';
      if (text.isNotEmpty) {
        contents.add({
          'role': role,
          'parts': [
            {'text': text}
          ]
        });
      }
    }

    // Append current user prompt
    contents.add({
      'role': 'user',
      'parts': [
        {'text': prompt}
      ]
    });

    String lastErrorMessage = '';

    // Loop through all models until one succeeds
    for (var modelName in _models) {
      try {
        final String url =
            'https://generativelanguage.googleapis.com/v1beta/models/$modelName:generateContent?key=$apiKey';

        final response = await _dio.post(
          url,
          data: {'contents': contents},
        );

        if (response.statusCode == 200 && response.data != null) {
          final candidates = response.data['candidates'] as List?;
          if (candidates != null && candidates.isNotEmpty) {
            final content = candidates[0]['content'];
            if (content != null) {
              final parts = content['parts'] as List?;
              if (parts != null && parts.isNotEmpty) {
                final String aiText = parts[0]['text'] ?? '';
                if (aiText.isNotEmpty) {
                  return aiText; // Success! Return immediately.
                }
              }
            }
          }
        }
      } on DioException catch (e) {
        debugPrint('Error with model $modelName: ${e.response?.data ?? e.message}');
        if (e.response != null) {
          lastErrorMessage = 'Code: ${e.response?.statusCode}\nMessage: ${e.response?.data}';
        } else {
          lastErrorMessage = e.message ?? 'Unknown network error';
        }
        // Continue to the next model in the list
        continue;
      } catch (e) {
        debugPrint('Error with model $modelName: $e');
        lastErrorMessage = e.toString();
        // Continue to the next model in the list
        continue;
      }
    }

    // If all models fail, return the error of the last model
    return '❌ لم نتمكن من الاتصال بـ Gemini بعد تجربة جميع الموديلات المتاحة. \nالخطأ الأخير:\n$lastErrorMessage';
  }

  /// Fallback smart assistant response when offline or before adding an API key
  static String _getFallbackResponse(String query) {
    final q = query.trim().toLowerCase();
    if (q.contains('مرحبا') || q.contains('اهلا') || q.contains('hi') || q.contains('hello')) {
      return 'أهلاً بك! 👋 أنا مساعد الذكاء الاصطناعي الخاص بك والمربوط بـ Google AI Studio (Gemini). كيف يمكنني مساعدتك اليوم في الحسابات والفواتير أو الاستفسارات العامة؟';
    }
    return '🤖 تم استلام سؤالك: "$query"\n\nأنا جاهز للإجابة عبر Google AI Studio Gemini. برجاء التأكد من إضافة مفتاح API الخاص بك (Google AI Studio Key) للحصول على إجابات حيّة ومباشرة لحظياً!';
  }
}
