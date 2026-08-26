import 'dart:convert';
import 'package:http/http.dart' as http;

/// بيكلم Google Gemini مباشرة من التطبيق (مجاني ضمن حدود سخية).
/// اعمل مفتاحك من https://aistudio.google.com/apikey
class GeminiService {
  /// المفتاح بيتخزن في الذاكرة بس (بيتصفر لو قفلت التطبيق).
  /// لو عايز يفضل محفوظ بين الجلسات، خزّنه بـ shared_preferences بدل الـ static.
  static String apiKey = '';

  static const String _model = 'gemini-3.5-flash-lite';
  static String get _baseUrl =>
      'https://generativelanguage.googleapis.com/v1beta/models/$_model:generateContent';

  static const String _systemPrompt =
      'أنت مساعد ذكي داخل تطبيق، جاوب بشكل واضح ومختصر وبنفس لغة السؤال.';

  /// [history] ليست بنفس شكل اللي مستخدمها في AiChatBottomSheetWidget:
  /// كل عنصر فيه {'role': 'user' أو 'ai', 'text': '...'}
  static Future<String> generateResponse({
    required String prompt,
    required List<Map<String, String>> history,
  }) async {
    if (apiKey.trim().isEmpty) {
      return 'من فضلك أدخل مفتاح Google AI Studio أولاً من الأيقونة 🔑 فوق.';
    }

    final contents = <Map<String, dynamic>>[];

    // بنحوّل الـ history (من غير رسالة الترحيب الأولى) لصيغة Gemini
    for (final msg in history) {
      if (msg['role'] == null || msg['text'] == null) continue;
      contents.add({
        'role': msg['role'] == 'user' ? 'user' : 'model',
        'parts': [
          {'text': msg['text']}
        ],
      });
    }

    // آخر رسالة (السؤال الحالي) لو لسه مش مضافة
    if (contents.isEmpty || contents.last['parts'][0]['text'] != prompt) {
      contents.add({
        'role': 'user',
        'parts': [
          {'text': prompt}
        ],
      });
    }

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl?key=$apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'system_instruction': {
            'parts': [
              {'text': _systemPrompt}
            ]
          },
          'contents': contents,
        }),
      );

      if (response.statusCode != 200) {
        final decodedError = jsonDecode(utf8.decode(response.bodyBytes));
        final message = decodedError['error']?['message'] ?? 'خطأ غير معروف';
        throw GeminiException('فشل الاتصال بـ Gemini ($message)');
      }

      final decoded = jsonDecode(utf8.decode(response.bodyBytes));
      final text = decoded['candidates']?[0]?['content']?['parts']?[0]?['text'];

      if (text == null || text is! String || text.trim().isEmpty) {
        throw GeminiException('الرد جه فاضي من Gemini');
      }

      return text.trim();
    } on GeminiException {
      rethrow;
    } catch (e) {
      throw GeminiException('حصل خطأ أثناء الاتصال: $e');
    }
  }
}

class GeminiException implements Exception {
  final String message;
  GeminiException(this.message);
  @override
  String toString() => message;
}
