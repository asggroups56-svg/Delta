class CategoryLightModel {
  final int categoryNo;
  final String categoryName;

  const CategoryLightModel({
    required this.categoryNo,
    required this.categoryName,
  });

  factory CategoryLightModel.fromJson(Map<String, dynamic> json) {
    final normalized = {
      for (final entry in json.entries)
        entry.key.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), ''):
            entry.value,
    };
    final code = _firstValue(normalized, const [
      'acccatid',
      'accountcatid',
      'centercatid',
      'acccatno',
      'accountcatno',
      'centercatno',
      'categoryno',
      'catno',
      'catid',
      'categorycode',
      'catcode',
      'centerNo',
      'id',
    ]);
    final categoryNo = code is num ? code.toInt() : int.tryParse('$code');
    if (categoryNo == null) {
      throw FormatException(
        'Category response item is missing a valid category number. '
        'Available fields: ${json.keys.join(', ')}.',
      );
    }

    final name = _firstValue(normalized, const [
      'acccatname',
      'acccatename',
      'acccatnameeng',
      'accountcatname',
      'accountcatename',
      'centercatname',
      'ecentercatname',
      'categoryname',
      'catname',
      'ecatname',
      'centername',
      'name',
    ]);
    return CategoryLightModel(
      categoryNo: categoryNo,
      categoryName: name?.toString() ?? categoryNo.toString(),
    );
  }

  static dynamic _firstValue(Map<String, dynamic> values, List<String> keys) {
    for (final key in keys) {
      final value = values[key.toLowerCase()];
      if (value != null) return value;
    }
    return null;
  }
}

class CategoryLightResponse {
  final List<CategoryLightModel> categories;

  const CategoryLightResponse({required this.categories});

  factory CategoryLightResponse.fromJson(dynamic response) {
    final items = _findCategoryList(response);
    if (items == null) {
      throw const FormatException(
        'Category response does not contain a category list.',
      );
    }
    return CategoryLightResponse(
      categories: items
          .map(
            (item) => CategoryLightModel.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList(),
    );
  }

  static List<dynamic>? _findCategoryList(dynamic value) {
    if (value is List) return value;
    if (value is! Map) return null;
    for (final entry in value.entries) {
      if (entry.key is String &&
          (entry.key as String).toLowerCase().contains('cat') &&
          entry.value is List) {
        return entry.value as List<dynamic>;
      }
    }
    for (final entry in value.values) {
      final nested = _findCategoryList(entry);
      if (nested != null) return nested;
    }
    return null;
  }
}
