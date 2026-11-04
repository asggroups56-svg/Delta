class AssistantCodeLightModel {
  final int assistantCode;
  final String assistantName;

  const AssistantCodeLightModel({
    required this.assistantCode,
    required this.assistantName,
  });

  factory AssistantCodeLightModel.fromJson(Map<String, dynamic> json) {
    final normalized = {
      for (final entry in json.entries)
        entry.key.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), ''):
            entry.value,
    };
    int? parseCode(dynamic raw) {
      if (raw is num) return raw.toInt();
      return int.tryParse(raw?.toString() ?? '');
    }

    final exactCodeKeys = [
      'asscode',
      'assistantcode',
      'assistantcodeno',
      'assistantcodenumber',
      'assistantcodeid',
      'assistantaccountcode',
      'assistantaccountno',
      'assistantaccountnumber',
      'assistantaccountid',
      'assistantno',
      'accountno',
      'accountnumber',
      'accountcode',
      'codeno',
      'codenumber',
      'codeid',
      'code',
      'id',
    ];
    int? code;
    for (final key in exactCodeKeys) {
      code = parseCode(normalized[key]);
      if (code != null) break;
    }
    if (code == null) {
      for (final entry in normalized.entries) {
        final key = entry.key;
        if (key.contains('assistant') &&
            (key.contains('code') ||
                key.contains('number') ||
                key.endsWith('no') ||
                key.endsWith('id'))) {
          code = parseCode(entry.value);
          if (code != null) break;
        }
      }
    }
    if (code == null) {
      final numericEntries = normalized.entries
          .where((entry) => parseCode(entry.value) != null)
          .toList();
      if (numericEntries.length == 1) {
        code = parseCode(numericEntries.single.value);
      }
    }
    if (code == null) {
      throw FormatException(
        'Assistant code response item is missing a valid code. '
        'Available fields: ${json.keys.join(', ')}.',
      );
    }

    final name =
        normalized['assname'] ??
        normalized['assename'] ??
        normalized['assistantname'] ??
        normalized['assistantcodename'] ??
        normalized['assistantaccountname'] ??
        normalized['assistantnamear'] ??
        normalized['assistantnameeng'] ??
        normalized['accountname'] ??
        normalized['name'];
    return AssistantCodeLightModel(
      assistantCode: code,
      assistantName: name?.toString() ?? code.toString(),
    );
  }
}

class AssistantCodeLightResponse {
  final List<AssistantCodeLightModel> assistantCodes;

  const AssistantCodeLightResponse({required this.assistantCodes});

  factory AssistantCodeLightResponse.fromJson(dynamic response) {
    final items = _findAssistantCodeList(response);
    if (items == null) {
      throw const FormatException(
        'Assistant code response does not contain a code list.',
      );
    }
    return AssistantCodeLightResponse(
      assistantCodes: items
          .map(
            (item) => AssistantCodeLightModel.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList(),
    );
  }

  static List<dynamic>? _findAssistantCodeList(dynamic value) {
    if (value is List) return value;
    if (value is! Map) return null;

    for (final entry in value.entries) {
      if (entry.key is String &&
          (entry.key as String).toLowerCase().contains('assistant') &&
          entry.value is List) {
        return entry.value as List<dynamic>;
      }
    }
    for (final entry in value.values) {
      final nested = _findAssistantCodeList(entry);
      if (nested != null) return nested;
    }
    return null;
  }
}
